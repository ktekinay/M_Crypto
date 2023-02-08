#tag Class
Protected Class Blake2bDigest_MTC
	#tag Method, Flags = &h0
		Sub Constructor(hashLength As Integer = kMaxLength)
		  Constructor hashLength, ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(hashLength As Integer, key As String)
		  if IV is nil then
		    InitIV
		    InitSigma
		  end if
		  
		  if hashLength < 1 or hashLength > kMaxLength or key.Bytes > kMaxLength then
		    raise new OutOfBoundsException
		  end if
		  
		  self.HashLength = hashLength
		  
		  if key <> "" then
		    KeyLength = key.Bytes
		    self.Key = new MemoryBlock( kChunkBytes )
		    self.Key.StringValue( 0, KeyLength ) = key
		  end if
		  
		  Reset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(key As String)
		  Constructor kMaxLength, key
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function FromBytes(ParamArray bytes() As Byte) As MemoryBlock
		  var mb as new MemoryBlock( bytes.Count )
		  var p as Ptr = mb
		  
		  for i as integer = 0 to bytes.LastIndex
		    p.Byte( i ) = bytes( i ) * 8
		  next
		  
		  return mb
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitIV()
		  IV = new MemoryBlock( 8 * 8 )
		  var pIv as Ptr = IV
		  
		  pIV.UInt64( 0 * 8 ) = &h6a09e667f3bcc908   // Frac(sqrt(2))
		  pIV.UInt64( 1 * 8 ) = &hbb67ae8584caa73b   // Frac(sqrt(3))
		  pIV.UInt64( 2 * 8 ) = &h3c6ef372fe94f82b   // Frac(sqrt(5))
		  pIV.UInt64( 3 * 8 ) = &ha54ff53a5f1d36f1   // Frac(sqrt(7))
		  pIV.UInt64( 4 * 8 ) = &h510e527fade682d1   // Frac(sqrt(11))
		  pIV.UInt64( 5 * 8 ) = &h9b05688c2b3e6c1f   // Frac(sqrt(13))
		  pIV.UInt64( 6 * 8 ) = &h1f83d9abfb41bd6b   // Frac(sqrt(17))
		  pIV.UInt64( 7 * 8 ) = &h5be0cd19137e2179   // Frac(sqrt(19))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitSigma()
		  'Round   |  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 |
		  '----------+-------------------------------------------------+
		  'SIGMA[0] |  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 |
		  'SIGMA[1] | 14 10  4  8  9 15 13  6  1 12  0  2 11  7  5  3 |
		  'SIGMA[2] | 11  8 12  0  5  2 15 13 10 14  3  6  7  1  9  4 |
		  'SIGMA[3] |  7  9  3  1 13 12 11 14  2  6  5 10  4  0 15  8 |
		  'SIGMA[4] |  9  0  5  7  2  4 10 15 14  1 11 12  6  8  3 13 |
		  'SIGMA[5] |  2 12  6 10  0 11  8  3  4 13  7  5 15 14  1  9 |
		  'SIGMA[6] | 12  5  1 15 14 13  4 10  0  7  6  3  9  2  8 11 |
		  'SIGMA[7] | 13 11  7 14 12  1  3  9  5  0 15  4  8  6  2 10 |
		  'SIGMA[8] |  6 15 14  9 11  3  0  8 12  2 13  7  1  4 10  5 |
		  'SIGMA[9] | 10  2  8  4  7  6  1  5 15 11  9 14  3 12 13  0 |
		  '----------+-------------------------------------------------+
		  
		  Sigma = new MemoryBlock( 12 * 16 )
		  
		  Sigma.CopyBytes FromBytes(  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 ), 0, 16,   0
		  Sigma.CopyBytes FromBytes( 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 ), 0, 16,  16
		  Sigma.CopyBytes FromBytes( 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 ), 0, 16,  32
		  Sigma.CopyBytes FromBytes(  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 ), 0, 16,  48
		  Sigma.CopyBytes FromBytes(  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 ), 0, 16,  64
		  Sigma.CopyBytes FromBytes(  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 ), 0, 16,  80
		  Sigma.CopyBytes FromBytes( 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 ), 0, 16,  96
		  Sigma.CopyBytes FromBytes( 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 ), 0, 16, 112
		  Sigma.CopyBytes FromBytes(  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 ), 0, 16, 128
		  Sigma.CopyBytes FromBytes( 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13,  0 ), 0, 16, 144
		  
		  //
		  // Last two rounds are the same as the first two
		  //
		  Sigma.CopyBytes Sigma, 0, 32, 160
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(data As MemoryBlock, compressed As UInt64, state As MemoryBlock, finalMask As UInt64)
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  //
		  // data will be a multiple of kChunkSize exactly
		  //
		  
		  var dataPtr as ptr = data
		  var statePtr as ptr = state
		  
		  var localVector as MemoryBlock = self.LocalVector
		  var localVectorPtr as ptr = localVector
		  
		  const R1 as integer = 32
		  const R2 as integer = 24
		  const R3 as integer = 16
		  const R4 as integer = 63
		  
		  const R1ShiftRight as UInt64 = 2 ^ R1
		  const R1ShiftLeft as UInt64 = 2 ^ ( 64 - R1 )
		  
		  const R2ShiftRight as UInt64 = 2 ^ R2
		  const R2ShiftLeft as UInt64 = 2 ^ ( 64 - R2 )
		  
		  const R3ShiftRight as UInt64 = 2 ^ R3
		  const R3ShiftLeft as UInt64 = 2 ^ ( 64 - R3 )
		  
		  const R4ShiftRight as UInt64 = 2 ^ R4
		  const R4ShiftLeft as UInt64 = 2 ^ ( 64 - R4 )
		  
		  var aIndex, bIndex, cIndex, dIndex as integer
		  var a, b, c, d as UInt64
		  var x, y as UInt64
		  
		  //
		  // Unbelievably, looping through these MemoryBlocks is faster
		  // than unrolling the loop
		  //
		  static mixA as MemoryBlock = FromBytes( 0, 1, 2, 3, 0, 1, 2, 3 )
		  static mixB as MemoryBlock = FromBytes( 4, 5, 6, 7, 5, 6, 7, 4 )
		  static mixC as MemoryBlock = FromBytes( 8, 9, 10, 11, 10, 11, 8, 9 )
		  static mixD as MemoryBlock = FromBytes( 12, 13, 14, 15, 15, 12, 13, 14 )
		  
		  static mixAPtr as ptr = mixA
		  static mixBPtr as ptr = mixB
		  static mixCPtr as ptr = mixC
		  static mixDPtr as ptr = mixD
		  
		  const kLastMixIndex as integer = 7
		  const kLastSigmaIndex as integer = 11
		  
		  var sigmaIndex as integer
		  var thisSigma as ptr = Sigma
		  
		  var round as integer
		  var dataByteIndex as integer
		  var mixIndex as integer
		  
		  var lastDataIndex as integer = data.Size - 1
		  
		  for dataByteIndex = 0 to lastDataIndex step kChunkBytes
		    //
		    // Compress state, mbIn, byteIndex, combinedLength, isFinal
		    //
		    localVector.CopyBytes state, 0, kChunkBytes // Includes IV in the lower 64 bytes
		    
		    localVectorPtr.UInt64( 12 * 8 ) = localVectorPtr.UInt64( 12 * 8 ) xor compressed
		    'localVectorPtr.UInt64( 13 * 8 ) = localVectorPtr.UInt64( 13 * 8 ) xor 0 // Supposed to be the high bits, but we don't have them
		    
		    localVectorPtr.UInt64( 14 * 8 ) = localVectorPtr.UInt64( 14 * 8 ) xor finalMask
		    
		    for round = 0 to kLastSigmaIndex
		      sigmaIndex = ( round * 16 ) - 2
		      
		      for mixIndex = 0 to kLastMixIndex
		        sigmaIndex = sigmaIndex + 2
		        
		        aIndex = mixAPtr.Byte( mixIndex )
		        bIndex = mixBPtr.Byte( mixIndex )
		        cIndex = mixCPtr.Byte( mixIndex )
		        dIndex = mixDPtr.Byte( mixIndex )
		        
		        a = localVectorPtr.UInt64( aIndex )
		        b = localVectorPtr.UInt64( bIndex )
		        c = localVectorPtr.UInt64( cIndex )
		        d = localVectorPtr.UInt64( dIndex )
		        
		        x = dataPtr.UInt64( thisSigma.Byte( sigmaIndex ) )
		        y = dataPtr.UInt64( thisSigma.Byte( sigmaIndex + 1 ) )
		        
		        a = a + b + x
		        d = d xor a
		        d = ( d \ R1ShiftRight ) xor ( d * R1ShiftLeft )
		        
		        c = c + d
		        b = b xor c
		        b = ( b \ R2ShiftRight ) xor ( b * R2ShiftLeft )
		        
		        a = a + b + y
		        d = d xor a
		        d = ( d \ R3ShiftRight ) xor ( d * R3ShiftLeft )
		        
		        c = c + d
		        b = b xor c
		        b = ( b \ R4ShiftRight ) xor ( b * R4ShiftLeft )
		        
		        localVectorPtr.UInt64( aIndex ) = a
		        localVectorPtr.UInt64( bIndex ) = b
		        localVectorPtr.UInt64( cIndex ) = c
		        localVectorPtr.UInt64( dIndex ) = d
		      next
		    next
		    
		    statePtr.UInt64(  0 ) = statePtr.UInt64(  0 ) xor localVectorPtr.UInt64(  0 ) xor localVectorPtr.UInt64(  64 )
		    statePtr.UInt64(  8 ) = statePtr.UInt64(  8 ) xor localVectorPtr.UInt64(  8 ) xor localVectorPtr.UInt64(  72 )
		    statePtr.UInt64( 16 ) = statePtr.UInt64( 16 ) xor localVectorPtr.UInt64( 16 ) xor localVectorPtr.UInt64(  80 )
		    statePtr.UInt64( 24 ) = statePtr.UInt64( 24 ) xor localVectorPtr.UInt64( 24 ) xor localVectorPtr.UInt64(  88 )
		    statePtr.UInt64( 32 ) = statePtr.UInt64( 32 ) xor localVectorPtr.UInt64( 32 ) xor localVectorPtr.UInt64(  96 )
		    statePtr.UInt64( 40 ) = statePtr.UInt64( 40 ) xor localVectorPtr.UInt64( 40 ) xor localVectorPtr.UInt64( 104 )
		    statePtr.UInt64( 48 ) = statePtr.UInt64( 48 ) xor localVectorPtr.UInt64( 48 ) xor localVectorPtr.UInt64( 112 )
		    statePtr.UInt64( 56 ) = statePtr.UInt64( 56 ) xor localVectorPtr.UInt64( 56 ) xor localVectorPtr.UInt64( 120 )
		    
		    compressed = compressed + kChunkBytes
		    
		    //
		    // Advance dataPtr
		    //
		    dataPtr = ptr( integer( dataPtr ) + kChunkBytes )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process(data As String)
		  mValue = ""
		  
		  if Buffer <> "" then
		    data = Buffer + data
		    Buffer = ""
		  end if
		  
		  if data = "" then
		    return
		  end if
		  
		  var dataLen as integer = data.Bytes
		  var remainder as integer = dataLen mod kChunkBytes
		  
		  if remainder = 0 then
		    //
		    // We have to save the last block for the final
		    //
		    remainder = kChunkBytes
		  end if
		  
		  Buffer = data.RightBytes( remainder )
		  dataLen = dataLen - remainder
		  data = data.LeftBytes( dataLen )
		  
		  if data <> "" then
		    const kNoMask as UInt64 = 0
		    
		    Process data, CombinedLength + kChunkBytes, State, kNoMask
		    CombinedLength = CombinedLength + dataLen
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  if Key is nil then
		    Buffer = ""
		  else
		    Buffer = Key
		  end if
		  
		  //
		  // We make State twice as large as we need so
		  // the Process method can just copy the whole
		  // thing to the LocalVector in one shot.
		  //
		  State = new MemoryBlock( kChunkBytes )
		  State.CopyBytes( IV, 0, kMaxLength )
		  State.CopyBytes( IV, 0, kMaxLength, kMaxLength )
		  
		  var mixValue as UInt64 = &h01010000
		  mixValue = mixValue + HashLength
		  if Key isa object then
		    var shifted as UInt64 = KeyLength * CType( 256^1, UInt64 )
		    mixValue = mixValue xor shifted 
		  end if
		  
		  State.UInt64Value( 0 ) = State.UInt64Value( 0 ) xor mixValue
		  
		  LocalVector = new MemoryBlock( kChunkBytes )
		  
		  CombinedLength = 0
		  mValue = ""
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Buffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CombinedLength As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private HashLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared IV As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Key As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LocalVector As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mValue As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Sigma As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private State As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mValue = "" then
			    var tempState as new MemoryBlock( State.Size )
			    tempState.CopyBytes State, 0, State.Size
			    
			    var data as new MemoryBlock( kChunkBytes )
			    var dataLen as UInt64
			    
			    if Buffer <> "" then
			      dataLen = Buffer.Bytes
			      data.StringValue( 0, dataLen ) = Buffer
			    end if
			    
			    const kFinalMask as UInt64 = &hFFFFFFFFFFFFFFFF
			    
			    Process data, dataLen + CombinedLength, tempState, kFinalMask
			    
			    mValue = tempState.StringValue( 0, HashLength )
			  end if
			  
			  return mValue
			  
			End Get
		#tag EndGetter
		Value As String
	#tag EndComputedProperty


	#tag Constant, Name = kChunkBytes, Type = Double, Dynamic = False, Default = \"128", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMaxLength, Type = Double, Dynamic = False, Default = \"64", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.8", Scope = Public
	#tag EndConstant


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
