#tag Class
Class AES_MTC
Inherits M_Crypto.Encrypter
	#tag Event
		Sub Decrypt(type As EncryptionTypes, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case EncryptionTypes.Plain, EncryptionTypes.ECB
		    DecryptECB data, isFinalBlock
		    
		  case EncryptionTypes.CBC
		    DecryptCBC data, isFinalBlock
		    
		  case else
		    raise new M_Crypto.UnsupportedEncryptionTypeException
		    
		  end select
		End Sub
	#tag EndEvent

	#tag Event
		Sub Encrypt(type As EncryptionTypes, data As MemoryBlock, isFinalBlock As Boolean)
		  select case type
		  case EncryptionTypes.Plain, EncryptionTypes.ECB
		    EncryptECB( data, isFinalBlock )
		    
		  case EncryptionTypes.CBC
		    EncryptCBC( data, isFinalBlock )
		    
		  case else
		    raise new M_Crypto.UnsupportedEncryptionTypeException
		    
		  end select
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddRoundKey(round As Integer, dataPtr As Ptr, startAt As Integer)
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
		  
		  dim round As integer = 0
		  
		  //
		  // Add the First round key to the dataPtr, startAt before starting the rounds.
		  //
		  AddRoundKey( round, dataPtr, startAt )
		  
		  //
		  // There will be NumberOfRounds rounds.
		  // The first NumberOfRounds-1 rounds are identical.
		  // These NumberOfRounds-1 rounds are executed in the loop below.
		  //
		  dim lastRound As integer = NumberOfRounds - 1
		  for round = 1 to lastRound
		    SubBytes( dataPtr, startAt )
		    ShiftRows( dataPtr, startAt )
		    MixColumns( dataPtr, startAt )
		    AddRoundKey( round, dataPtr, startAt )
		  next
		  
		  //
		  // The last round is given below.
		  // The MixColumns function is not here in the last round.
		  //
		  SubBytes( dataPtr, startAt )
		  ShiftRows( dataPtr, startAt )
		  AddRoundKey( NumberOfRounds, dataPtr, startAt )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(key As String, bits As EncryptionBits = EncryptionBits.Bits128, paddingMethod As Padding = Padding.PKCS5)
		  RaiseErrorIf key = "", kErrorKeyCannotBeEmpty
		  
		  InitSbox
		  InitInvSbox
		  InitRcon
		  
		  BlockSize = kBlockLen
		  
		  self.Bits = Integer( bits )
		  self.PaddingMethod = paddingMethod
		  
		  dim nk As integer
		  
		  select case bits
		  case AES_MTC.EncryptionBits.Bits256
		    nk = 8
		    KeyLen = 32
		    NumberOfRounds = 14
		    KeyExpSize = 240
		    
		  case AES_MTC.EncryptionBits.Bits192
		    nk = 6
		    KeyLen = 24
		    NumberOfRounds = 12
		    KeyExpSize = 208
		    
		  case AES_MTC.EncryptionBits.Bits128
		    nk = 4
		    KeyLen = 16
		    NumberOfRounds = 10
		    KeyExpSize = 176
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		  
		  KeyExpansion( key, nk )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  RaiseErrorIf( ( data.Size mod kBlockLen ) <> 0, kErrorDecryptionBlockSize )
		  
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
		  dim originalData as new MemoryBlock( data.Size )
		  originalData.StringValue( 0, data.Size ) = data.StringValue( 0, data.Size ) 
		  dim originalDataPtr as ptr = originalData
		  
		  dim vector as string = zCurrentVector
		  if vector = "" then
		    vector = InitialVector
		  end if
		  
		  dim vectorMB as MemoryBlock = GetVectorMB( vector )
		  dim vectorPtr as ptr = vectorMB
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    InvCipher dataPtr, startAt
		    XorWithVector dataPtr, startAt, vectorPtr
		    vectorPtr = ptr( integer( originalDataPtr ) + startAt )
		  next
		  
		  if isFinalBlock then
		    DepadIfNeeded( data )
		    zCurrentVector = ""
		  elseif dataPtr.Byte( data.Size - 1 ) = 0 then
		    data.Size = data.Size - 1
		    LastBlockHadNull = true
		  end if
		  
		  if not isFinalBlock then
		    vectorMB = vectorPtr
		    zCurrentVector = vectorMB.StringValue( 0, kBlockLen )
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecryptECB(data As MemoryBlock, isFinalBlock As Boolean = True)
		  RaiseErrorIf( ( data.Size mod kBlockLen ) <> 0, kErrorDecryptionBlockSize )
		  
		  dim dataPtr as ptr = data
		  
		  dim lastIndex As integer = data.Size - 1
		  for startAt As integer = 0 to lastIndex step kBlockLen
		    InvCipher( dataPtr, startAt )
		  next
		  
		  if isFinalBlock then
		    DepadIfNeeded( data )
		  elseif dataPtr.Byte( data.Size - 1 ) = 0 then
		    data.Size = data.Size - 1
		    LastBlockHadNull = true
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True)
		  if isFinalBlock then
		    PadIfNeeded( data )
		  else
		    RaiseErrorIf( ( data.Size mod kBlockLen ) <> 0, kErrorIntermediateEncyptionBlockSize )
		  end if
		  
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  dim dataPtr as ptr = data 
		  
		  dim vector as string = zCurrentVector
		  if vector = "" then
		    vector = InitialVector
		  end if
		  
		  dim vectorMB as MemoryBlock = GetVectorMB( vector )
		  dim vectorPtr as ptr = vectorMB
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    XorWithVector dataPtr, startAt, vectorPtr
		    Cipher dataPtr, startAt
		    vectorPtr = Ptr( integer( dataPtr ) + startAt )
		    'vectorMB.StringValue( 0, vectorMB.Size ) = data.StringValue( startAt, vectorMB.Size )
		  next
		  
		  if isFinalBlock then
		    zCurrentVector = ""
		  else
		    vectorMB = vectorPtr
		    zCurrentVector = vectorMB.StringValue( 0, kBlockLen )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EncryptECB(data As MemoryBlock, isFinalBlock As Boolean = True)
		  if isFinalBlock then
		    PadIfNeeded( data )
		  else
		    RaiseErrorIf( ( data.Size mod kBlockLen ) <> 0, kErrorIntermediateEncyptionBlockSize )
		  end if
		  
		  dim dataPtr as ptr = data
		  
		  dim lastByte As integer = data.Size - 1
		  for startAt As integer = 0 to lastByte step kBlockLen
		    Cipher( dataPtr, startAt )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetVectorMB(vector As String) As MemoryBlock
		  dim mb as new MemoryBlock( kBlockLen )
		  if vector <> "" then
		    vector = vector.LeftB( kBlockLen )
		    mb.StringValue( 0, vector.LenB ) = vector
		  end if
		  
		  return mb
		End Function
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
		Private Sub InvCipher(dataPtr As Ptr, startAt As Integer)
		  //
		  // Add the First round key to the state before starting the rounds.
		  //
		  AddRoundKey( NumberOfRounds, dataPtr, startAt )
		  
		  //
		  // There will be NumberOfRounds rounds.
		  // The first NumberOfRounds-1 rounds are identical.
		  // These NumberOfRounds-1 rounds are executed in the loop below.
		  //
		  dim lastRound As integer = NumberOfRounds - 1
		  for round As integer = lastRound downto 1
		    InvShiftRows( dataPtr, startAt )
		    InvSubBytes( dataPtr, startAt )
		    AddRoundKey( round, dataPtr, startAt )
		    InvMixColumns( dataPtr, startAt )
		  next
		  
		  //
		  // The last round is given below.
		  // The MixColumns function is not here in the last round.
		  //
		  InvShiftRows( dataPtr, startAt )
		  InvSubBytes( dataPtr, startAt )
		  AddRoundKey( 0, dataPtr, startAt )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvMixColumns(dataPtr As Ptr, startAt As Integer)
		  const kH9 As integer = &h09
		  const kHB As integer = &h0B
		  const kHD As integer = &h0D
		  const kHE As integer = &h0E
		  
		  for i As integer = 0 to 3
		    dim dataIndex As integer = ( i * 4 ) + startAt
		    
		    dim byte0 As integer = dataPtr.Byte( dataIndex + 0 )
		    dim byte1 As integer = dataPtr.Byte( dataIndex + 1 )
		    dim byte2 As integer = dataPtr.Byte( dataIndex + 2 )
		    dim byte3 As integer = dataPtr.Byte( dataIndex + 3 )
		    
		    dataPtr.Byte( dataIndex + 0 ) = Multiply( byte0, kHE ) xor Multiply( byte1, kHB ) xor Multiply( byte2, kHD ) xor Multiply( byte3, kH9 )
		    dataPtr.Byte( dataIndex + 1 ) = Multiply( byte0, kH9 ) xor Multiply( byte1, kHE ) xor Multiply( byte2, kHB ) xor Multiply( byte3, kHD )
		    dataPtr.Byte( dataIndex + 2 ) = Multiply( byte0, kHD ) xor Multiply( byte1, kH9 ) xor Multiply( byte2, kHE ) xor Multiply( byte3, kHB )
		    dataPtr.Byte( dataIndex + 3 ) = Multiply( byte0, kHB ) xor Multiply( byte1, kHD ) xor Multiply( byte2, kH9 ) xor Multiply( byte3, kHE )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InvShiftRows(dataPtr As Ptr, startAt As Integer)
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

	#tag Method, Flags = &h21
		Private Sub InvSubBytes(dataPtr As Ptr, startAt As Integer)
		  dim ptrInvSbox as ptr = InvSbox
		  for i As integer = 0 to 3
		    for j As integer = 0 to 3
		      dim dataIndex As integer = ( j * 4 + i ) + startAt
		      dataPtr.Byte( dataIndex ) = ptrInvSbox.Byte( dataPtr.Byte( dataIndex ) )
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub KeyExpansion(key As String, nk As Integer)
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
		Private Sub MixColumns(dataPtr As Ptr, startAt As Integer)
		  //
		  // Xtime was manually unrolled into this function as an optimization
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
		    tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    dataPtr.Byte( dataIndex + 0 ) = byte0 xor ( tm xor tmp )
		    
		    tm = byte1 xor byte2
		    'tm = Xtime( tm )
		    tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    dataPtr.Byte( dataIndex + 1 ) = byte1 xor ( tm xor tmp )
		    
		    tm = byte2 xor byte3
		    'tm = Xtime( tm )
		    tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    dataPtr.Byte( dataIndex + 2 ) = byte2 xor ( tm xor tmp )
		    
		    tm = byte3 xor byte0
		    'tm = Xtime( tm )
		    tm = ( tm * kShift1 )  xor ( ( ( tm \ kShift7 ) and kOne ) * kXtimeMult )
		    dataPtr.Byte( dataIndex + 3 ) = byte3 xor ( tm xor tmp )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Multiply(x As Integer, y As Integer) As integer
		  const kOne As integer = 1
		  const kShift1 As integer = 2
		  const kShift2 As integer = 4
		  const kShift3 As integer = 8
		  const kShift4 As integer = 16
		  const kShift7 As integer = 128
		  const kXtimeMult As integer = &h1B
		  
		  dim xtimex1 As integer = ( x * kShift1 )  xor ( ( ( x \ kShift7 ) and kOne ) * kXtimeMult )
		  dim xtimex2 As integer = ( xtimex1 * kShift1 )  xor ( ( ( xtimex1 \ kShift7 ) and kOne ) * kXtimeMult )
		  dim xtimex3 As integer = ( xtimex2 * kShift1 )  xor ( ( ( xtimex2 \ kShift7 ) and kOne ) * kXtimeMult )
		  dim xtimex4 As integer = ( xtimex3 * kShift1 )  xor ( ( ( xtimex3 \ kShift7 ) and kOne ) * kXtimeMult )
		  
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

	#tag Method, Flags = &h21
		Private Sub ShiftRows(dataPtr As Ptr, startAt As Integer)
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

	#tag Method, Flags = &h21
		Private Sub SubBytes(dataPtr As Ptr, startAt As Integer)
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

	#tag Method, Flags = &h21
		Attributes( deprecated ) Private Function Xtime(x As Integer) As integer
		  //
		  // This function is here for reference only
		  // For speed, it has been manually unrolled into its calling functions
		  //
		  
		  const kOne As integer = 1
		  const kShift1 As integer = 2
		  const kShift7 As integer = 128
		  const kXtimeMult As integer = &h1B
		  
		  return ( x * kShift1 )  xor ( ( ( x \ kShift7 ) and kOne ) * kXtimeMult )
		  
		  'return BitWise.ShiftLeft( x, 1, 8 ) xor ( ( Bitwise.ShiftRight( x, 7, 8 ) and 1 ) * &h1B )
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Bits As Integer
	#tag EndProperty

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


	#tag Constant, Name = kBlockLen, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorDecryptionBlockSize, Type = String, Dynamic = False, Default = \"Data blocks must be an exact multiple of 16 bytes", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kErrorIntermediateEncyptionBlockSize, Type = String, Dynamic = False, Default = \"Intermediate data blocks must be an exact multiple of 16 bytes for encryption\n  ", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kNb, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


	#tag Enum, Name = EncryptionBits, Type = Integer, Flags = &h0
		Bits128 = 128
		  Bits192 = 192
		Bits256 = 256
	#tag EndEnum


	#tag ViewBehavior
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
				"0 - NullPadding"
				"1 - PKCS5"
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
	#tag EndViewBehavior
End Class
#tag EndClass
