#tag Class
Class AES_MTC
Inherits M_Crypto.Encrypter
	#tag Event
		Sub Decrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case Functions.Default, Functions.ECB
		    DecryptECB data
		    
		  case Functions.CBC
		    DecryptCBC data, isFinalBlock
		    
		  case else
		    raise new M_Crypto.UnsupportedFunctionException
		    
		  end select
		End Sub
	#tag EndEvent

	#tag Event
		Sub Encrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case Functions.Default, Functions.ECB
		    EncryptECB data
		    
		  case Functions.CBC
		    EncryptCBC( data, isFinalBlock )
		    
		  case else
		    raise new M_Crypto.UnsupportedFunctionException
		    
		  end select
		End Sub
	#tag EndEvent

	#tag Event
		Sub KeyChanged(key As String)
		  ExpandKey key, Nk
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub AddRoundKey(round As Integer, dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into Cipher and InvCipher
		  //
		  
		  dim ptrRoundKey as ptr = RoundKey
		  
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex As integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor ptrRoundKey.Byte( round * kNb * 4 + i * kNb + j )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Cipher(dataPtr As Ptr, startAt As Integer)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // Used for ShiftRows
		  //
		  dim index0 As integer = startAt
		  dim index1 As integer = index0 + 4
		  dim index2 As integer = index0 + 8
		  dim index3 As integer = index0 + 12
		  
		  dim ptrSbox as ptr = Sbox
		  dim round As integer = 0
		  
		  //
		  // AddRoundKey
		  // Add the First round key to the dataPtr, startAt before starting the rounds.
		  //
		  dim ptrRoundKey as ptr = RoundKey
		  
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex As integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor ptrRoundKey.Byte( round * kNb * 4 + i * kNb + j )
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
		    for i As integer = 0 to 3
		      for j As integer = 0 to 3
		        dim dataIndex As integer = ( j * 4 + i ) + startAt
		        dataPtr.Byte( dataIndex ) = ptrSbox.Byte( dataPtr.Byte( dataIndex ) )
		      next
		    next
		    
		    //
		    // ShiftRows
		    //
		    dim temp As integer 
		    
		    //
		    // Rotate first row 1 columns to left  
		    //
		    temp = dataPtr.Byte( index0 + 1 )
		    dataPtr.Byte( index0 + 1 ) = dataPtr.Byte( index1 + 1 )
		    dataPtr.Byte( index1 + 1 ) = dataPtr.Byte( index2 + 1 )
		    dataPtr.Byte( index2 + 1 ) = dataPtr.Byte( index3 + 1 )
		    dataPtr.Byte( index3 + 1 ) = temp
		    
		    //
		    // Rotate second row 2 columns to left  
		    //
		    temp = dataPtr.Byte( index0 + 2 )
		    dataPtr.Byte( index0 + 2 ) = dataPtr.Byte( index2 + 2 )
		    dataPtr.Byte( index2 + 2 ) = temp
		    
		    temp = dataPtr.Byte( index1 + 2 )
		    dataPtr.Byte( index1 + 2 ) = dataPtr.Byte( index3 + 2 )
		    dataPtr.Byte( index3 + 2 ) = temp
		    
		    //
		    // Rotate third row 3 columns to left
		    //
		    temp = dataPtr.Byte( index0 + 3 )
		    dataPtr.Byte( index0 + 3 ) = dataPtr.Byte( index3 + 3 )
		    dataPtr.Byte( index3 + 3 ) = dataPtr.Byte( index2 + 3 )
		    dataPtr.Byte( index2 + 3 ) = dataPtr.Byte( index1 + 3 )
		    dataPtr.Byte( index1 + 3 ) = temp
		    
		    if round <> NumberOfRounds then
		      //
		      // MixColumns (not for last round)
		      //
		      const kOne As integer = 1
		      const kShift1 As integer = 2
		      const kShift7 As integer = 128
		      const kXtimeMult As integer = &h1B
		      
		      for i As integer = 0 to 3
		        dim dataIndex As integer = ( i * 4 ) + startAt
		        
		        dim byte0 As integer = dataPtr.Byte( dataIndex + 0 )
		        dim byte1 As integer = dataPtr.Byte( dataIndex + 1 )
		        dim byte2 As integer = dataPtr.Byte( dataIndex + 2 )
		        dim byte3 As integer = dataPtr.Byte( dataIndex + 3 )
		        
		        dim tmp As integer = byte0 xor byte1 xor byte2 xor byte3
		        
		        dim tm As integer
		        
		        tm = byte0 xor byte1
		        tm = XtimePtr.Byte( tm )
		        
		        dataPtr.Byte( dataIndex + 0 ) = byte0 xor ( tm xor tmp )
		        
		        tm = byte1 xor byte2
		        tm = XtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 1 ) = byte1 xor ( tm xor tmp )
		        
		        tm = byte2 xor byte3
		        tm = XtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 2 ) = byte2 xor ( tm xor tmp )
		        
		        tm = byte3 xor byte0
		        tm = XtimePtr.Byte( tm )
		        dataPtr.Byte( dataIndex + 3 ) = byte3 xor ( tm xor tmp )
		      next
		    end if
		    
		    //
		    // AddRoundKey
		    //
		    for i As integer = 0 to 3
		      for j As integer = 0 to 3
		        dim dataIndex As integer = ( i * 4 + j ) + startAt
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor ptrRoundKey.Byte( round * kNb * 4 + i * kNb + j )
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
		Sub Constructor(bits As Integer, paddingMethod As Padding=Padding.PKCS)
		  Constructor "", EncryptionBits( bits ), paddingMethod
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(key As String, bits As EncryptionBits=EncryptionBits.Bits128, paddingMethod As Padding=Padding.PKCS)
		  if XtimeMB is nil then
		    //
		    // Needs to be initialed
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
		Private Sub DecryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  dim dataPtr as ptr = data
		  
		  //
		  // Copy the original data so we have source
		  // for the vector
		  //
		  dim originalData as MemoryBlock = data.StringValue( 0, data.Size )
		  dim originalDataPtr as ptr = originalData
		  
		  dim vectorMB as new Xojo.Core.MutableMemoryBlock( kBlockLen )
		  if zCurrentVector isa object then
		    vectorMB.Left( vectorMB.Size ) = zCurrentVector
		  elseif InitialVector isa object then
		    vectorMB.Left( kBlockLen ) = InitialVector
		  end if
		  
		  dim vectorPtr as ptr = vectorMB.Data
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    InvCipher dataPtr, startAt
		    XorWithVector dataPtr, startAt, vectorPtr
		    vectorPtr = ptr( integer( originalDataPtr ) + startAt )
		  next
		  
		  if not isFinalBlock then
		    dim temp as new Xojo.Core.MutableMemoryBlock( vectorPtr, kBlockLen )
		    if zCurrentVector is nil then
		      zCurrentVector = new Xojo.Core.MutableMemoryBlock( kBlockLen )
		    end if
		    zCurrentVector.Left( kBlockLen ) = temp
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptECB(data As MemoryBlock)
		  dim dataPtr as ptr = data
		  
		  dim lastIndex As integer = data.Size - 1
		  for startAt As integer = 0 to lastIndex step kBlockLen
		    InvCipher( dataPtr, startAt )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  dim dataPtr as ptr = data 
		  
		  dim vectorMB as Xojo.Core.MutableMemoryBlock
		  if zCurrentVector isa object then
		    vectorMB = zCurrentVector
		  elseif InitialVector isa object then
		    vectorMB = new Xojo.Core.MutableMemoryBlock( InitialVector.Size )
		    vectorMB.Left( vectorMB.Size ) = InitialVector
		  else
		    vectorMB = new Xojo.Core.MutableMemoryBlock( kBlockLen )
		  end if
		  
		  dim vectorPtr as ptr = vectorMB.Data
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    XorWithVector dataPtr, startAt, vectorPtr
		    Cipher dataPtr, startAt
		    vectorPtr = Ptr( integer( dataPtr ) + startAt )
		  next
		  
		  if not isFinalBlock then
		    if zCurrentVector is nil then
		      zCurrentVector = new Xojo.Core.MutableMemoryBlock( kBlockLen )
		    end if
		    dim temp as new Xojo.Core.MutableMemoryBlock( vectorPtr, kBlockLen )
		    zCurrentVector.Left( kBlockLen ) = temp
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptECB(data As MemoryBlock)
		  dim dataPtr as ptr = data
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    Cipher( dataPtr, startAt )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ExpandKey(key As String, nk As Integer)
		  RoundKey = new MemoryBlock( KeyExpSize )
		  dim ptrRoundKey as Ptr = RoundKey
		  
		  //
		  // The first round key is the key itself.
		  //
		  RoundKey.StringValue( 0, KeyLen ) = key.LeftB( KeyLen )
		  
		  //
		  // All other round keys are found from the previous round keys.
		  //
		  dim tempa as new MemoryBlock( 4 )
		  dim ptrTempa as ptr = tempa
		  dim ptrSbox as ptr = Sbox
		  dim ptrRcon as ptr = Rcon
		  
		  dim iLast As integer = kNb * ( NumberOfRounds + 1 ) - 1
		  for i As integer = nk to iLast
		    tempa.StringValue( 0, 4 ) = RoundKey.StringValue( ( i - 1 ) * 4, 4 )
		    
		    if ( i mod nk ) = 0 then
		      // This function shifts the 4 bytes in a word to the left once.
		      // [a0,a1,a2,a3] becomes [a1,a2,a3,a0]
		      
		      // Function RotWord()
		      dim firstByte As integer = ptrTempa.Byte( 0 )
		      tempa.StringValue( 0, 3 ) = tempa.StringValue( 1, 3 )
		      ptrTempa.Byte( 3 ) = firstByte
		      
		      // SubWord() is a function that takes a four-byte input word and 
		      // applies the S-box to each of the four bytes to produce an output word.
		      
		      // Function Subword()
		      ptrTempa.Byte( 0 ) = ptrSbox.Byte( ptrTempa.Byte( 0 ) )
		      ptrTempa.Byte( 1 ) = ptrSbox.Byte( ptrTempa.Byte( 1 ) )
		      ptrTempa.Byte( 2 ) = ptrSbox.Byte( ptrTempa.Byte( 2 ) )
		      ptrTempa.Byte( 3 ) = ptrSbox.Byte( ptrTempa.Byte( 3 ) )
		      
		      ptrTempa.Byte( 0 ) = ptrTempa.Byte( 0 ) xor ptrRcon.Byte( i / nk )
		      
		    end if
		    
		    if Bits = 256 then
		      if ( i mod nk ) = 4 then
		        ptrTempa.Byte( 0 ) = ptrSbox.Byte( ptrTempa.Byte( 0 ) )
		        ptrTempa.Byte( 1 ) = ptrSbox.Byte( ptrTempa.Byte( 1 ) )
		        ptrTempa.Byte( 2 ) = ptrSbox.Byte( ptrTempa.Byte( 2 ) )
		        ptrTempa.Byte( 3 ) = ptrSbox.Byte( ptrTempa.Byte( 3 ) )
		      end if
		    end if
		    
		    dim iTimes4 As integer = i * 4
		    dim iMinusNk As integer = ( i - nk ) * 4
		    ptrRoundKey.Byte( iTimes4 + 0 ) = ptrRoundKey.Byte( iMinusNk + 0 ) xor ptrTempa.Byte( 0 )
		    ptrRoundKey.Byte( iTimes4 + 1 ) = ptrRoundKey.Byte( iMinusNk + 1 ) xor ptrTempa.Byte( 1 )
		    ptrRoundKey.Byte( iTimes4 + 2 ) = ptrRoundKey.Byte( iMinusNk + 2 ) xor ptrTempa.Byte( 2 )
		    ptrRoundKey.Byte( iTimes4 + 3 ) = ptrRoundKey.Byte( iMinusNk + 3 ) xor ptrTempa.Byte( 3 )
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
		    const kH9 As integer = &h09
		    const kHB As integer = &h0B
		    const kHD As integer = &h0D
		    const kHE As integer = &h0E
		    
		    MultiplyH9MB = new MemoryBlock( 256 )
		    MultiplyH9Ptr = MultiplyH9MB
		    
		    MultiplyHBMB = new MemoryBlock( 256 )
		    MultiplyHBPtr = MultiplyHBMB
		    
		    MultiplyHDMB = new MemoryBlock( 256 )
		    MultiplyHDPtr = MultiplyHDMB
		    
		    MultiplyHEMB = new MemoryBlock( 256 )
		    MultiplyHEPtr = MultiplyHEMB
		    
		    dim ptrs() as ptr = array( MultiplyH9Ptr, MultiplyHBPtr, MultiplyHDPtr, MultiplyHEPtr )
		    dim values() as integer = array( kH9, kHB, kHD, kHE )
		    
		    for i as integer = 0 to ptrs.Ubound
		      dim p as ptr = ptrs( i )
		      dim v as integer = values( i )
		      
		      for x as integer = 0 to 256
		        p.Byte( x ) = Multiply( x, v )
		      next
		    next
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
		    
		    XtimeMB = new MemoryBlock( 256 )
		    XtimePtr = XtimeMB
		    
		    for x as integer = 0 to 255
		      
		      const kOne As integer = 1
		      const kShift1 As integer = 2
		      const kShift7 As integer = 128
		      const kXtimeMult As integer = &h1B
		      
		      XtimePtr.Byte( x ) = ( x * kShift1 )  xor ( ( ( x \ kShift7 ) and kOne ) * kXtimeMult )
		      
		    next
		    
		  end if
		  
		  'return BitWise.ShiftLeft( x, 1, 8 ) xor ( ( Bitwise.ShiftRight( x, 7, 8 ) and 1 ) * &h1B )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvCipher(dataPtr As Ptr, startAt As Integer)
		  //
		  // Used for InvShiftRows
		  //
		  dim index0 As integer = startAt
		  dim index1 As integer = index0 + 4
		  dim index2 As integer = index0 + 8
		  dim index3 As integer = index0 + 12
		  
		  dim ptrInvSbox as ptr = InvSbox
		  dim round As integer = NumberOfRounds
		  
		  //
		  // AddRoundKey
		  // Add the First round key to the state before starting the rounds.
		  //
		  dim ptrRoundKey as ptr = RoundKey
		  
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex as integer = ( i * 4 + j ) + startAt
		      dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor ptrRoundKey.Byte( round * kNb * 4 + i * kNb + j )
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
		    dim temp As integer 
		    
		    //
		    // Rotate first row 1 columns to right
		    //
		    temp = dataPtr.Byte( index3 + 1 )
		    dataPtr.Byte( index3 + 1 ) = dataPtr.Byte( index2 + 1 )
		    dataPtr.Byte( index2 + 1 ) = dataPtr.Byte( index1 + 1 )
		    dataPtr.Byte( index1 + 1 ) = dataPtr.Byte( index0 + 1 )
		    dataPtr.Byte( index0 + 1 ) = temp
		    
		    //
		    // Rotate second row 2 columns to right 
		    //
		    temp = dataPtr.Byte( index0 + 2 )
		    dataPtr.Byte( index0 + 2 ) = dataPtr.Byte( index2 + 2 )
		    dataPtr.Byte( index2 + 2 ) = temp
		    
		    temp = dataPtr.Byte( index1 + 2 )
		    dataPtr.Byte( index1 + 2 ) = dataPtr.Byte( index3 + 2 )
		    dataPtr.Byte( index3 + 2 ) = temp
		    
		    //
		    // Rotate third row 3 columns to right
		    //
		    temp = dataPtr.Byte( index0 + 3 )
		    dataPtr.Byte( index0 + 3 ) = dataPtr.Byte( index1 + 3 )
		    dataPtr.Byte( index1 + 3 ) = dataPtr.Byte( index2 + 3 )
		    dataPtr.Byte( index2 + 3 ) = dataPtr.Byte( index3 + 3 )
		    dataPtr.Byte( index3 + 3 ) = temp
		    
		    //
		    // InvSubBytes
		    //
		    for i As integer = 0 to 3
		      for j As integer = 0 to 3
		        dim dataIndex As integer = ( j * 4 + i ) + startAt
		        dataPtr.Byte( dataIndex ) = ptrInvSbox.Byte( dataPtr.Byte( dataIndex ) )
		      next
		    next
		    
		    //
		    // AddRoundKey
		    //
		    for i As integer = 0 to 3
		      for j As integer = 0 to 3
		        dim dataIndex As integer = ( i * 4 + j ) + startAt
		        dataPtr.Byte( dataIndex ) = dataPtr.Byte( dataIndex ) xor ptrRoundKey.Byte( round * kNb * 4 + i * kNb + j )
		      next
		    next
		    
		    if round <> 0 then
		      //
		      // InvMixColumns (not for last round)
		      //
		      for i As integer = 0 to 3
		        dim dataIndex As integer = ( i * 4 ) + startAt
		        
		        dim byte0 As integer = dataPtr.Byte( dataIndex + 0 )
		        dim byte1 As integer = dataPtr.Byte( dataIndex + 1 )
		        dim byte2 As integer = dataPtr.Byte( dataIndex + 2 )
		        dim byte3 As integer = dataPtr.Byte( dataIndex + 3 )
		        
		        dataPtr.Byte( dataIndex + 0 ) = MultiplyHEPtr.Byte( byte0 ) xor MultiplyHBPtr.Byte( byte1 ) xor MultiplyHDPtr.Byte( byte2 ) xor MultiplyH9Ptr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 1 ) = MultiplyH9Ptr.Byte( byte0 ) xor MultiplyHEPtr.Byte( byte1 ) xor MultiplyHBPtr.Byte( byte2 ) xor MultiplyHDPtr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 2 ) = MultiplyHDPtr.Byte( byte0 ) xor MultiplyH9Ptr.Byte( byte1 ) xor MultiplyHEPtr.Byte( byte2 ) xor MultiplyHBPtr.Byte( byte3 )
		        dataPtr.Byte( dataIndex + 3 ) = MultiplyHBPtr.Byte( byte0 ) xor MultiplyHDPtr.Byte( byte1 ) xor MultiplyH9Ptr.Byte( byte2 ) xor MultiplyHEPtr.Byte( byte3 )
		      next
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub InvMixColumns(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into InvCipher
		  //
		  
		  for i As integer = 0 to 3
		    dim dataIndex As integer = ( i * 4 ) + startAt
		    
		    dim byte0 As integer = dataPtr.Byte( dataIndex + 0 )
		    dim byte1 As integer = dataPtr.Byte( dataIndex + 1 )
		    dim byte2 As integer = dataPtr.Byte( dataIndex + 2 )
		    dim byte3 As integer = dataPtr.Byte( dataIndex + 3 )
		    
		    'dataPtr.Byte( dataIndex + 0 ) = Multiply( byte0, kHE ) xor Multiply( byte1, kHB ) xor Multiply( byte2, kHD ) xor Multiply( byte3, kH9 )
		    'dataPtr.Byte( dataIndex + 1 ) = Multiply( byte0, kH9 ) xor Multiply( byte1, kHE ) xor Multiply( byte2, kHB ) xor Multiply( byte3, kHD )
		    'dataPtr.Byte( dataIndex + 2 ) = Multiply( byte0, kHD ) xor Multiply( byte1, kH9 ) xor Multiply( byte2, kHE ) xor Multiply( byte3, kHB )
		    'dataPtr.Byte( dataIndex + 3 ) = Multiply( byte0, kHB ) xor Multiply( byte1, kHD ) xor Multiply( byte2, kH9 ) xor Multiply( byte3, kHE )
		    
		    dataPtr.Byte( dataIndex + 0 ) = MultiplyHEPtr.Byte( byte0 ) xor MultiplyHBPtr.Byte( byte1 ) xor MultiplyHDPtr.Byte( byte2 ) xor MultiplyH9Ptr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 1 ) = MultiplyH9Ptr.Byte( byte0 ) xor MultiplyHEPtr.Byte( byte1 ) xor MultiplyHBPtr.Byte( byte2 ) xor MultiplyHDPtr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 2 ) = MultiplyHDPtr.Byte( byte0 ) xor MultiplyH9Ptr.Byte( byte1 ) xor MultiplyHEPtr.Byte( byte2 ) xor MultiplyHBPtr.Byte( byte3 )
		    dataPtr.Byte( dataIndex + 3 ) = MultiplyHBPtr.Byte( byte0 ) xor MultiplyHDPtr.Byte( byte1 ) xor MultiplyH9Ptr.Byte( byte2 ) xor MultiplyHEPtr.Byte( byte3 )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub InvShiftRows(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into InvCipher
		  //
		  
		  dim index0 As integer = startAt
		  dim index1 As integer = index0 + 4
		  dim index2 As integer = index0 + 8
		  dim index3 As integer = index0 + 12
		  
		  dim temp As integer 
		  
		  //
		  // Rotate first row 1 columns to right
		  //
		  temp = dataPtr.Byte( index3 + 1 )
		  dataPtr.Byte( index3 + 1 ) = dataPtr.Byte( index2 + 1 )
		  dataPtr.Byte( index2 + 1 ) = dataPtr.Byte( index1 + 1 )
		  dataPtr.Byte( index1 + 1 ) = dataPtr.Byte( index0 + 1 )
		  dataPtr.Byte( index0 + 1 ) = temp
		  
		  //
		  // Rotate second row 2 columns to right 
		  //
		  temp = dataPtr.Byte( index0 + 2 )
		  dataPtr.Byte( index0 + 2 ) = dataPtr.Byte( index2 + 2 )
		  dataPtr.Byte( index2 + 2 ) = temp
		  
		  temp = dataPtr.Byte( index1 + 2 )
		  dataPtr.Byte( index1 + 2 ) = dataPtr.Byte( index3 + 2 )
		  dataPtr.Byte( index3 + 2 ) = temp
		  
		  //
		  // Rotate third row 3 columns to right
		  //
		  temp = dataPtr.Byte( index0 + 3 )
		  dataPtr.Byte( index0 + 3 ) = dataPtr.Byte( index1 + 3 )
		  dataPtr.Byte( index1 + 3 ) = dataPtr.Byte( index2 + 3 )
		  dataPtr.Byte( index2 + 3 ) = dataPtr.Byte( index3 + 3 )
		  dataPtr.Byte( index3 + 3 ) = temp
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub InvSubBytes(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into InvCipher
		  //
		  
		  dim ptrInvSbox as ptr = InvSbox
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex As integer = ( j * 4 + i ) + startAt
		      dataPtr.Byte( dataIndex ) = ptrInvSbox.Byte( dataPtr.Byte( dataIndex ) )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub MixColumns(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into Cipher
		  //
		  
		  const kOne As integer = 1
		  const kShift1 As integer = 2
		  const kShift7 As integer = 128
		  const kXtimeMult As integer = &h1B
		  
		  for i As integer = 0 to 3
		    dim dataIndex As integer = ( i * 4 ) + startAt
		    
		    dim byte0 As integer = dataPtr.Byte( dataIndex + 0 )
		    dim byte1 As integer = dataPtr.Byte( dataIndex + 1 )
		    dim byte2 As integer = dataPtr.Byte( dataIndex + 2 )
		    dim byte3 As integer = dataPtr.Byte( dataIndex + 3 )
		    
		    dim tmp As integer = byte0 xor byte1 xor byte2 xor byte3
		    
		    dim tm As integer
		    
		    tm = byte0 xor byte1
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = XtimePtr.Byte( tm )
		    
		    dataPtr.Byte( dataIndex + 0 ) = byte0 xor ( tm xor tmp )
		    
		    tm = byte1 xor byte2
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = XtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 1 ) = byte1 xor ( tm xor tmp )
		    
		    tm = byte2 xor byte3
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = XtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 2 ) = byte2 xor ( tm xor tmp )
		    
		    tm = byte3 xor byte0
		    'tm = Xtime( tm )
		    'tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    tm = XtimePtr.Byte( tm )
		    dataPtr.Byte( dataIndex + 3 ) = byte3 xor ( tm xor tmp )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function Multiply(x As Integer, y As Integer) As integer
		  const kOne As integer = 1
		  const kShift1 As integer = 2
		  const kShift2 As integer = 4
		  const kShift3 As integer = 8
		  const kShift4 As integer = 16
		  const kShift7 As integer = 128
		  const kXtimeMult As integer = &h1B
		  
		  dim xtimex1 As integer = XtimePtr.Byte( x )
		  dim xtimex2 As integer = XtimePtr.Byte( xtimex1 )
		  dim xtimex3 As integer = XtimePtr.Byte( xtimex2 )
		  dim xtimex4 As integer = XtimePtr.Byte( xtimex3 )
		  
		  return ( ( y and kOne ) * x ) xor _
		  ( ( ( y \ kShift1 ) and kOne ) * xtimex1 ) xor _
		  ( ( ( y \ kShift2 ) and kOne ) * xtimex2 ) xor _
		  ( ( ( y \ kShift3 ) and kOne ) * xtimex3 ) xor _
		  ( ( ( y \ kShift4 ) and kOne ) * xtimex4 )
		  
		  'dim xtimex As integer = Xtime( x )
		  'dim xtimex2 As integer = Xtime( xtimex )
		  'dim xtimex3 As integer = Xtime( xtimex2 )
		  'dim xtimex4 As integer = Xtime( xtimex3 )
		  '
		  'return ( ( ( y and kOne ) * x ) xor _
		  '( ( Bitwise.ShiftRight( y, 1, 8 ) and kOne ) * Xtime( x ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 2, 8 ) and kOne ) * Xtime( Xtime( x ) ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 3, 8 ) and kOne ) * Xtime( Xtime( Xtime( x ) ) ) ) xor _
		  '( ( Bitwise.ShiftRight( y, 4, 8 ) and kOne ) * Xtime( Xtime( Xtime( Xtime( x ) ) ) ) ) )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub ShiftRows(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into Cipher
		  //
		  
		  dim index0 As integer = startAt
		  dim index1 As integer = index0 + 4
		  dim index2 As integer = index0 + 8
		  dim index3 As integer = index0 + 12
		  
		  dim temp As integer 
		  
		  //
		  // Rotate first row 1 columns to left  
		  //
		  temp = dataPtr.Byte( index0 + 1 )
		  dataPtr.Byte( index0 + 1 ) = dataPtr.Byte( index1 + 1 )
		  dataPtr.Byte( index1 + 1 ) = dataPtr.Byte( index2 + 1 )
		  dataPtr.Byte( index2 + 1 ) = dataPtr.Byte( index3 + 1 )
		  dataPtr.Byte( index3 + 1 ) = temp
		  
		  //
		  // Rotate second row 2 columns to left  
		  //
		  temp = dataPtr.Byte( index0 + 2 )
		  dataPtr.Byte( index0 + 2 ) = dataPtr.Byte( index2 + 2 )
		  dataPtr.Byte( index2 + 2 ) = temp
		  
		  temp = dataPtr.Byte( index1 + 2 )
		  dataPtr.Byte( index1 + 2 ) = dataPtr.Byte( index3 + 2 )
		  dataPtr.Byte( index3 + 2 ) = temp
		  
		  //
		  // Rotate third row 3 columns to left
		  //
		  temp = dataPtr.Byte( index0 + 3 )
		  dataPtr.Byte( index0 + 3 ) = dataPtr.Byte( index3 + 3 )
		  dataPtr.Byte( index3 + 3 ) = dataPtr.Byte( index2 + 3 )
		  dataPtr.Byte( index2 + 3 ) = dataPtr.Byte( index1 + 3 )
		  dataPtr.Byte( index1 + 3 ) = temp
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Attributes( deprecated ) Private Sub SubBytes(dataPtr As Ptr, startAt As Integer)
		  //
		  // For reference only
		  // This was manually unrolled into Cipher
		  //
		  
		  dim ptrSbox as ptr = Sbox
		  
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex As integer = ( j * 4 + i ) + startAt
		      dataPtr.Byte( dataIndex ) = ptrSbox.Byte( dataPtr.Byte( dataIndex ) )
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub XorWithVector(dataPtr As Ptr, startAt As Integer, vectorPtr As Ptr)
		  dataPtr.UInt64( startAt ) = dataPtr.UInt64( startAt ) xor vectorPtr.UInt64( 0 )
		  dim dataIndex As integer = startAt + 8
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
		Private Shared MultiplyH9Ptr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHBMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHBPtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHDMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHDPtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHEMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared MultiplyHEPtr As Ptr
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
		Private Shared XtimePtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private zBits As Integer
	#tag EndProperty


	#tag Constant, Name = kBlockLen, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kNb, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.3", Scope = Public
	#tag EndConstant


	#tag Enum, Name = EncryptionBits, Type = Integer, Flags = &h0
		Bits128 = 128
		  Bits192 = 192
		Bits256 = 256
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Bits"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BlockSize"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentVector"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PaddingMethod"
			Group="Behavior"
			Type="Padding"
			EditorType="Enum"
			#tag EnumValues
				"0 - NullsOnly"
				"1 - NullsWithCount"
				"2 - PKCS"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFunction"
			Group="Behavior"
			Type="Functions"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - ECB"
				"2 - CBC"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
