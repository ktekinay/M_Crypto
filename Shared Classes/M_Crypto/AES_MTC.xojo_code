#tag Class
Class AES_MTC
Inherits M_Crypto.Encrypter
	#tag Event
		Sub CloneFrom(e As M_Crypto.Encrypter)
		  dim other as M_Crypto.AES_MTC = M_Crypto.AES_MTC( e )
		  
		  KeyExpSize = other.KeyExpSize
		  KeyLen = other.KeyLen
		  Nk = other.Nk
		  NumberOfRounds = other.NumberOfRounds
		  if other.RoundKey isa object then
		    RoundKey = other.RoundKey.LeftB( other.RoundKey.Size )
		  end if
		  zBits = other.zBits
		End Sub
	#tag EndEvent

	#tag Event
		Sub Decrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case Functions.Default, Functions.ECB
		    DecryptMbECB data
		    
		  case Functions.CBC
		    DecryptMbCBC data, isFinalBlock
		    
		  case Functions.CFB, Functions.OFB
		    DecryptMbVector data, type, isFinalBlock
		    
		  case else
		    raise new M_Crypto.UnsupportedFunctionException
		    
		  end select
		End Sub
	#tag EndEvent

	#tag Event
		Sub Encrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case Functions.Default, Functions.ECB
		    EncryptMbECB data
		    
		  case Functions.CBC
		    EncryptMbCBC data, isFinalBlock
		    
		  case Functions.CFB, Functions.OFB
		    EncryptMbVector data, type, isFinalBlock
		    
		  case else
		    raise new M_Crypto.UnsupportedFunctionException
		    
		  end select
		End Sub
	#tag EndEvent

	#tag Event
		Sub KeyChanged(key As String)
		  ExpandKey key
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub AddRoundKey(round As Integer, dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Cipher and InvCipher
		  //
		  
		  dim roundKeyPtr as ptr = RoundKey
		  
		  for i as integer = 0 to 3
		    for j as integer = 0 to 3
		      dim dataIndex as integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor roundKeyPtr.Byte( round * kNb * 4 + i * kNb + j )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = false
		Attributes( deprecated ) Private Sub Cipher(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Encrypt
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  //
		  // Used for ShiftRows
		  //
		  dim row0col0 as integer = startAt + 0
		  dim row0col1 as integer = startAt + 4
		  dim row0col2 as integer = startAt + 8
		  dim row0col3 as integer = startAt + 12
		  
		  dim row1col0 as integer = row0col0 + 1
		  dim row1col1 as integer = row0col1 + 1
		  dim row1col2 as integer = row0col2 + 1
		  dim row1col3 as integer = row0col3 + 1
		  
		  dim row2col0 as integer = row0col0 + 2
		  dim row2col1 as integer = row0col1 + 2
		  dim row2col2 as integer = row0col2 + 2
		  dim row2col3 as integer = row0col3 + 2
		  
		  dim row3col0 as integer = row0col0 + 3
		  dim row3col1 as integer = row0col1 + 3
		  dim row3col2 as integer = row0col2 + 3
		  dim row3col3 as integer = row0col3 + 3
		  
		  dim sboxPtr as ptr = Sbox
		  dim round as integer = 0
		  
		  //
		  // AddRoundKey
		  // Add the First round key to the dataPtr, startAt before starting the rounds.
		  //
		  dim roundKeyPtr as ptr = RoundKey
		  
		  for i as integer = 0 to 3
		    for j as integer = 0 to 3
		      dim dataIndex as integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor roundKeyPtr.Byte( round * kNb * 4 + i * kNb + j )
		    next
		  next
		  
		  //
		  // There will be NumberOfRounds rounds.
		  // The first NumberOfRounds-1 rounds are identical.
		  // These NumberOfRounds-1 rounds are executed in the loop below.
		  //
		  for round = 1 to NumberOfRounds
		    
		    //
		    // Subbytes
		    //
		    for i as integer = 0 to 3
		      for j as integer = 0 to 3
		        dim dataIndex as integer = ( j * 4 + i ) + startAt
		        dataPtr.Byte( dataIndex ) = sboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      next
		    next
		    
		    //
		    // ShiftRows
		    //
		    dim temp as byte 
		    
		    //
		    // Rotate first row 1 column to left  
		    //
		    temp = dataPtr.Byte( row1col0 )
		    dataPtr.Byte( row1col0 ) = dataPtr.Byte( row1col1 )
		    dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col2 )
		    dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col3 )
		    dataPtr.Byte( row1col3 ) = temp
		    
		    //
		    // Rotate second row 2 columns to left  
		    //
		    temp = dataPtr.Byte( row2col0 )
		    dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		    dataPtr.Byte( row2col2 ) = temp
		    
		    temp = dataPtr.Byte( row2col1 )
		    dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		    dataPtr.Byte( row2col3 ) = temp
		    
		    //
		    // Rotate third row 3 columns to left
		    //
		    temp = dataPtr.Byte( row3col0 )
		    dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col3 )
		    dataPtr.Byte( row3col3 ) = dataPtr.Byte( row3col2 )
		    dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col1 )
		    dataPtr.Byte( row3col1 ) = temp
		    
		    if round <> NumberOfRounds then
		      //
		      // MixColumns (not for last round)
		      //
		      const kOne as integer = 1
		      const kShift1 as integer = 2
		      const kShift7 as integer = 128
		      const kXtimeMult as integer = &h1B
		      
		      for i as integer = 0 to 3
		        dim dataIndex as integer = ( i * 4 ) + startAt
		        
		        dim byte0 as byte = dataPtr.Byte( dataIndex + 0 )
		        dim byte1 as byte = dataPtr.Byte( dataIndex + 1 )
		        dim byte2 as byte = dataPtr.Byte( dataIndex + 2 )
		        dim byte3 as byte = dataPtr.Byte( dataIndex + 3 )
		        
		        dim tmp as integer = byte0 xor byte1 xor byte2 xor byte3
		        
		        dim tm as integer
		        
		        tm = byte0 xor byte1
		        tm = xtimePtr.Byte( tm )
		        
		        dataPtr.Byte( dataIndex + 0 ) = byte0 xor ( tm xor tmp )
		        
		        tm = byte1 xor byte2
		        tm = xtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 1 ) = byte1 xor ( tm xor tmp )
		        
		        tm = byte2 xor byte3
		        tm = xtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 2 ) = byte2 xor ( tm xor tmp )
		        
		        tm = byte3 xor byte0
		        tm = xtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 3 ) = byte3 xor ( tm xor tmp )
		      next
		    end if
		    
		    //
		    // AddRoundKey
		    //
		    for i as integer = 0 to 3
		      for j as integer = 0 to 3
		        dim dataIndex as integer = ( i * 4 + j ) + startAt
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor roundKeyPtr.Byte( round * kNb * 4 + i * kNb + j )
		      next
		    next
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(bits As EncryptionBits, paddingMethod As Padding=Padding.PKCS)
		  Constructor "", bits, paddingMethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(bits As Integer, paddingMethod As Padding = Padding.PKCS)
		  Constructor "", EncryptionBits( bits ), paddingMethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(key As String, bits As EncryptionBits=EncryptionBits.Bits128, paddingMethod As Padding=Padding.PKCS)
		  if XtimeMB is nil then
		    //
		    // Needs to be initialized
		    //
		    InitXtime
		    InitMultiplyTables
		    InitSbox
		    InitInvSbox
		    InitRcon
		  end if
		  
		  SetBlockSize kBlockLen
		  
		  self.zBits = Integer( bits )
		  self.PaddingMethod = paddingMethod
		  
		  select case bits
		  case AES_MTC.EncryptionBits.Bits256
		    Nk = 8
		    KeyLen = 32
		    NumberOfRounds = 14
		    KeyExpSize = 240
		    
		  case AES_MTC.EncryptionBits.Bits192
		    Nk = 6
		    KeyLen = 24
		    NumberOfRounds = 12
		    KeyExpSize = 208
		    
		  case AES_MTC.EncryptionBits.Bits128
		    Nk = 4
		    KeyLen = 16
		    NumberOfRounds = 10
		    KeyExpSize = 176
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		  
		  if key <> "" then
		    SetKey key
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptMbCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  //
		  // Dereference pointers
		  //
		  var multiplyH9Ptr as ptr = MultiplyH9MB
		  var multiplyHBPtr as ptr = MultiplyHBMB
		  var multiplyHDPtr as ptr = MultiplyHDMB
		  var multiplyHEPtr as ptr = MultiplyHEMB
		  
		  dim dataPtr as ptr = data
		  dim roundKeyPtr as ptr = RoundKey
		  dim invSboxPtr as ptr = InvSbox
		  
		  dim temp as byte 
		  
		  //
		  // Copy the original data so we have source
		  // for the vector
		  //
		  dim originalData as MemoryBlock = data.LeftB( data.Size )
		  dim originalDataPtr as ptr = originalData
		  
		  dim vectorMB as MemoryBlock
		  if zCurrentVector isa object then
		    vectorMB = zCurrentVector.LeftB( kBlockLen )
		  elseif InitialVector <> "" then
		    vectorMB = InitialVector
		  else 
		    vectorMB = new MemoryBlock( kBlockLen )
		  end if
		  
		  dim vectorPtr as ptr = vectorMB
		  
		  dim dataIndex as integer
		  var dataIndex0 as integer
		  var dataIndex1 as integer
		  var dataIndex2 as integer
		  var dataIndex3 as integer
		  
		  var firstRoundKeyIndex as integer = NumberOfRounds * kNb * 4
		  var lastRound as integer = NumberOfRounds - 1
		  var round as integer
		  var roundKeyIndex as integer
		  
		  dim lastByte as integer = data.Size - 1
		  for startAt as integer = 0 to lastByte step kBlockLen
		    
		    'InvCipher dataPtr, startAt
		    
		    //
		    // AddRoundKey
		    // Add the First round key to the state before starting the rounds.
		    //
		    dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( firstRoundKeyIndex )
		    dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( firstRoundKeyIndex + 8 )
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    roundKeyIndex = ( lastRound + 1 ) * kNb * 4
		    for round = 0 to lastRound
		      //
		      // InvShiftRows
		      //
		      
		      //
		      // Rotate first row 1 columns to right
		      //
		      temp = dataPtr.Byte( row1col3 )
		      dataPtr.Byte( row1col3 ) = dataPtr.Byte( row1col2 )
		      dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col1 )
		      dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col0 )
		      dataPtr.Byte( row1col0 ) = temp
		      
		      //
		      // Rotate second row 2 columns to right 
		      //
		      temp = dataPtr.Byte( row2col0 )
		      dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		      dataPtr.Byte( row2col2 ) = temp
		      
		      temp = dataPtr.Byte( row2col1 )
		      dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		      dataPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to right
		      //
		      temp = dataPtr.Byte( row3col0 )
		      dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col1 )
		      dataPtr.Byte( row3col1 ) = dataPtr.Byte( row3col2 )
		      dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col3 )
		      dataPtr.Byte( row3col3 ) = temp
		      
		      //
		      // InvSubBytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = 0 to 15
		      'dataPtr.Byte( dataIndex ) = invSboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      'next
		      dataPtr.Byte( 0 ) = invSboxPtr.Byte( dataPtr.Byte( 0 ) )
		      dataPtr.Byte( 1 ) = invSboxPtr.Byte( dataPtr.Byte( 1 ) )
		      dataPtr.Byte( 2 ) = invSboxPtr.Byte( dataPtr.Byte( 2 ) )
		      dataPtr.Byte( 3 ) = invSboxPtr.Byte( dataPtr.Byte( 3 ) )
		      dataPtr.Byte( 4 ) = invSboxPtr.Byte( dataPtr.Byte( 4 ) )
		      dataPtr.Byte( 5 ) = invSboxPtr.Byte( dataPtr.Byte( 5 ) )
		      dataPtr.Byte( 6 ) = invSboxPtr.Byte( dataPtr.Byte( 6 ) )
		      dataPtr.Byte( 7 ) = invSboxPtr.Byte( dataPtr.Byte( 7 ) )
		      dataPtr.Byte( 8 ) = invSboxPtr.Byte( dataPtr.Byte( 8 ) )
		      dataPtr.Byte( 9 ) = invSboxPtr.Byte( dataPtr.Byte( 9 ) )
		      dataPtr.Byte( 10 ) = invSboxPtr.Byte( dataPtr.Byte( 10 ) )
		      dataPtr.Byte( 11 ) = invSboxPtr.Byte( dataPtr.Byte( 11 ) )
		      dataPtr.Byte( 12 ) = invSboxPtr.Byte( dataPtr.Byte( 12 ) )
		      dataPtr.Byte( 13 ) = invSboxPtr.Byte( dataPtr.Byte( 13 ) )
		      dataPtr.Byte( 14 ) = invSboxPtr.Byte( dataPtr.Byte( 14 ) )
		      dataPtr.Byte( 15 ) = invSboxPtr.Byte( dataPtr.Byte( 15 ) )
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex - 16
		      dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		      
		      if round <> lastRound then
		        //
		        // InvMixColumns (not for last round)
		        //
		        dataIndex = -4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dataIndex0 = dataIndex
		          dataIndex1 = dataIndex + 1
		          dataIndex2 = dataIndex + 2
		          dataIndex3 = dataIndex + 3
		          
		          dim byte0 as integer = dataPtr.Byte( dataIndex0 )
		          dim byte1 as integer = dataPtr.Byte( dataIndex1 )
		          dim byte2 as integer = dataPtr.Byte( dataIndex2 )
		          dim byte3 as integer = dataPtr.Byte( dataIndex3 )
		          
		          dataPtr.Byte( dataIndex0 ) = multiplyHEPtr.Byte( byte0 ) xor multiplyHBPtr.Byte( byte1 ) xor multiplyHDPtr.Byte( byte2 ) xor multiplyH9Ptr.Byte( byte3 )
		          dataPtr.Byte( dataIndex1 ) = multiplyH9Ptr.Byte( byte0 ) xor multiplyHEPtr.Byte( byte1 ) xor multiplyHBPtr.Byte( byte2 ) xor multiplyHDPtr.Byte( byte3 )
		          dataPtr.Byte( dataIndex2 ) = multiplyHDPtr.Byte( byte0 ) xor multiplyH9Ptr.Byte( byte1 ) xor multiplyHEPtr.Byte( byte2 ) xor multiplyHBPtr.Byte( byte3 )
		          dataPtr.Byte( dataIndex3 ) = multiplyHBPtr.Byte( byte0 ) xor multiplyHDPtr.Byte( byte1 ) xor multiplyH9Ptr.Byte( byte2 ) xor multiplyHEPtr.Byte( byte3 )
		        next i
		      end if
		    next
		    
		    'XorWithVector dataPtr, startAt, vectorPtr
		    dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor vectorPtr.UInt64( 0 )
		    dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor vectorPtr.UInt64( 8 )
		    
		    vectorPtr = ptr( integer( originalDataPtr ) + startAt )
		    dataPtr = ptr( integer( dataPtr ) + kBlockLen )
		  next
		  
		  if not isFinalBlock then
		    var trueVectorPtr as ptr = vectorMB
		    trueVectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 )
		    trueVectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 )
		    zCurrentVector = vectorMB
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptMbECB(data As MemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  //
		  // Dereference pointers
		  //
		  var multiplyH9Ptr as ptr = MultiplyH9MB
		  var multiplyHBPtr as ptr = MultiplyHBMB
		  var multiplyHDPtr as ptr = MultiplyHDMB
		  var multiplyHEPtr as ptr = MultiplyHEMB
		  
		  dim dataPtr as ptr = data
		  dim roundKeyPtr as ptr = RoundKey
		  dim invSboxPtr as ptr = InvSbox
		  
		  dim temp as byte 
		  
		  dim dataIndex as integer
		  var dataIndex0 as integer
		  var dataIndex1 as integer
		  var dataIndex2 as integer
		  var dataIndex3 as integer
		  
		  var firstRoundKeyIndex as integer = NumberOfRounds * kNb * 4
		  var lastRound as integer = NumberOfRounds - 1
		  var round as integer
		  var roundKeyIndex as integer
		  
		  dim lastIndex as integer = data.Size - 1
		  for startAt as integer = 0 to lastIndex step kBlockLen
		    
		    'InvCipher( dataPtr, startAt )
		    
		    //
		    // AddRoundKey
		    // Add the First round key to the state before starting the rounds.
		    //
		    dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( firstRoundKeyIndex )
		    dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( firstRoundKeyIndex + 8 )
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    roundKeyIndex = ( lastRound + 1 ) * kNb * 4
		    for round = 0 to lastRound
		      //
		      // InvShiftRows
		      //
		      
		      //
		      // Rotate first row 1 columns to right
		      //
		      temp = dataPtr.Byte( row1col3 )
		      dataPtr.Byte( row1col3 ) = dataPtr.Byte( row1col2 )
		      dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col1 )
		      dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col0 )
		      dataPtr.Byte( row1col0 ) = temp
		      
		      //
		      // Rotate second row 2 columns to right 
		      //
		      temp = dataPtr.Byte( row2col0 )
		      dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		      dataPtr.Byte( row2col2 ) = temp
		      
		      temp = dataPtr.Byte( row2col1 )
		      dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		      dataPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to right
		      //
		      temp = dataPtr.Byte( row3col0 )
		      dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col1 )
		      dataPtr.Byte( row3col1 ) = dataPtr.Byte( row3col2 )
		      dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col3 )
		      dataPtr.Byte( row3col3 ) = temp
		      
		      //
		      // InvSubBytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = 0 to 15
		      'dataPtr.Byte( dataIndex ) = invSboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      'next
		      dataPtr.Byte( 0 ) = invSboxPtr.Byte( dataPtr.Byte( 0 ) )
		      dataPtr.Byte( 1 ) = invSboxPtr.Byte( dataPtr.Byte( 1 ) )
		      dataPtr.Byte( 2 ) = invSboxPtr.Byte( dataPtr.Byte( 2 ) )
		      dataPtr.Byte( 3 ) = invSboxPtr.Byte( dataPtr.Byte( 3 ) )
		      dataPtr.Byte( 4 ) = invSboxPtr.Byte( dataPtr.Byte( 4 ) )
		      dataPtr.Byte( 5 ) = invSboxPtr.Byte( dataPtr.Byte( 5 ) )
		      dataPtr.Byte( 6 ) = invSboxPtr.Byte( dataPtr.Byte( 6 ) )
		      dataPtr.Byte( 7 ) = invSboxPtr.Byte( dataPtr.Byte( 7 ) )
		      dataPtr.Byte( 8 ) = invSboxPtr.Byte( dataPtr.Byte( 8 ) )
		      dataPtr.Byte( 9 ) = invSboxPtr.Byte( dataPtr.Byte( 9 ) )
		      dataPtr.Byte( 10 ) = invSboxPtr.Byte( dataPtr.Byte( 10 ) )
		      dataPtr.Byte( 11 ) = invSboxPtr.Byte( dataPtr.Byte( 11 ) )
		      dataPtr.Byte( 12 ) = invSboxPtr.Byte( dataPtr.Byte( 12 ) )
		      dataPtr.Byte( 13 ) = invSboxPtr.Byte( dataPtr.Byte( 13 ) )
		      dataPtr.Byte( 14 ) = invSboxPtr.Byte( dataPtr.Byte( 14 ) )
		      dataPtr.Byte( 15 ) = invSboxPtr.Byte( dataPtr.Byte( 15 ) )
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex - 16
		      dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		      
		      if round <> lastRound then
		        //
		        // InvMixColumns (not for last round)
		        //
		        dataIndex = -4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dataIndex0 = dataIndex
		          dataIndex1 = dataIndex + 1
		          dataIndex2 = dataIndex + 2
		          dataIndex3 = dataIndex + 3
		          
		          dim byte0 as integer = dataPtr.Byte( dataIndex0 )
		          dim byte1 as integer = dataPtr.Byte( dataIndex1 )
		          dim byte2 as integer = dataPtr.Byte( dataIndex2 )
		          dim byte3 as integer = dataPtr.Byte( dataIndex3 )
		          
		          dataPtr.Byte( dataIndex0 ) = multiplyHEPtr.Byte( byte0 ) xor multiplyHBPtr.Byte( byte1 ) xor multiplyHDPtr.Byte( byte2 ) xor multiplyH9Ptr.Byte( byte3 )
		          dataPtr.Byte( dataIndex1 ) = multiplyH9Ptr.Byte( byte0 ) xor multiplyHEPtr.Byte( byte1 ) xor multiplyHBPtr.Byte( byte2 ) xor multiplyHDPtr.Byte( byte3 )
		          dataPtr.Byte( dataIndex2 ) = multiplyHDPtr.Byte( byte0 ) xor multiplyH9Ptr.Byte( byte1 ) xor multiplyHEPtr.Byte( byte2 ) xor multiplyHBPtr.Byte( byte3 )
		          dataPtr.Byte( dataIndex3 ) = multiplyHBPtr.Byte( byte0 ) xor multiplyHDPtr.Byte( byte1 ) xor multiplyH9Ptr.Byte( byte2 ) xor multiplyHEPtr.Byte( byte3 )
		        next i
		      end if
		    next round
		    
		    dataPtr = ptr( integer( dataPtr ) + kBlockLen )
		  next startAt
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptMbVector(data As MemoryBlock, type As Functions, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  dim dataPtr as ptr = data
		  dim roundKeyPtr as ptr = RoundKey
		  dim sboxPtr as ptr = Sbox
		  
		  dim vectorMB as MemoryBlock = zCurrentVector
		  
		  if vectorMB is nil and InitialVector <> "" then
		    vectorMB = InitialVector
		  end if
		  if vectorMB is nil then
		    vectorMB = new MemoryBlock( kBlockLen )
		  end if
		  
		  dim vectorPtr as ptr = vectorMB
		  
		  dim saveVectorPtr as ptr = zSaveVector
		  
		  dim temp as byte 
		  dim temp2 as byte
		  dim diff as integer
		  dim vectorIndex as integer
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  dim dataIndex as integer
		  dim lastByte as integer = data.Size - 1
		  for startAt as integer = 0 to lastByte step kBlockLen
		    
		    'Cipher vectorPtr, startAt
		    
		    dim round as integer = 0
		    
		    //
		    // AddRoundKey
		    // Add the First round key to the vectorPtr before starting the rounds
		    //
		    vectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( 0 )
		    vectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( 8 )
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    var roundKeyIndex as integer = 0
		    for round = 1 to NumberOfRounds
		      
		      //
		      // Subbytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = startAt to endAt
		      'vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      'next
		      dataIndex = 0
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      
		      //
		      // ShiftRows
		      //
		      
		      //
		      // Rotate first row 1 column to left  
		      //
		      temp = vectorPtr.Byte( row1col0 )
		      vectorPtr.Byte( row1col0 ) = vectorPtr.Byte( row1col1 )
		      vectorPtr.Byte( row1col1 ) = vectorPtr.Byte( row1col2 )
		      vectorPtr.Byte( row1col2 ) = vectorPtr.Byte( row1col3 )
		      vectorPtr.Byte( row1col3 ) = temp
		      
		      //
		      // Rotate second row 2 columns to left  
		      //
		      temp = vectorPtr.Byte( row2col0 )
		      vectorPtr.Byte( row2col0 ) = vectorPtr.Byte( row2col2 )
		      vectorPtr.Byte( row2col2 ) = temp
		      
		      temp = vectorPtr.Byte( row2col1 )
		      vectorPtr.Byte( row2col1 ) = vectorPtr.Byte( row2col3 )
		      vectorPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to left
		      //
		      temp = vectorPtr.Byte( row3col0 )
		      vectorPtr.Byte( row3col0 ) = vectorPtr.Byte( row3col3 )
		      vectorPtr.Byte( row3col3 ) = vectorPtr.Byte( row3col2 )
		      vectorPtr.Byte( row3col2 ) = vectorPtr.Byte( row3col1 )
		      vectorPtr.Byte( row3col1 ) = temp
		      
		      if round <> NumberOfRounds then
		        //
		        // MixColumns (not for last round)
		        //
		        dataIndex = -4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dim byte0 as byte = vectorPtr.Byte( dataIndex + 0 )
		          dim byte1 as byte = vectorPtr.Byte( dataIndex + 1 )
		          dim byte2 as byte = vectorPtr.Byte( dataIndex + 2 )
		          dim byte3 as byte = vectorPtr.Byte( dataIndex + 3 )
		          
		          temp = byte0 xor byte1 xor byte2 xor byte3
		          
		          temp2 = xtimePtr.Byte( byte0 xor byte1 )
		          vectorPtr.Byte( dataIndex + 0 ) = byte0 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte1 xor byte2 )
		          vectorPtr.Byte( dataIndex + 1 ) = byte1 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte2 xor byte3 )
		          vectorPtr.Byte( dataIndex + 2 ) = byte2 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte3 xor byte0 )
		          vectorPtr.Byte( dataIndex + 3 ) = byte3 xor ( temp2 xor temp )
		        next
		      end if
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex + 16
		      vectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      vectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		    next
		    
		    diff = lastByte - startAt + 1
		    
		    if type = Functions.CFB and diff >= kBlockLen then
		      saveVectorPtr.UInt64( 0 ) = dataPtr.UInt64( startAt )
		      saveVectorPtr.UInt64( 8 ) = dataPtr.UInt64( startAt + 8 )
		    end if
		    
		    'XorWithVector dataPtr, startAt, vectorPtr
		    dataIndex = startAt
		    vectorIndex = 0
		    do
		      select case diff
		      case is >= kBlockLen
		        // Optimization to save a loop
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( 0 )
		        dataIndex = dataIndex + 8
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( 8 )
		        exit
		      case is >= 8
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( vectorIndex )
		        dataIndex = dataIndex + 8
		        vectorIndex = vectorIndex + 8
		        diff = diff - 8
		      case is >= 4
		        dataPtr.UInt32( dataIndex ) = dataPtr.UInt32( dataIndex )  xor vectorPtr.UInt32( vectorIndex )
		        dataIndex = dataIndex + 4
		        vectorIndex = vectorIndex + 4
		        diff = diff - 4
		      case is >= 2
		        dataPtr.UInt16( dataIndex ) = dataPtr.UInt16( dataIndex )  xor vectorPtr.UInt16( vectorIndex )
		        dataIndex = dataIndex + 2
		        vectorIndex = vectorIndex + 2
		        diff = diff - 2
		      case else
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex )  xor vectorPtr.Byte( vectorIndex )
		        dataIndex = dataIndex + 1
		        vectorIndex = vectorIndex + 1
		        diff = diff - 1
		      end select
		    loop until vectorIndex = kBlockLen
		    
		    if type = Functions.CFB and diff >= kBlockLen then
		      vectorPtr.UInt64( 0 ) = saveVectorPtr.UInt64( 0 )
		      vectorPtr.UInt64( 8 ) = saveVectorPtr.UInt64( 8 )
		    end if
		    
		  next
		  
		  if not isFinalBlock then
		    zCurrentVector = vectorMB
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptMbCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  dim dataPtr as ptr = data
		  dim roundKeyPtr as ptr = RoundKey
		  dim sboxPtr as ptr = Sbox
		  
		  dim vectorMB as MemoryBlock = zCurrentVector
		  
		  if vectorMB is nil and InitialVector <> "" then
		    vectorMB = InitialVector
		  end if
		  if vectorMB is nil then
		    vectorMB = new MemoryBlock( kBlockLen )
		  end if
		  
		  dim vectorPtr as ptr = vectorMB
		  
		  var round as integer
		  var roundKeyIndex as integer
		  
		  dim temp as byte 
		  dim temp2 as byte
		  
		  dim dataIndex as integer
		  var dataIndex0 as integer
		  var dataIndex1 as integer
		  var dataIndex2 as integer
		  var dataIndex3 as integer
		  
		  dim lastByte as integer = data.Size - 1
		  for startAt as integer = 0 to lastByte step kBlockLen
		    
		    //
		    // Apply vector and RoundKey
		    // Add the First round key to the dataPtr, startAt before starting the rounds.
		    //
		    'XorWithVector dataPtr, startAt, vectorPtr
		    dataPtr.UInt64( 0 ) = ( dataPtr.UInt64( 0 ) xor vectorPtr.UInt64( 0 ) ) xor roundKeyPtr.UInt64( 0 )
		    dataPtr.UInt64( 8 ) = ( dataPtr.UInt64( 8 ) xor vectorPtr.UInt64( 8 ) ) xor roundKeyPtr.UInt64( 8 )
		    
		    'Cipher dataPtr, startAt
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    roundKeyIndex = 0 // Incremented within the loop below
		    
		    for round = 1 to NumberOfRounds
		      
		      //
		      // Subbytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = 0 to 15
		      'dataPtr.Byte( dataIndex ) = sboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      'next
		      dataPtr.Byte(  0 ) = sboxPtr.Byte( dataPtr.Byte(  0 ) )
		      dataPtr.Byte(  1 ) = sboxPtr.Byte( dataPtr.Byte(  1 ) )
		      dataPtr.Byte(  2 ) = sboxPtr.Byte( dataPtr.Byte(  2 ) )
		      dataPtr.Byte(  3 ) = sboxPtr.Byte( dataPtr.Byte(  3 ) )
		      dataPtr.Byte(  4 ) = sboxPtr.Byte( dataPtr.Byte(  4 ) )
		      dataPtr.Byte(  5 ) = sboxPtr.Byte( dataPtr.Byte(  5 ) )
		      dataPtr.Byte(  6 ) = sboxPtr.Byte( dataPtr.Byte(  6 ) )
		      dataPtr.Byte(  7 ) = sboxPtr.Byte( dataPtr.Byte(  7 ) )
		      dataPtr.Byte(  8 ) = sboxPtr.Byte( dataPtr.Byte(  8 ) )
		      dataPtr.Byte(  9 ) = sboxPtr.Byte( dataPtr.Byte(  9 ) )
		      dataPtr.Byte( 10 ) = sboxPtr.Byte( dataPtr.Byte( 10 ) )
		      dataPtr.Byte( 11 ) = sboxPtr.Byte( dataPtr.Byte( 11 ) )
		      dataPtr.Byte( 12 ) = sboxPtr.Byte( dataPtr.Byte( 12 ) )
		      dataPtr.Byte( 13 ) = sboxPtr.Byte( dataPtr.Byte( 13 ) )
		      dataPtr.Byte( 14 ) = sboxPtr.Byte( dataPtr.Byte( 14 ) )
		      dataPtr.Byte( 15 ) = sboxPtr.Byte( dataPtr.Byte( 15 ) )
		      
		      //
		      // ShiftRows
		      //
		      
		      //
		      // Rotate first row 1 column to left  
		      //
		      temp = dataPtr.Byte( row1col0 )
		      dataPtr.Byte( row1col0 ) = dataPtr.Byte( row1col1 )
		      dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col2 )
		      dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col3 )
		      dataPtr.Byte( row1col3 ) = temp
		      
		      //
		      // Rotate second row 2 columns to left  
		      //
		      temp = dataPtr.Byte( row2col0 )
		      dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		      dataPtr.Byte( row2col2 ) = temp
		      
		      temp = dataPtr.Byte( row2col1 )
		      dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		      dataPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to left
		      //
		      temp = dataPtr.Byte( row3col0 )
		      dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col3 )
		      dataPtr.Byte( row3col3 ) = dataPtr.Byte( row3col2 )
		      dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col1 )
		      dataPtr.Byte( row3col1 ) = temp
		      
		      if round <> NumberOfRounds then
		        //
		        // MixColumns (not for last round)
		        //
		        dataIndex = 0 - 4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dataIndex0 = dataIndex
		          dataIndex1 = dataIndex + 1
		          dataIndex2 = dataIndex + 2
		          dataIndex3 = dataIndex + 3
		          
		          dim byte0 as byte = dataPtr.Byte( dataIndex0 )
		          dim byte1 as byte = dataPtr.Byte( dataIndex1 )
		          dim byte2 as byte = dataPtr.Byte( dataIndex2 )
		          dim byte3 as byte = dataPtr.Byte( dataIndex3 )
		          
		          temp = byte0 xor byte1 xor byte2 xor byte3
		          
		          temp2 = xtimePtr.Byte( byte0 xor byte1 )
		          dataPtr.Byte( dataIndex0 ) = byte0 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte1 xor byte2 )
		          dataPtr.Byte( dataIndex1 ) = byte1 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte2 xor byte3 )
		          dataPtr.Byte( dataIndex2 ) = byte2 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte3 xor byte0 )
		          dataPtr.Byte( dataIndex3 ) = byte3 xor ( temp2 xor temp )
		        next
		      end if
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex + kBlockLen
		      dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		    next
		    
		    vectorPtr = dataPtr
		    dataPtr = ptr( integer( dataPtr ) + kBlockLen )
		  next
		  
		  if not isFinalBlock then
		    var trueVectorPtr as ptr = vectorMB
		    trueVectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 )
		    trueVectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 )
		    zCurrentVector = vectorMB
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptMbECB(data As MemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  dim dataPtr as ptr = data // Incremented by the loop
		  dim roundKeyPtr as ptr = RoundKey
		  dim sboxPtr as ptr = Sbox
		  
		  dim temp as byte 
		  dim temp2 as byte
		  var round as integer
		  var roundKeyIndex as integer
		  
		  dim dataIndex as integer
		  var dataIndex0 as integer
		  var dataIndex1 as integer
		  var dataIndex2 as integer
		  var dataIndex3 as integer
		  
		  dim lastByte as integer = data.Size - 1
		  for startAt as integer = 0 to lastByte step kBlockLen
		    
		    'Cipher( dataPtr, 0 )
		    
		    //
		    // AddRoundKey
		    // Add the First round key to the dataPtr before starting the rounds.
		    //
		    dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( 0 )
		    dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( 8 )
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    roundKeyIndex = 0 // Incremented within the loop below
		    
		    for round = 1 to NumberOfRounds
		      
		      //
		      // Subbytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = 0 to 15
		      'dataPtr.Byte( dataIndex ) = sboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      'next
		      dataPtr.Byte(  0 ) = sboxPtr.Byte( dataPtr.Byte(  0 ) )
		      dataPtr.Byte(  1 ) = sboxPtr.Byte( dataPtr.Byte(  1 ) )
		      dataPtr.Byte(  2 ) = sboxPtr.Byte( dataPtr.Byte(  2 ) )
		      dataPtr.Byte(  3 ) = sboxPtr.Byte( dataPtr.Byte(  3 ) )
		      dataPtr.Byte(  4 ) = sboxPtr.Byte( dataPtr.Byte(  4 ) )
		      dataPtr.Byte(  5 ) = sboxPtr.Byte( dataPtr.Byte(  5 ) )
		      dataPtr.Byte(  6 ) = sboxPtr.Byte( dataPtr.Byte(  6 ) )
		      dataPtr.Byte(  7 ) = sboxPtr.Byte( dataPtr.Byte(  7 ) )
		      dataPtr.Byte(  8 ) = sboxPtr.Byte( dataPtr.Byte(  8 ) )
		      dataPtr.Byte(  9 ) = sboxPtr.Byte( dataPtr.Byte(  9 ) )
		      dataPtr.Byte( 10 ) = sboxPtr.Byte( dataPtr.Byte( 10 ) )
		      dataPtr.Byte( 11 ) = sboxPtr.Byte( dataPtr.Byte( 11 ) )
		      dataPtr.Byte( 12 ) = sboxPtr.Byte( dataPtr.Byte( 12 ) )
		      dataPtr.Byte( 13 ) = sboxPtr.Byte( dataPtr.Byte( 13 ) )
		      dataPtr.Byte( 14 ) = sboxPtr.Byte( dataPtr.Byte( 14 ) )
		      dataPtr.Byte( 15 ) = sboxPtr.Byte( dataPtr.Byte( 15 ) )
		      
		      //
		      // ShiftRows
		      //
		      
		      //
		      // Rotate first row 1 column to left  
		      //
		      temp = dataPtr.Byte( row1col0 )
		      dataPtr.Byte( row1col0 ) = dataPtr.Byte( row1col1 )
		      dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col2 )
		      dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col3 )
		      dataPtr.Byte( row1col3 ) = temp
		      
		      //
		      // Rotate second row 2 columns to left  
		      //
		      temp = dataPtr.Byte( row2col0 )
		      dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		      dataPtr.Byte( row2col2 ) = temp
		      
		      temp = dataPtr.Byte( row2col1 )
		      dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		      dataPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to left
		      //
		      temp = dataPtr.Byte( row3col0 )
		      dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col3 )
		      dataPtr.Byte( row3col3 ) = dataPtr.Byte( row3col2 )
		      dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col1 )
		      dataPtr.Byte( row3col1 ) = temp
		      
		      if round <> NumberOfRounds then
		        //
		        // MixColumns (not for last round)
		        //
		        dataIndex = 0 - 4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dataIndex0 = dataIndex
		          dataIndex1 = dataIndex + 1
		          dataIndex2 = dataIndex + 2
		          dataIndex3 = dataIndex + 3
		          
		          dim byte0 as byte = dataPtr.Byte( dataIndex0 )
		          dim byte1 as byte = dataPtr.Byte( dataIndex1 )
		          dim byte2 as byte = dataPtr.Byte( dataIndex2 )
		          dim byte3 as byte = dataPtr.Byte( dataIndex3 )
		          
		          temp = byte0 xor byte1 xor byte2 xor byte3
		          
		          temp2 = xtimePtr.Byte( byte0 xor byte1 )
		          dataPtr.Byte( dataIndex0 ) = byte0 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte1 xor byte2 )
		          dataPtr.Byte( dataIndex1 ) = byte1 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte2 xor byte3 )
		          dataPtr.Byte( dataIndex2 ) = byte2 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte3 xor byte0 )
		          dataPtr.Byte( dataIndex3 ) = byte3 xor ( temp2 xor temp )
		        next
		      end if
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex + kBlockLen
		      dataPtr.UInt64( 0 ) = dataPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      dataPtr.UInt64( 8 ) = dataPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		    next
		    
		    dataPtr = ptr( integer( dataPtr ) + kBlockLen )
		  next startAt
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptMbVector(data As MemoryBlock, type As Functions, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  dim dataPtr as ptr = data
		  dim roundKeyPtr as ptr = RoundKey
		  dim sboxPtr as ptr = Sbox
		  
		  dim vectorMB as MemoryBlock = zCurrentVector
		  
		  if vectorMB is nil and InitialVector <> "" then
		    vectorMB = InitialVector
		  end if
		  if vectorMB is nil then
		    vectorMB = new MemoryBlock( kBlockLen )
		  end if
		  
		  dim vectorPtr as ptr = vectorMB
		  
		  dim temp as byte 
		  dim temp2 as byte
		  dim vectorIndex as integer
		  dim diff as integer
		  
		  //
		  // Used for ShiftRows
		  //
		  const row0col0 as integer = 0
		  const row0col1 as integer = 4
		  const row0col2 as integer = 8
		  const row0col3 as integer = 12
		  
		  const row1col0 as integer = row0col0 + 1
		  const row1col1 as integer = row0col1 + 1
		  const row1col2 as integer = row0col2 + 1
		  const row1col3 as integer = row0col3 + 1
		  
		  const row2col0 as integer = row0col0 + 2
		  const row2col1 as integer = row0col1 + 2
		  const row2col2 as integer = row0col2 + 2
		  const row2col3 as integer = row0col3 + 2
		  
		  const row3col0 as integer = row0col0 + 3
		  const row3col1 as integer = row0col1 + 3
		  const row3col2 as integer = row0col2 + 3
		  const row3col3 as integer = row0col3 + 3
		  
		  dim dataIndex as integer
		  dim lastByte as integer = data.Size - 1
		  for startAt as integer = 0 to lastByte step kBlockLen
		    
		    'Cipher vectorPtr, startAt
		    
		    dim round as integer = 0
		    
		    //
		    // AddRoundKey
		    // Add the First round key to the vectorPtr before starting the rounds
		    //
		    vectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( 0 )
		    vectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( 8 )
		    
		    //
		    // There will be NumberOfRounds rounds.
		    // The first NumberOfRounds-1 rounds are identical.
		    // These NumberOfRounds-1 rounds are executed in the loop below.
		    //
		    var roundKeyIndex as integer = 0 // Incremented within the loop below
		    for round = 1 to NumberOfRounds
		      
		      //
		      // Subbytes
		      //
		      // Unroll this loop
		      //
		      'for dataIndex = startAt to endAt
		      'vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      'next
		      dataIndex = 0
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      dataIndex = dataIndex + 1
		      vectorPtr.Byte( dataIndex ) = sboxPtr.Byte( vectorPtr.Byte( dataIndex ) )
		      
		      //
		      // ShiftRows
		      //
		      
		      //
		      // Rotate first row 1 column to left  
		      //
		      temp = vectorPtr.Byte( row1col0 )
		      vectorPtr.Byte( row1col0 ) = vectorPtr.Byte( row1col1 )
		      vectorPtr.Byte( row1col1 ) = vectorPtr.Byte( row1col2 )
		      vectorPtr.Byte( row1col2 ) = vectorPtr.Byte( row1col3 )
		      vectorPtr.Byte( row1col3 ) = temp
		      
		      //
		      // Rotate second row 2 columns to left  
		      //
		      temp = vectorPtr.Byte( row2col0 )
		      vectorPtr.Byte( row2col0 ) = vectorPtr.Byte( row2col2 )
		      vectorPtr.Byte( row2col2 ) = temp
		      
		      temp = vectorPtr.Byte( row2col1 )
		      vectorPtr.Byte( row2col1 ) = vectorPtr.Byte( row2col3 )
		      vectorPtr.Byte( row2col3 ) = temp
		      
		      //
		      // Rotate third row 3 columns to left
		      //
		      temp = vectorPtr.Byte( row3col0 )
		      vectorPtr.Byte( row3col0 ) = vectorPtr.Byte( row3col3 )
		      vectorPtr.Byte( row3col3 ) = vectorPtr.Byte( row3col2 )
		      vectorPtr.Byte( row3col2 ) = vectorPtr.Byte( row3col1 )
		      vectorPtr.Byte( row3col1 ) = temp
		      
		      if round <> NumberOfRounds then
		        //
		        // MixColumns (not for last round)
		        //
		        dataIndex = -4
		        for i as integer = 0 to 3
		          dataIndex = dataIndex + 4
		          
		          dim byte0 as byte = vectorPtr.Byte( dataIndex + 0 )
		          dim byte1 as byte = vectorPtr.Byte( dataIndex + 1 )
		          dim byte2 as byte = vectorPtr.Byte( dataIndex + 2 )
		          dim byte3 as byte = vectorPtr.Byte( dataIndex + 3 )
		          
		          temp = byte0 xor byte1 xor byte2 xor byte3
		          
		          temp2 = xtimePtr.Byte( byte0 xor byte1 )
		          vectorPtr.Byte( dataIndex + 0 ) = byte0 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte1 xor byte2 )
		          vectorPtr.Byte( dataIndex + 1 ) = byte1 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte2 xor byte3 )
		          vectorPtr.Byte( dataIndex + 2 ) = byte2 xor ( temp2 xor temp )
		          
		          temp2 = xtimePtr.Byte( byte3 xor byte0 )
		          vectorPtr.Byte( dataIndex + 3 ) = byte3 xor ( temp2 xor temp )
		        next
		      end if
		      
		      //
		      // AddRoundKey
		      //
		      roundKeyIndex = roundKeyIndex + 16
		      vectorPtr.UInt64( 0 ) = vectorPtr.UInt64( 0 ) xor roundKeyPtr.UInt64( roundKeyIndex )
		      vectorPtr.UInt64( 8 ) = vectorPtr.UInt64( 8 ) xor roundKeyPtr.UInt64( roundKeyIndex + 8 )
		    next
		    
		    'XorWithVector dataPtr, startAt, vectorPtr
		    dataIndex = startAt
		    vectorIndex = 0
		    diff = lastByte - dataIndex + 1
		    do
		      select case diff
		      case is >= kBlockLen
		        // Optimization to save a loop
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( 0 )
		        dataIndex = dataIndex + 8
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( 8 )
		        exit
		      case is >= 8
		        dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex )  xor vectorPtr.UInt64( vectorIndex )
		        dataIndex = dataIndex + 8
		        vectorIndex = vectorIndex + 8
		        diff = diff - 8
		      case is >= 4
		        dataPtr.UInt32( dataIndex ) = dataPtr.UInt32( dataIndex )  xor vectorPtr.UInt32( vectorIndex )
		        dataIndex = dataIndex + 4
		        vectorIndex = vectorIndex + 4
		        diff = diff - 4
		      case is >= 2
		        dataPtr.UInt16( dataIndex ) = dataPtr.UInt16( dataIndex )  xor vectorPtr.UInt16( vectorIndex )
		        dataIndex = dataIndex + 2
		        vectorIndex = vectorIndex + 2
		        diff = diff - 2
		      case else
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex )  xor vectorPtr.Byte( vectorIndex )
		        dataIndex = dataIndex + 1
		        vectorIndex = vectorIndex + 1
		        diff = diff - 1
		      end select
		    loop until vectorIndex = kBlockLen
		    
		    if type = Functions.CFB and diff >= kBlockLen then
		      vectorPtr.UInt64( 0 ) = dataPtr.UInt64( startAt )
		      vectorPtr.UInt64( 8 ) = dataPtr.UInt64( startAt + 8 )
		    end if
		    
		  next
		  
		  if not isFinalBlock then
		    zCurrentVector = vectorMB
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExpandKey(key As String)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Example values are given for 192-bit
		  //
		  
		  //
		  // The first round key is the key itself.
		  //
		  RoundKey = new MemoryBlock( KeyExpSize ) // e.g., KeyExpSize = 208
		  
		  #if DebugBuild
		    //
		    // For debugging
		    //
		    var roundKey as MemoryBlock = self.RoundKey
		  #endif
		  
		  if key.Bytes > KeyLen then // e.g., KeyLen = 24
		    RoundKey.StringValue( 0, KeyLen ) = key.LeftBytes( KeyLen )
		  else
		    RoundKey.StringValue( 0, key.Bytes ) = key
		  end if
		  
		  dim roundKeyPtr as Ptr = RoundKey
		  
		  //
		  // All other round keys are found from the previous round keys.
		  //
		  dim tempa as new MemoryBlock( 5 ) // Padding to make rotating easier
		  dim tempaPtr as ptr = tempa
		  dim sboxPtr as ptr = Sbox
		  dim rconPtr as ptr = Rcon
		  
		  var is256 as boolean = Bits = 256
		  
		  //
		  // Variables that would otherwise be incremented within
		  // the loop with costlier operations than simple addition;
		  // we start with lower values since they will be incremented
		  // at the top of the loop
		  //
		  var iTimes4 as integer = Nk * 4 - 4
		  var iMinusNk as integer = 0 - 4
		  var iMod as integer = 0 - 1
		  var roundKeyIndex as integer = ( Nk - 1 ) * 4 - 4
		  
		  var iLast as integer = kNb * ( NumberOfRounds + 1 ) - 1 // e.g., NumberOfRounds = 12, iLast = 51
		  
		  for i as integer = Nk to iLast // e.g., Nk = 6
		    //
		    // Increment the indexes
		    //
		    roundKeyIndex = roundKeyIndex + 4
		    iTimes4 = iTimes4 + 4
		    iMinusNk = iMinusNk + 4
		    
		    iMod = iMod + 1
		    if iMod = Nk then
		      iMod = 0
		    end if
		    
		    tempaPtr.UInt32( 0 ) = roundKeyPtr.UInt32( roundKeyIndex )
		    
		    if iMod = 0 then
		      // This function shifts the 4 bytes in a word to the left once.
		      // [a0,a1,a2,a3] becomes [a1,a2,a3,a0]
		      
		      // Function RotWord()
		      tempaPtr.Byte( 4 ) = tempaPtr.Byte( 0 )
		      tempaPtr.UInt32( 0 ) = tempaPtr.UInt32( 1 )
		      
		      // SubWord() is a function that takes a four-byte input word and 
		      // applies the S-box to each of the four bytes to produce an output word.
		      
		      // Function Subword()
		      tempaPtr.Byte( 0 ) = sboxPtr.Byte( tempaPtr.Byte( 0 ) )
		      tempaPtr.Byte( 1 ) = sboxPtr.Byte( tempaPtr.Byte( 1 ) )
		      tempaPtr.Byte( 2 ) = sboxPtr.Byte( tempaPtr.Byte( 2 ) )
		      tempaPtr.Byte( 3 ) = sboxPtr.Byte( tempaPtr.Byte( 3 ) )
		      
		      tempaPtr.Byte( 0 ) = tempaPtr.Byte( 0 ) xor rconPtr.Byte( i \ Nk )
		      
		    elseif is256 and iMod = 4 then
		      tempaPtr.Byte( 0 ) = sboxPtr.Byte( tempaPtr.Byte( 0 ) )
		      tempaPtr.Byte( 1 ) = sboxPtr.Byte( tempaPtr.Byte( 1 ) )
		      tempaPtr.Byte( 2 ) = sboxPtr.Byte( tempaPtr.Byte( 2 ) )
		      tempaPtr.Byte( 3 ) = sboxPtr.Byte( tempaPtr.Byte( 3 ) )
		      
		    end if
		    
		    roundKeyPtr.UInt32( iTimes4 ) = roundKeyPtr.UInt32( iMinusNk ) xor tempaPtr.UInt32( 0 )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitInvSbox()
		  if InvSbox is nil then
		    const kHex as string = _
		    "52096ad53036a538bf40a39e81f3d7fb7ce339829b2fff87348e4344c4de" + _
		    "e9cb547b9432a6c2233dee4c950b42fac34e082ea16628d924b2765ba249" + _
		    "6d8bd12572f8f66486689816d4a45ccc5d65b6926c704850fdedb9da5e15" + _
		    "4657a78d9d8490d8ab008cbcd30af7e45805b8b34506d02c1e8fca3f0f02" + _
		    "c1afbd0301138a6b3a9111414f67dcea97f2cfcef0b4e67396ac7422e7ad" + _
		    "3585e2f937e81c75df6e47f11a711d29c5896fb7620eaa18be1bfc563e4b" + _
		    "c6d279209adbc0fe78cd5af41fdda8338807c731b11210592780ec5f6051" + _
		    "7fa919b54a0d2de57a9f93c99cefa0e03b4dae2af5b0c8ebbb3c83539961" + _
		    "172b047eba77d626e169146355210c7d"
		    
		    InvSbox = DecodeHex( kHex )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitMultiplyTables()
		  if MultiplyH9MB is nil then
		    MultiplyH9MB = DecodeHex( kMultiplyH9Hex )
		    MultiplyHBMB = DecodeHex( kMultiplyHBHex )
		    MultiplyHDMB = DecodeHex( kMultiplyHDHex )
		    MultiplyHEMB = DecodeHex( kMultiplyHEHex )
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitRcon()
		  if Rcon is nil then
		    const kHex as string = "8d01020408102040801b36"
		    
		    Rcon = DecodeHex( kHex )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitSbox()
		  if Sbox is nil then
		    const kHex as string = _
		    "637c777bf26b6fc53001672bfed7ab76ca82c97dfa5947f0add4a2af9ca4" + _
		    "72c0b7fd9326363ff7cc34a5e5f171d8311504c723c31896059a071280e2" + _
		    "eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acb" + _
		    "be394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5" + _
		    "bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a" + _
		    "908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d" + _
		    "8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703e" + _
		    "b5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df" + _
		    "8ca1890dbfe6426841992d0fb054bb16"
		    
		    Sbox = DecodeHex( kHex )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitXtime()
		  if XtimeMB is nil then
		    const kHex as string = _
		    "00020406080a0c0e10121416181a1c1es20222426282a2c2e30323436383a3c3e" + _
		    "40424446484a4c4e50525456585a5c5es60626466686a6c6e70727476787a7c7e" + _
		    "80828486888a8c8e90929496989a9c9esa0a2a4a6a8aaacaeb0b2b4b6b8babcbe" + _
		    "c0c2c4c6c8caccced0d2d4d6d8dadcdese0e2e4e6e8eaeceef0f2f4f6f8fafcfe" + _
		    "1b191f1d131117150b090f0d03010705s3b393f3d333137352b292f2d23212725" + _
		    "5b595f5d535157554b494f4d43414745s7b797f7d737177756b696f6d63616765" + _
		    "9b999f9d939197958b898f8d83818785sbbb9bfbdb3b1b7b5aba9afada3a1a7a5" + _
		    "dbd9dfddd3d1d7d5cbc9cfcdc3c1c7c5sfbf9fffdf3f1f7f5ebe9efede3e1e7e5"
		    
		    XtimeMB = DecodeHex( kHex )
		    
		    //
		    // The data is a result of this calculation
		    //
		    'XtimeMB = new MemoryBlock( 256 )
		    'var xtimePtr as ptr = XtimeMB
		    '
		    'for x as integer = 0 to 255
		    '
		    'const kOne as integer = 1
		    'const kShift1 as integer = 2
		    'const kShift7 as integer = 128
		    'const kXtimeMult as integer = &h1B
		    '
		    'xtimePtr.Byte( x ) = ( x * kShift1 ) xor ( ( ( x \ kShift7 ) and kOne ) * kXtimeMult )
		    '
		    'next
		    
		  end if
		  
		  'return BitWise.ShiftLeft( x, 1, 8 ) xor ( ( Bitwise.ShiftRight( x, 7, 8 ) and 1 ) * &h1B )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = false
		Attributes( deprecated ) Private Sub InvCipher(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Decrypt
		  //
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for InvShiftRows
		  //
		  dim row0col0 as integer = startAt + 0
		  dim row0col1 as integer = startAt + 4
		  dim row0col2 as integer = startAt + 8
		  dim row0col3 as integer = startAt + 12
		  
		  dim row1col0 as integer = row0col0 + 1
		  dim row1col1 as integer = row0col1 + 1
		  dim row1col2 as integer = row0col2 + 1
		  dim row1col3 as integer = row0col3 + 1
		  
		  dim row2col0 as integer = row0col0 + 2
		  dim row2col1 as integer = row0col1 + 2
		  dim row2col2 as integer = row0col2 + 2
		  dim row2col3 as integer = row0col3 + 2
		  
		  dim row3col0 as integer = row0col0 + 3
		  dim row3col1 as integer = row0col1 + 3
		  dim row3col2 as integer = row0col2 + 3
		  dim row3col3 as integer = row0col3 + 3
		  
		  dim invSboxPtr as ptr = InvSbox
		  dim round as integer = NumberOfRounds
		  
		  //
		  // AddRoundKey
		  // Add the First round key to the state before starting the rounds.
		  //
		  dim roundKeyPtr as ptr = RoundKey
		  
		  for i as integer = 0 to 3
		    for j as integer = 0 to 3
		      dim dataIndex as integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor roundKeyPtr.Byte( round * kNb * 4 + i * kNb + j )
		    next
		  next
		  
		  //
		  // There will be NumberOfRounds rounds.
		  // The first NumberOfRounds-1 rounds are identical.
		  // These NumberOfRounds-1 rounds are executed in the loop below.
		  //
		  dim lastRound as integer = NumberOfRounds - 1
		  for round = lastRound to 0 step -1
		    //
		    // InvShiftRows
		    //
		    dim temp as byte 
		    
		    //
		    // Rotate first row 1 columns to right
		    //
		    temp = dataPtr.Byte( row1col3 )
		    dataPtr.Byte( row1col3 ) = dataPtr.Byte( row1col2 )
		    dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col1 )
		    dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col0 )
		    dataPtr.Byte( row1col0 ) = temp
		    
		    //
		    // Rotate second row 2 columns to right 
		    //
		    temp = dataPtr.Byte( row2col0 )
		    dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		    dataPtr.Byte( row2col2 ) = temp
		    
		    temp = dataPtr.Byte( row2col1 )
		    dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		    dataPtr.Byte( row2col3 ) = temp
		    
		    //
		    // Rotate third row 3 columns to right
		    //
		    temp = dataPtr.Byte( row3col0 )
		    dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col1 )
		    dataPtr.Byte( row3col1 ) = dataPtr.Byte( row3col2 )
		    dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col3 )
		    dataPtr.Byte( row3col3 ) = temp
		    
		    //
		    // InvSubBytes
		    //
		    for i as integer = 0 to 3
		      for j as integer = 0 to 3
		        dim dataIndex as integer = ( j * 4 + i ) + startAt
		        dataPtr.Byte( dataIndex ) = invSboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		      next
		    next
		    
		    //
		    // AddRoundKey
		    //
		    for i as integer = 0 to 3
		      for j as integer = 0 to 3
		        dim dataIndex as integer = ( i * 4 + j ) + startAt
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor roundKeyPtr.Byte( round * kNb * 4 + i * kNb + j )
		      next
		    next
		    
		    if round <> 0 then
		      //
		      // InvMixColumns (not for last round)
		      //
		      for i as integer = 0 to 3
		        dim dataIndex as integer = ( i * 4 ) + startAt
		        
		        dim byte0 as byte = dataPtr.Byte( dataIndex + 0 )
		        dim byte1 as byte = dataPtr.Byte( dataIndex + 1 )
		        dim byte2 as byte = dataPtr.Byte( dataIndex + 2 )
		        dim byte3 as byte = dataPtr.Byte( dataIndex + 3 )
		        
		        dataPtr.Byte( dataIndex + 0 ) = multiplyHEPtr.Byte( byte0 ) xor multiplyHBPtr.Byte( byte1 ) xor multiplyHDPtr.Byte( byte2 ) xor multiplyH9Ptr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 1 ) = multiplyH9Ptr.Byte( byte0 ) xor multiplyHEPtr.Byte( byte1 ) xor multiplyHBPtr.Byte( byte2 ) xor multiplyHDPtr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 2 ) = multiplyHDPtr.Byte( byte0 ) xor multiplyH9Ptr.Byte( byte1 ) xor multiplyHEPtr.Byte( byte2 ) xor multiplyHBPtr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 3 ) = multiplyHBPtr.Byte( byte0 ) xor multiplyHDPtr.Byte( byte1 ) xor multiplyH9Ptr.Byte( byte2 ) xor multiplyHEPtr.Byte( byte3 )
		      next
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub InvMixColumns(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into InvCipher
		  //
		  
		  for i as integer = 0 to 3
		    dim dataIndex as integer = ( i * 4 ) + startAt
		    
		    dim byte0 as integer = dataPtr.Byte( dataIndex + 0 )
		    dim byte1 as integer = dataPtr.Byte( dataIndex + 1 )
		    dim byte2 as integer = dataPtr.Byte( dataIndex + 2 )
		    dim byte3 as integer = dataPtr.Byte( dataIndex + 3 )
		    
		    'dataPtr.Byte( dataIndex + 0 ) = Multiply( byte0, kHE ) xor Multiply( byte1, kHB ) xor Multiply( byte2, kHD ) xor Multiply( byte3, kH9 )
		    'dataPtr.Byte( dataIndex + 1 ) = Multiply( byte0, kH9 ) xor Multiply( byte1, kHE ) xor Multiply( byte2, kHB ) xor Multiply( byte3, kHD )
		    'dataPtr.Byte( dataIndex + 2 ) = Multiply( byte0, kHD ) xor Multiply( byte1, kH9 ) xor Multiply( byte2, kHE ) xor Multiply( byte3, kHB )
		    'dataPtr.Byte( dataIndex + 3 ) = Multiply( byte0, kHB ) xor Multiply( byte1, kHD ) xor Multiply( byte2, kH9 ) xor Multiply( byte3, kHE )
		    
		    dataPtr.Byte( dataIndex + 0 ) = multiplyHEPtr.Byte( byte0 ) xor multiplyHBPtr.Byte( byte1 ) xor multiplyHDPtr.Byte( byte2 ) xor multiplyH9Ptr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 1 ) = multiplyH9Ptr.Byte( byte0 ) xor multiplyHEPtr.Byte( byte1 ) xor multiplyHBPtr.Byte( byte2 ) xor multiplyHDPtr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 2 ) = multiplyHDPtr.Byte( byte0 ) xor multiplyH9Ptr.Byte( byte1 ) xor multiplyHEPtr.Byte( byte2 ) xor multiplyHBPtr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 3 ) = multiplyHBPtr.Byte( byte0 ) xor multiplyHDPtr.Byte( byte1 ) xor multiplyH9Ptr.Byte( byte2 ) xor multiplyHEPtr.Byte( byte3 )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub InvShiftRows(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into InvCipher
		  //
		  
		  dim row0col0 as integer = startAt + 0
		  dim row0col1 as integer = startAt + 4
		  dim row0col2 as integer = startAt + 8
		  dim row0col3 as integer = startAt + 12
		  
		  dim row1col0 as integer = row0col0 + 1
		  dim row1col1 as integer = row0col1 + 1
		  dim row1col2 as integer = row0col2 + 1
		  dim row1col3 as integer = row0col3 + 1
		  
		  dim row2col0 as integer = row0col0 + 2
		  dim row2col1 as integer = row0col1 + 2
		  dim row2col2 as integer = row0col2 + 2
		  dim row2col3 as integer = row0col3 + 2
		  
		  dim row3col0 as integer = row0col0 + 3
		  dim row3col1 as integer = row0col1 + 3
		  dim row3col2 as integer = row0col2 + 3
		  dim row3col3 as integer = row0col3 + 3
		  
		  dim temp as integer 
		  
		  //
		  // Rotate first row 1 columns to right
		  //
		  temp = dataPtr.Byte( row1col3 )
		  dataPtr.Byte( row1col3 ) = dataPtr.Byte( row1col2 )
		  dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col1 )
		  dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col0 )
		  dataPtr.Byte( row1col0 ) = temp
		  
		  //
		  // Rotate second row 2 columns to right 
		  //
		  temp = dataPtr.Byte( row2col0 )
		  dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		  dataPtr.Byte( row2col2 ) = temp
		  
		  temp = dataPtr.Byte( row2col1 )
		  dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		  dataPtr.Byte( row2col3 ) = temp
		  
		  //
		  // Rotate third row 3 columns to right
		  //
		  temp = dataPtr.Byte( row3col0 )
		  dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col1 )
		  dataPtr.Byte( row3col1 ) = dataPtr.Byte( row3col2 )
		  dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col3 )
		  dataPtr.Byte( row3col3 ) = temp
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub InvSubBytes(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into InvCipher
		  //
		  
		  dim invSboxPtr as ptr = InvSbox
		  for i as integer = 0 to 3
		    for j as integer = 0 to 3
		      dim dataIndex as integer = ( j * 4 + i ) + startAt
		      dataPtr.Byte( dataIndex ) = invSboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub MixColumns(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Cipher
		  //
		  
		  const kOne as integer = 1
		  const kShift1 as integer = 2
		  const kShift7 as integer = 128
		  const kXtimeMult as integer = &h1B
		  
		  var xtimePtr as ptr = XtimeMB
		  
		  for i as integer = 0 to 3
		    dim dataIndex as integer = ( i * 4 ) + startAt
		    
		    dim byte0 as integer = dataPtr.Byte( dataIndex + 0 )
		    dim byte1 as integer = dataPtr.Byte( dataIndex + 1 )
		    dim byte2 as integer = dataPtr.Byte( dataIndex + 2 )
		    dim byte3 as integer = dataPtr.Byte( dataIndex + 3 )
		    
		    dim tmp as integer = byte0 xor byte1 xor byte2 xor byte3
		    
		    dim tm as integer
		    
		    tm = byte0 xor byte1
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = xtimePtr.Byte( tm )
		    
		    dataPtr.Byte( dataIndex + 0 ) = byte0 xor ( tm xor tmp )
		    
		    tm = byte1 xor byte2
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = xtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 1 ) = byte1 xor ( tm xor tmp )
		    
		    tm = byte2 xor byte3
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = xtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 2 ) = byte2 xor ( tm xor tmp )
		    
		    tm = byte3 xor byte0
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = xtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 3 ) = byte3 xor ( tm xor tmp )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Shared Function Multiply(x As Integer, y As Integer) As integer
		  //
		  // For reference only
		  // The results were precomputed and used in InitMultiplyTables
		  //
		  const kOne as integer = 1
		  const kShift1 as integer = 2
		  const kShift2 as integer = 4
		  const kShift3 as integer = 8
		  const kShift4 as integer = 16
		  const kShift7 as integer = 128
		  const kXtimeMult as integer = &h1B
		  
		  dim xtimex1 as integer = xtimePtr.Byte( x )
		  dim xtimex2 as integer = xtimePtr.Byte( xtimex1 )
		  dim xtimex3 as integer = xtimePtr.Byte( xtimex2 )
		  dim xtimex4 as integer = xtimePtr.Byte( xtimex3 )
		  
		  return ( ( y and kOne ) * x ) xor _
		  ( ( ( y \ kShift1 ) and kOne ) * xtimex1 ) xor _
		  ( ( ( y \ kShift2 ) and kOne ) * xtimex2 ) xor _
		  ( ( ( y \ kShift3 ) and kOne ) * xtimex3 ) xor _
		  ( ( ( y \ kShift4 ) and kOne ) * xtimex4 )
		  
		  'dim xtimex as integer = Xtime( x )
		  'dim xtimex2 as integer = Xtime( xtimex )
		  'dim xtimex3 as integer = Xtime( xtimex2 )
		  'dim xtimex4 as integer = Xtime( xtimex3 )
		  '
		  'return ( ( ( y and kOne ) * x ) xor _
		  '( ( Bitwise.ShiftRight( y, 1, 8 ) and kOne ) * Xtime( x ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 2, 8 ) and kOne ) * Xtime( Xtime( x ) ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 3, 8 ) and kOne ) * Xtime( Xtime( Xtime( x ) ) ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 4, 8 ) and kOne ) * Xtime( Xtime( Xtime( Xtime( x ) ) ) ) ) )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub ShiftRows(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Cipher
		  //
		  
		  dim row0col0 as integer = startAt + 0
		  dim row0col1 as integer = startAt + 4
		  dim row0col2 as integer = startAt + 8
		  dim row0col3 as integer = startAt + 12
		  
		  dim row1col0 as integer = row0col0 + 1
		  dim row1col1 as integer = row0col1 + 1
		  dim row1col2 as integer = row0col2 + 1
		  dim row1col3 as integer = row0col3 + 1
		  
		  dim row2col0 as integer = row0col0 + 2
		  dim row2col1 as integer = row0col1 + 2
		  dim row2col2 as integer = row0col2 + 2
		  dim row2col3 as integer = row0col3 + 2
		  
		  dim row3col0 as integer = row0col0 + 3
		  dim row3col1 as integer = row0col1 + 3
		  dim row3col2 as integer = row0col2 + 3
		  dim row3col3 as integer = row0col3 + 3
		  
		  dim temp as integer 
		  
		  //
		  // Rotate first row 1 columns to left  
		  //
		  temp = dataPtr.Byte( row1col0 )
		  dataPtr.Byte( row1col0 ) = dataPtr.Byte( row1col1 )
		  dataPtr.Byte( row1col1 ) = dataPtr.Byte( row1col2 )
		  dataPtr.Byte( row1col2 ) = dataPtr.Byte( row1col3 )
		  dataPtr.Byte( row1col3 ) = temp
		  
		  //
		  // Rotate second row 2 columns to left  
		  //
		  temp = dataPtr.Byte( row2col0 )
		  dataPtr.Byte( row2col0 ) = dataPtr.Byte( row2col2 )
		  dataPtr.Byte( row2col2 ) = temp
		  
		  temp = dataPtr.Byte( row2col1 )
		  dataPtr.Byte( row2col1 ) = dataPtr.Byte( row2col3 )
		  dataPtr.Byte( row2col3 ) = temp
		  
		  //
		  // Rotate third row 3 columns to left
		  //
		  temp = dataPtr.Byte( row3col0 )
		  dataPtr.Byte( row3col0 ) = dataPtr.Byte( row3col3 )
		  dataPtr.Byte( row3col3 ) = dataPtr.Byte( row3col2 )
		  dataPtr.Byte( row3col2 ) = dataPtr.Byte( row3col1 )
		  dataPtr.Byte( row3col1 ) = temp
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit))
		Attributes( deprecated ) Private Sub SubBytes(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually inlined into Cipher
		  //
		  
		  dim sboxPtr as ptr = Sbox
		  
		  for i as integer = 0 to 3
		    for j as integer = 0 to 3
		      dim dataIndex as integer = ( j * 4 + i ) + startAt
		      dataPtr.Byte( dataIndex ) = sboxPtr.Byte( dataPtr.Byte( dataIndex ) )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = false
		Attributes( deprecated ) Private Sub XorWithVector(dataPtr As Ptr, startAt As Integer, vectorPtr As Ptr)
		  //
		  // For reference only
		  // This was manually inlined into Encrypt/Decrypt
		  //
		  dataPtr.UInt64( startAt ) = dataPtr.UInt64( startAt ) xor vectorPtr.UInt64( 0 )
		  dim dataIndex as integer = startAt + 8
		  dataPtr.UInt64( dataIndex ) = dataPtr.UInt64( dataIndex ) xor vectorPtr.UInt64( 8 )
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return zBits
			End Get
		#tag EndGetter
		Bits As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared InvSbox As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyExpSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyLen As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyH9MB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHBMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHDMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHEMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Nk As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private NumberOfRounds As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Rcon As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RoundKey As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Sbox As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared XtimeMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private zBits As Integer
	#tag EndProperty


	#tag Constant, Name = kBlockLen, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMultiplyH9Hex, Type = String, Dynamic = False, Default = \"0009121B242D363F48415A536C657E779099828BB4BDA6AFD8D1CAC3FCF5EEE73B3229201F160D04737A6168575E454CABA2B9B08F869D94E3EAF1F8C7CED5DC767F646D525B40493E372C251A130801E6EFF4FDC2CBD0D9AEA7BCB58A8398914D445F5669607B72050C171E2128333ADDD4CFC6F9F0EBE2959C878EB1B8A3AAECE5FEF7C8C1DAD3A4ADB6BF8089929B7C756E6758514A43343D262F1019020BD7DEC5CCF3FAE1E89F968D84BBB2A9A0474E555C636A71780F061D142B2239309A938881BEB7ACA5D2DBC0C9F6FFE4ED0A0318112E273C35424B5059666F747DA1A8B3BA858C979EE9E0FBF2CDC4DFD63138232A151C070E79706B625D544F46", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMultiplyHBHex, Type = String, Dynamic = False, Default = \"000B161D2C273A3158534E45747F6269B0BBA6AD9C978A81E8E3FEF5C4CFD2D97B706D66575C414A2328353E0F041912CBC0DDD6E7ECF1FA9398858EBFB4A9A2F6FDE0EBDAD1CCC7AEA5B8B38289949F464D505B6A617C771E1508033239242F8D869B90A1AAB7BCD5DEC3C8F9F2EFE43D362B20111A070C656E737849425F54F7FCE1EADBD0CDC6AFA4B9B28388959E474C515A6B607D761F1409023338252E8C879A91A0ABB6BDD4DFC2C9F8F3EEE53C372A21101B060D646F727948435E55010A171C2D263B3059524F44757E6368B1BAA7AC9D968B80E9E2FFF4C5CED3D87A716C67565D404B2229343F0E051813CAC1DCD7E6EDF0FB9299848FBEB5A8A3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMultiplyHDHex, Type = String, Dynamic = False, Default = \"000D1A1734392E236865727F5C51464BD0DDCAC7E4E9FEF3B8B5A2AF8C81969BBBB6A1AC8F829598D3DEC9C4E7EAFDF06B66717C5F524548030E1914373A2D206D60777A5954434E05081F12313C2B26BDB0A7AA8984939ED5D8CFC2E1ECFBF6D6DBCCC1E2EFF8F5BEB3A4A98A87909D060B1C11323F28256E6374795A57404DDAD7C0CDEEE3F4F9B2BFA8A5868B9C910A07101D3E332429626F7875565B4C41616C7B7655584F420904131E3D30272AB1BCABA685889F92D9D4C3CEEDE0F7FAB7BAADA0838E9994DFD2C5C8EBE6F1FC676A7D70535E49440F0215183B36212C0C01161B3835222F64697E73505D4A47DCD1C6CBE8E5F2FFB4B9AEA3808D9A97", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMultiplyHEHex, Type = String, Dynamic = False, Default = \"000E1C123836242A707E6C624846545AE0EEFCF2D8D6C4CA909E8C82A8A6B4BADBD5C7C9E3EDFFF1ABA5B7B9939D8F813B352729030D1F114B455759737D6F61ADA3B1BF959B8987DDD3C1CFE5EBF9F74D43515F757B69673D33212F050B191776786A644E40525C06081A143E30222C96988A84AEA0B2BCE6E8FAF4DED0C2CC414F5D537977656B313F2D230907151BA1AFBDB39997858BD1DFCDC3E9E7F5FB9A948688A2ACBEB0EAE4F6F8D2DCCEC07A746668424C5E500A041618323C2E20ECE2F0FED4DAC8C69C92808EA4AAB8B60C02101E343A28267C72606E444A585637392B250F01131D47495B557F71636DD7D9CBC5EFE1F3FDA7A9BBB59F91838D", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kNb, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.7", Scope = Public
	#tag EndConstant


	#tag Enum, Name = EncryptionBits, Type = Integer, Flags = &h0
		Bits128 = 128
		  Bits192 = 192
		Bits256 = 256
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Code"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PaddingString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Bits"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BlockSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentVector"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PaddingMethod"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Padding"
			EditorType="Enum"
			#tag EnumValues
				"0 - NullsOnly"
				"1 - NullsWithCount"
				"2 - PKCS"
				"3 - None"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFunction"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Functions"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - ECB"
				"2 - CBC"
				"3 - CFB"
				"4 - OFB"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
