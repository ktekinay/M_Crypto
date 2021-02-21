#tag Class
Class SHA3Digest_MTC
	#tag Method, Flags = &h0
		Sub Constructor(bits As M_SHA3.Bits)
		  if KeccakfRndcMB is nil then
		    KeccakfRndcMB = new MemoryBlock( 24 * 8 )
		    KeccakfRndcPtr = KeccakfRndcMB
		    
		    var seed() as UInt64 = array( _
		    &h0000000000000001, &h0000000000008082, &h800000000000808a, _
		    &h8000000080008000, &h000000000000808b, &h0000000080000001, _
		    &h8000000080008081, &h8000000000008009, &h000000000000008a, _
		    &h0000000000000088, &h0000000080008009, &h000000008000000a, _
		    &h000000008000808b, &h800000000000008b, &h8000000000008089, _
		    &h8000000000008003, &h8000000000008002, &h8000000000000080, _
		    &h000000000000800a, &h800000008000000a, &h8000000080008081, _
		    &h8000000000008080, &h0000000080000001, &h8000000080008008 _
		    )
		    for i as integer = 0 to seed.LastIndex
		      KeccakfRndcPtr.UInt64( i * 8 ) = seed( i )
		    next
		  end if
		  
		  TMB = new MemoryBlock( 5 * 8 )
		  BcMB = new MemoryBlock( 5 * 8 )
		  
		  var ibits as integer = integer( bits )
		  ByteSize = ibits \ 8
		  BlockSize = 200 - 2 * ByteSize
		  BlockSizeW = BlockSize \ 8
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Keccakf(ByRef useState As StateStruct)
		  #if not DebugBuild then
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  var t as MemoryBlock = TMB
		  var tt as UInt64
		  var bc as MemoryBlock = BcMB
		  
		  var tPtr as ptr = t
		  var bcPtr as ptr = bc
		  
		  var lastTByte as integer = t.Size - 1
		  
		  for round as integer = 0  to kKeccakRounds
		    //
		    // Clear the MemoryBlocks
		    //
		    for i as integer = 0 to lastTByte step 8
		      tPtr.UInt64( i ) = 0
		      bcPtr.UInt64( i ) = 0
		    next
		    tt = 0
		    
		    //
		    // Theta
		    //
		    bcPtr.UInt64( 0 * 8 ) = useState.ST( 0 ) xor useState.ST( 5 ) xor useState.ST( 10 ) xor useState.ST( 15 ) xor useState.ST( 20 )
		    bcPtr.UInt64( 1 * 8 ) = useState.ST( 1 ) xor useState.ST( 6 ) xor useState.ST( 11 ) xor useState.ST( 16 ) xor useState.ST( 21 )
		    bcPtr.UInt64( 2 * 8 ) = useState.ST( 2 ) xor useState.ST( 7 ) xor useState.ST( 12 ) xor useState.ST( 17 ) xor useState.ST( 22 )
		    bcPtr.UInt64( 3 * 8 ) = useState.ST( 3 ) xor useState.ST( 8 ) xor useState.ST( 13 ) xor useState.ST( 18 ) xor useState.ST( 23 )
		    bcPtr.UInt64( 4 * 8 ) = useState.ST( 4 ) xor useState.ST( 9 ) xor useState.ST( 14 ) xor useState.ST( 19 ) xor useState.ST( 24 )
		    
		    tPtr.UInt64( 0 * 8 ) = bcPtr.UInt64( 4 * 8 ) xor Rol64( bcPtr.UInt64( 1 * 8 ), 1 )
		    tPtr.UInt64( 1 * 8 ) = bcPtr.UInt64( 0 * 8 ) xor Rol64( bcPtr.UInt64( 2 * 8 ), 1 )
		    tPtr.UInt64( 2 * 8 ) = bcPtr.UInt64( 1 * 8 ) xor Rol64( bcPtr.UInt64( 3 * 8 ), 1 )
		    tPtr.UInt64( 3 * 8 ) = bcPtr.UInt64( 2 * 8 ) xor Rol64( bcPtr.UInt64( 4 * 8 ), 1 )
		    tPtr.UInt64( 4 * 8 ) = bcPtr.UInt64( 3 * 8 ) xor Rol64( bcPtr.UInt64( 0 * 8 ), 1 )
		    
		    useState.ST( 0 ) = useState.ST( 0 ) xor tPtr.UInt64( 0 * 8 )
		    
		    //
		    // Rho Pi
		    //
		    tt = useState.ST( 1 )
		    useState.ST( 1 ) = Rol64( useState.ST( 6 ) xor tPtr.UInt64( 1 * 8 ), 44 )
		    useState.ST( 6 ) = Rol64( useState.ST( 9 ) xor tPtr.UInt64( 4 * 8 ), 20 )
		    useState.ST( 9 ) = Rol64( useState.ST( 22 ) xor tPtr.UInt64( 2 * 8 ), 61 )
		    useState.ST( 22 ) = Rol64( useState.ST( 14 ) xor tPtr.UInt64( 4 * 8 ), 39 )
		    useState.ST( 14 ) = Rol64( useState.ST( 20 ) xor tPtr.UInt64( 0 * 8 ), 18 )
		    useState.ST( 20 ) = Rol64( useState.ST( 2 ) xor tPtr.UInt64( 2 * 8 ), 62 )
		    useState.ST( 2 ) = Rol64( useState.ST( 12 ) xor tPtr.UInt64( 2 * 8 ), 43 )
		    useState.ST( 12 ) = Rol64( useState.ST( 13 ) xor tPtr.UInt64( 3 * 8 ), 25 )
		    useState.ST( 13 ) = Rol64( useState.ST( 19 ) xor tPtr.UInt64( 4 * 8 ), 8 )
		    useState.ST( 19 ) = Rol64( useState.ST( 23 ) xor tPtr.UInt64( 3 * 8 ), 56 )
		    useState.ST( 23 ) = Rol64( useState.ST( 15 ) xor tPtr.UInt64( 0 * 8 ), 41 )
		    useState.ST( 15 ) = Rol64( useState.ST( 4 ) xor tPtr.UInt64( 4 * 8 ), 27 )
		    useState.ST( 4 ) = Rol64( useState.ST( 24 ) xor tPtr.UInt64( 4 * 8 ), 14 )
		    useState.ST( 24 ) = Rol64( useState.ST( 21 ) xor tPtr.UInt64( 1 * 8 ), 2 )
		    useState.ST( 21 ) = Rol64( useState.ST( 8 ) xor tPtr.UInt64( 3 * 8 ), 55 )
		    useState.ST( 8 ) = Rol64( useState.ST( 16 ) xor tPtr.UInt64( 1 * 8 ), 45 )
		    useState.ST( 16 ) = Rol64( useState.ST( 5 ) xor tPtr.UInt64( 0 * 8 ), 36 )
		    useState.ST( 5 ) = Rol64( useState.ST( 3 ) xor tPtr.UInt64( 3 * 8 ), 28 )
		    useState.ST( 3 ) = Rol64( useState.ST( 18 ) xor tPtr.UInt64( 3 * 8 ), 21 )
		    useState.ST( 18 ) = Rol64( useState.ST( 17 ) xor tPtr.UInt64( 2 * 8 ), 15 )
		    useState.ST( 17 ) = Rol64( useState.ST( 11 ) xor tPtr.UInt64( 1 * 8 ), 10 )
		    useState.ST( 11 ) = Rol64( useState.ST( 7 ) xor tPtr.UInt64( 2 * 8 ), 6 )
		    useState.ST( 7 ) = Rol64( useState.ST( 10 ) xor tPtr.UInt64( 0 * 8 ), 3 )
		    useState.ST( 10 ) = Rol64( tt xor tPtr.UInt64( 1 * 8 ), 1 )
		    
		    //
		    // Chi
		    //
		    bcPtr.UInt64( 0 * 8 ) = ( not useState.ST( 1 ) ) and useState.ST( 2 )
		    bcPtr.UInt64( 1 * 8 ) = ( not useState.ST( 2 ) ) and useState.ST( 3 )
		    bcPtr.UInt64( 2 * 8 ) = ( not useState.ST( 3 ) ) and useState.ST( 4 )
		    bcPtr.UInt64( 3 * 8 ) = ( not useState.ST( 4 ) ) and useState.ST( 0 )
		    bcPtr.UInt64( 4 * 8 ) = ( not useState.ST( 0 ) ) and useState.ST( 1 )
		    useState.ST( 0 ) = useState.ST( 0 ) xor bcPtr.UInt64( 0 * 8 )
		    useState.ST( 1 ) = useState.ST( 1 ) xor bcPtr.UInt64( 1 * 8 )
		    useState.ST( 2 ) = useState.ST( 2 ) xor bcPtr.UInt64( 2 * 8 )
		    useState.ST( 3 ) = useState.ST( 3 ) xor bcPtr.UInt64( 3 * 8 )
		    useState.ST( 4 ) = useState.ST( 4 ) xor bcPtr.UInt64( 4 * 8 )
		    
		    bcPtr.UInt64( 0 * 8 ) = ( not useState.ST( 6 ) ) and useState.ST( 7 )
		    bcPtr.UInt64( 1 * 8 ) = ( not useState.ST( 7 ) ) and useState.ST( 8 )
		    bcPtr.UInt64( 2 * 8 ) = ( not useState.ST( 8 ) ) and useState.ST( 9 )
		    bcPtr.UInt64( 3 * 8 ) = ( not useState.ST( 9 ) ) and useState.ST( 5 )
		    bcPtr.UInt64( 4 * 8 ) = ( not useState.ST( 5 ) ) and useState.ST( 6 )
		    useState.ST( 5 ) = useState.ST( 5 ) xor bcPtr.UInt64( 0 * 8 )
		    useState.ST( 6 ) = useState.ST( 6 ) xor bcPtr.UInt64( 1 * 8 )
		    useState.ST( 7 ) = useState.ST( 7 ) xor bcPtr.UInt64( 2 * 8 )
		    useState.ST( 8 ) = useState.ST( 8 ) xor bcPtr.UInt64( 3 * 8 )
		    useState.ST( 9 ) = useState.ST( 9 ) xor bcPtr.UInt64( 4 * 8 )
		    
		    bcPtr.UInt64( 0 * 8 ) = ( not useState.ST( 11 ) ) and useState.ST( 12 )
		    bcPtr.UInt64( 1 * 8 ) = ( not useState.ST( 12 ) ) and useState.ST( 13 )
		    bcPtr.UInt64( 2 * 8 ) = ( not useState.ST( 13 ) ) and useState.ST( 14 )
		    bcPtr.UInt64( 3 * 8 ) = ( not useState.ST( 14 ) ) and useState.ST( 10 )
		    bcPtr.UInt64( 4 * 8 ) = ( not useState.ST( 10 ) ) and useState.ST( 11 )
		    useState.ST( 10 ) = useState.ST( 10 ) xor bcPtr.UInt64( 0 * 8 )
		    useState.ST( 11 ) = useState.ST( 11 ) xor bcPtr.UInt64( 1 * 8 )
		    useState.ST( 12 ) = useState.ST( 12 ) xor bcPtr.UInt64( 2 * 8 )
		    useState.ST( 13 ) = useState.ST( 13 ) xor bcPtr.UInt64( 3 * 8 )
		    useState.ST( 14 ) = useState.ST( 14 ) xor bcPtr.UInt64( 4 * 8 )
		    
		    bcPtr.UInt64( 0 * 8 ) = ( not useState.ST( 16 ) ) and useState.ST( 17 )
		    bcPtr.UInt64( 1 * 8 ) = ( not useState.ST( 17 ) ) and useState.ST( 18 )
		    bcPtr.UInt64( 2 * 8 ) = ( not useState.ST( 18 ) ) and useState.ST( 19 )
		    bcPtr.UInt64( 3 * 8 ) = ( not useState.ST( 19 ) ) and useState.ST( 15 )
		    bcPtr.UInt64( 4 * 8 ) = ( not useState.ST( 15 ) ) and useState.ST( 16 )
		    useState.ST( 15 ) = useState.ST( 15 ) xor bcPtr.UInt64( 0 * 8 )
		    useState.ST( 16 ) = useState.ST( 16 ) xor bcPtr.UInt64( 1 * 8 )
		    useState.ST( 17 ) = useState.ST( 17 ) xor bcPtr.UInt64( 2 * 8 )
		    useState.ST( 18 ) = useState.ST( 18 ) xor bcPtr.UInt64( 3 * 8 )
		    useState.ST( 19 ) = useState.ST( 19 ) xor bcPtr.UInt64( 4 * 8 )
		    
		    bcPtr.UInt64( 0 * 8 ) = ( not useState.ST( 21 ) ) and useState.ST( 22 )
		    bcPtr.UInt64( 1 * 8 ) = ( not useState.ST( 22 ) ) and useState.ST( 23 )
		    bcPtr.UInt64( 2 * 8 ) = ( not useState.ST( 23 ) ) and useState.ST( 24 )
		    bcPtr.UInt64( 3 * 8 ) = ( not useState.ST( 24 ) ) and useState.ST( 20 )
		    bcPtr.UInt64( 4 * 8 ) = ( not useState.ST( 20 ) ) and useState.ST( 21 )
		    useState.ST( 20 ) = useState.ST( 20 ) xor bcPtr.UInt64( 0 * 8 )
		    useState.ST( 21 ) = useState.ST( 21 ) xor bcPtr.UInt64( 1 * 8 )
		    useState.ST( 22 ) = useState.ST( 22 ) xor bcPtr.UInt64( 2 * 8 )
		    useState.ST( 23 ) = useState.ST( 23 ) xor bcPtr.UInt64( 3 * 8 )
		    useState.ST( 24 ) = useState.ST( 24 ) xor bcPtr.UInt64( 4 * 8 )
		    
		    //
		    // Iota
		    //
		    useState.ST( 0 ) = useState.ST( 0 ) xor KeccakfRndcPtr.UInt64( round * 8 )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(mbIn As MemoryBlock, ByRef useState As StateStruct, isFinal As Boolean)
		  #if not DebugBuild then
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  #if not TargetLittleEndian then
		    mbIn.LittleEndian = true
		  #endif
		  
		  if isFinal then
		    //
		    // Pad the data
		    //
		    var remainder as integer = BlockSize - ( mbIn.Size mod BlockSize )
		    
		    var nextByteIndex as integer = mbIn.Size
		    mbIn.Size = nextByteIndex + remainder
		    if remainder = 1 then
		      mbIn.Byte( nextByteIndex ) = &h86
		    else
		      mbIn.Byte( nextByteIndex ) = &h06
		      mbIn.Byte( mbIn.Size - 1 ) = &h80
		    end if
		  end if
		  
		  var mbPtr as ptr = mbIn
		  
		  var lastMBByteIndex as integer = mbIn.Size - 1
		  var lastStateIndex as integer = BlockSizeW - 1
		  
		  for byteIndex as integer = 0 to lastMBByteIndex step BlockSize
		    for stateIndex as integer = 0 to lastStateIndex
		      var relativeIndex as integer = byteIndex + stateIndex * 8
		      
		      var unaligned as UInt64
		      #if TargetLittleEndian then
		        unaligned = mbPtr.UInt64( relativeIndex )
		      #else
		        unaligned = mbIn.UInt64Value( relativeIndex )
		      #endif
		      
		      useState.ST( stateIndex ) = useState.ST( stateIndex ) xor unaligned
		    next
		    
		    Keccakf( useState )
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process(data As String)
		  if Buffer <> "" then
		    data = Buffer + data
		    Buffer = ""
		  end if
		  
		  dim dataLen as integer = data.LenB
		  dim remainder as integer = dataLen mod BlockSize
		  if remainder <> 0 then
		    Buffer = data.RightB( remainder )
		    dataLen = dataLen - remainder
		    data = data.LeftB( dataLen )
		  end if
		  
		  if data <> "" then
		    Process data, CurrentState, false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  var newState as StateStruct
		  CurrentState = newState
		  
		  Buffer = ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Rol64(val As UInt64, shift As Integer) As UInt64
		  #if not DebugBuild then
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  const kShift1 as UInt64 =  &b10
		  const kShift2 as UInt64 =  &b100
		  const kShift3 as UInt64 =  &b1000
		  const kShift4 as UInt64 =  &b10000
		  const kShift5 as UInt64 =  &b100000
		  const kShift6 as UInt64 =  &b1000000
		  const kShift7 as UInt64 =  &b10000000
		  const kShift8 as UInt64 =  &b100000000
		  const kShift9 as UInt64 =  &b1000000000
		  const kShift10 as UInt64 = &b10000000000
		  const kShift11 as UInt64 = &b100000000000
		  const kShift12 as UInt64 = &b1000000000000
		  const kShift13 as UInt64 = &b10000000000000
		  const kShift14 as UInt64 = &b100000000000000
		  const kShift15 as UInt64 = &b1000000000000000
		  const kShift16 as UInt64 = &b10000000000000000
		  const kShift17 as UInt64 = &b100000000000000000
		  const kShift18 as UInt64 = &b1000000000000000000
		  const kShift19 as UInt64 = &b10000000000000000000
		  const kShift20 as UInt64 = &b100000000000000000000
		  const kShift21 as UInt64 = &b1000000000000000000000
		  const kShift22 as UInt64 = &b10000000000000000000000
		  const kShift23 as UInt64 = &b100000000000000000000000
		  const kShift24 as UInt64 = &b1000000000000000000000000
		  const kShift25 as UInt64 = &b10000000000000000000000000
		  const kShift26 as UInt64 = &b100000000000000000000000000
		  const kShift27 as UInt64 = &b1000000000000000000000000000
		  const kShift28 as UInt64 = &b10000000000000000000000000000
		  const kShift29 as UInt64 = &b100000000000000000000000000000
		  const kShift30 as UInt64 = &b1000000000000000000000000000000
		  const kShift31 as UInt64 = &b10000000000000000000000000000000
		  const kShift32 as UInt64 = &b100000000000000000000000000000000
		  const kShift33 as UInt64 = &b1000000000000000000000000000000000
		  const kShift34 as UInt64 = &b10000000000000000000000000000000000
		  const kShift35 as UInt64 = &b100000000000000000000000000000000000
		  const kShift36 as UInt64 = &b1000000000000000000000000000000000000
		  const kShift37 as UInt64 = &b10000000000000000000000000000000000000
		  const kShift38 as UInt64 = &b100000000000000000000000000000000000000
		  const kShift39 as UInt64 = &b1000000000000000000000000000000000000000
		  const kShift40 as UInt64 = &b10000000000000000000000000000000000000000
		  const kShift41 as UInt64 = &b100000000000000000000000000000000000000000
		  const kShift42 as UInt64 = &b1000000000000000000000000000000000000000000
		  const kShift43 as UInt64 = &b10000000000000000000000000000000000000000000
		  const kShift44 as UInt64 = &b100000000000000000000000000000000000000000000
		  const kShift45 as UInt64 = &b1000000000000000000000000000000000000000000000
		  const kShift46 as UInt64 = &b10000000000000000000000000000000000000000000000
		  const kShift47 as UInt64 = &b100000000000000000000000000000000000000000000000
		  const kShift48 as UInt64 = &b1000000000000000000000000000000000000000000000000
		  const kShift49 as UInt64 = &b10000000000000000000000000000000000000000000000000
		  const kShift50 as UInt64 = &b100000000000000000000000000000000000000000000000000
		  const kShift51 as UInt64 = &b1000000000000000000000000000000000000000000000000000
		  const kShift52 as UInt64 = &b10000000000000000000000000000000000000000000000000000
		  const kShift53 as UInt64 = &b100000000000000000000000000000000000000000000000000000
		  const kShift54 as UInt64 = &b1000000000000000000000000000000000000000000000000000000
		  const kShift55 as UInt64 = &b10000000000000000000000000000000000000000000000000000000
		  const kShift56 as UInt64 = &b100000000000000000000000000000000000000000000000000000000
		  const kShift57 as UInt64 = &b1000000000000000000000000000000000000000000000000000000000
		  const kShift58 as UInt64 = &b10000000000000000000000000000000000000000000000000000000000
		  const kShift59 as UInt64 = &b100000000000000000000000000000000000000000000000000000000000
		  const kShift60 as UInt64 = &b1000000000000000000000000000000000000000000000000000000000000
		  const kShift61 as UInt64 = &b10000000000000000000000000000000000000000000000000000000000000
		  const kShift62 as UInt64 = &b100000000000000000000000000000000000000000000000000000000000000
		  const kShift63 as UInt64 = &b1000000000000000000000000000000000000000000000000000000000000000
		  
		  select case shift
		  case 0
		    return val
		    
		  case 1
		    return ( val * kShift1 ) or ( val \ kShift63 )
		    
		  case 2
		    return ( val * kShift2 ) or ( val \ kShift62 )
		    
		  case 3
		    return ( val * kShift3 ) or ( val \ kShift61 )
		    
		  case 4
		    return ( val * kShift4 ) or ( val \ kShift60 )
		    
		  case 6
		    return ( val * kShift6 ) or ( val \ kShift58 )
		    
		  case 8
		    return ( val * kShift8 ) or ( val \ kShift56 )
		    
		  case 10
		    return ( val * kShift10 ) or ( val \ kShift54 )
		    
		  case 14
		    return ( val * kShift14 ) or ( val \ kShift50 )
		    
		  case 15
		    return ( val * kShift15 ) or ( val \ kShift49 )
		    
		  case 18
		    return ( val * kShift18 ) or ( val \ kShift46 )
		    
		  case 20
		    return ( val * kShift20 ) or ( val \ kShift44 )
		    
		  case 21
		    return ( val * kShift21 ) or ( val \ kShift43 )
		    
		  case 25
		    return ( val * kShift25 ) or ( val \ kShift39 )
		    
		  case 27
		    return ( val * kShift27 ) or ( val \ kShift37 )
		    
		  case 28
		    return ( val * kShift28 ) or ( val \ kShift36 )
		    
		  case 36
		    return ( val * kShift36 ) or ( val \ kShift28 )
		    
		  case 39
		    return ( val * kShift39 ) or ( val \ kShift25 )
		    
		  case 41
		    return ( val * kShift41 ) or ( val \ kShift23 )
		    
		  case 43
		    return ( val * kShift43 ) or ( val \ kShift21 )
		    
		  case 44
		    return ( val * kShift44 ) or ( val \ kShift20 )
		    
		  case 45
		    return ( val * kShift45 ) or ( val \ kShift19 )
		    
		  case 47
		    return ( val * kShift47 ) or ( val \ kShift17 )
		    
		  case 51
		    return ( val * kShift51 ) or ( val \ kShift13 )
		    
		  case 55
		    return ( val * kShift55 ) or ( val \ kShift9 )
		    
		  case 56
		    return ( val * kShift56 ) or ( val \ kShift8 )
		    
		  case 61
		    return ( val * kShift61 ) or ( val \ kShift3 )
		    
		  case 62
		    return ( val * kShift62 ) or ( val \ kShift2 )
		    
		  case else
		    break
		    
		  end select
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private BcMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private BlockSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private BlockSizeW As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Buffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ByteSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CurrentState As StateStruct
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared KeccakfRndcMB As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared KeccakfRndcPtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TMB As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim finalState as StateStruct = CurrentState
			  Process Buffer, finalState, true
			  
			  return finalState.StringValue( true ).LeftBytes( ByteSize )
			End Get
		#tag EndGetter
		Value As String
	#tag EndComputedProperty


	#tag Constant, Name = kKeccakRounds, Type = Double, Dynamic = False, Default = \"23", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.7", Scope = Public
	#tag EndConstant


	#tag Structure, Name = StateStruct, Flags = &h21
		ST(24) As UInt64
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
