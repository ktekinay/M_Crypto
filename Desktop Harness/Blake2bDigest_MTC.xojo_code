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
		  
		  Sigma.Add FromBytes(  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15 )
		  Sigma.Add FromBytes( 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 )
		  Sigma.Add FromBytes( 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4 )
		  Sigma.Add FromBytes(  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8 )
		  Sigma.Add FromBytes(  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13 )
		  Sigma.Add FromBytes(  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9 )
		  Sigma.Add FromBytes( 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11 )
		  Sigma.Add FromBytes( 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10 )
		  Sigma.Add FromBytes(  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5 )
		  Sigma.Add FromBytes( 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13,  0 )
		  
		  //
		  // Below is the Go implementation
		  //
		  'Sigma.Add FromBytes(  0,  2,  4,  6,  1,  3,  5,  7,  8, 10, 12, 14,  9, 11, 13, 15 )
		  'Sigma.Add FromBytes( 14,  4,  9, 13, 10,  8, 15,  6,  1,  0, 11,  5, 12,  2,  7,  3 )
		  'Sigma.Add FromBytes( 11, 12,  5, 15,  8,  0,  2, 13, 10,  3,  7,  9, 14,  6,  1,  4 )
		  'Sigma.Add FromBytes(  7,  3, 13, 11,  9,  1, 12, 14,  2,  5,  4, 15,  6, 10,  0,  8 )
		  'Sigma.Add FromBytes(  9,  5,  2, 10,  0,  7,  4, 15, 14, 11,  6,  3,  1, 12,  8, 13 )
		  'Sigma.Add FromBytes(  2,  6,  0,  8, 12, 10, 11,  3,  4,  7, 15,  1, 13,  5, 14,  9 )
		  'Sigma.Add FromBytes( 12,  1, 14,  4,  5, 15, 13, 10,  0,  6,  9,  8,  7,  3,  2, 11 )
		  'Sigma.Add FromBytes( 13,  7, 12,  3, 11, 14,  1,  9,  5, 15,  8,  2,  0,  4,  6, 10 )
		  'Sigma.Add FromBytes(  6, 14, 11,  0, 15,  9,  3,  8, 12, 13,  1, 10,  2,  7,  4,  5 )
		  'Sigma.Add FromBytes( 10,  8,  7,  1,  2,  4,  6,  5, 15,  9,  3, 13, 11, 14, 12,  0 )
		  
		  //
		  // Last two rounds are the same as the first two
		  //
		  Sigma.Add Sigma( 0 )
		  Sigma.Add Sigma( 1 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Mix(localVectorPtr As Ptr, i1 As Integer, i2 As Integer, i3 As Integer, i4 As Integer, x As UInt64, y As UInt64)
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
		  
		  var a as integer = i1 * 8
		  var b as integer = i2 * 8
		  var c as integer = i3 * 8
		  var d as integer = i4 * 8
		  
		  var p as Ptr = localVectorPtr
		  
		  p.UInt64( a ) = p.UInt64( a ) + p.UInt64( b ) + x
		  p.UInt64( d ) = p.UInt64( d ) xor p.UInt64( a )
		  p.UInt64( d ) = ( p.UInt64( d ) \ R1ShiftRight ) xor ( p.UInt64( d ) * R1ShiftLeft )
		  
		  p.UInt64( c ) = p.UInt64( c ) + p.UInt64( d )
		  p.UInt64( b ) = p.UInt64( b ) xor p.UInt64( c )
		  p.UInt64( b ) = ( p.UInt64( b ) \ R2ShiftRight ) xor ( p.UInt64( b ) * R2ShiftLeft )
		  
		  p.UInt64( a ) = p.UInt64( a ) + p.UInt64( b ) + y
		  p.UInt64( d ) = p.UInt64( d ) xor p.UInt64( a )
		  p.UInt64( d ) = ( p.UInt64( d ) \ R3ShiftRight ) xor ( p.UInt64( d ) * R3ShiftLeft )
		  
		  p.UInt64( c ) = p.UInt64( c ) + p.UInt64( d )
		  p.UInt64( b ) = p.UInt64( b ) xor p.UInt64( c )
		  p.UInt64( b ) = ( p.UInt64( b ) \ R4ShiftRight ) xor ( p.UInt64( b ) * R4ShiftLeft )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(data As MemoryBlock, compressed As UInt64, state As MemoryBlock, isFinal As Boolean)
		  //
		  // data will be a multiple of kChunkSize exactly
		  //
		  
		  var localVector as MemoryBlock = self.LocalVector
		  
		  for dataByteIndex as integer = 0 to data.Size - 1 step kChunkBytes
		    //
		    // Compress state, mbIn, byteIndex, combinedLength, isFinal
		    //
		    localVector.CopyBytes state, 0, State.Size
		    localVector.CopyBytes IV, 0, IV.Size, IV.Size
		    
		    'var localVectorPtr as ptr = localVector
		    
		    localVector.UInt64Value( 12 * 8 ) = localVector.UInt64Value( 12 * 8 ) xor compressed
		    'localVectorPtr.UInt64( 13 * 8 ) = localVectorPtr.UInt64( 13 * 8 ) xor 0 // Supposed to be the high bits, but we don't have them
		    
		    if isFinal then
		      localVector.UInt64Value( 14 * 8 ) = localVector.UInt64Value( 14 * 8 ) xor &hFFFFFFFFFFFFFFFF
		    end if
		    
		    for round as integer = 0 to Sigma.LastIndex
		      var thisSigma as Ptr = Sigma( round )
		      
		      Mix localVector, 0, 4, 8, 12, data.UInt64Value( thisSigma.Byte( 0 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 1 ) + dataByteIndex )
		      Mix localVector, 1, 5, 9, 13, data.UInt64Value( thisSigma.Byte( 2 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 3 ) + dataByteIndex )
		      Mix localVector, 2, 6, 10, 14, data.UInt64Value( thisSigma.Byte( 4 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 5 ) + dataByteIndex )
		      Mix localVector, 3, 7, 11, 15, data.UInt64Value( thisSigma.Byte( 6 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 7 ) + dataByteIndex )
		      Mix localVector, 0, 5, 10, 15, data.UInt64Value( thisSigma.Byte( 8 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 9 ) + dataByteIndex )
		      Mix localVector, 1, 6, 11, 12, data.UInt64Value( thisSigma.Byte( 10 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 11 ) + dataByteIndex )
		      Mix localVector, 2, 7, 8, 13, data.UInt64Value( thisSigma.Byte( 12 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 13 ) + dataByteIndex )
		      Mix localVector, 3, 4, 9, 14, data.UInt64Value( thisSigma.Byte( 14 ) + dataByteIndex ), data.UInt64Value( thisSigma.Byte( 15 ) + dataByteIndex )
		    next
		    
		    for byteIndex as integer = 0 to state.Size - 1 step 8
		      var upperByteIndex as integer = byteIndex + state.Size
		      state.UInt64Value( byteIndex ) = state.UInt64Value( byteIndex ) _
		      xor localVector.UInt64Value( byteIndex ) _
		      xor localVector.UInt64Value( upperByteIndex )
		    next
		    
		    compressed = compressed + kChunkBytes
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process(data As String)
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
		    Process data, CombinedLength + kChunkBytes, State, false
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
		  
		  State = new MemoryBlock( IV.Size )
		  State.CopyBytes( IV, 0, IV.Size )
		  
		  var mixValue as UInt64 = &h01010000
		  mixValue = mixValue + HashLength
		  if Key isa object then
		    var shifted as UInt64 = KeyLength * CType( 256^1, UInt64 )
		    mixValue = mixValue xor shifted 
		  end if
		  
		  State.UInt64Value( 0 ) = State.UInt64Value( 0 ) xor mixValue
		  
		  LocalVector = new MemoryBlock( kChunkBytes )
		  
		  CombinedLength = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RotateRight(value As UInt64, bits As Integer) As UInt64
		  return _
		  ( value \ CType( 2 ^ bits, UInt64 ) ) + _
		  ( value * CType( 2 ^ ( 64 - bits ), UInt64 ) )
		  
		End Function
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
		Private Shared Sigma() As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private State As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var tempState as new MemoryBlock( State.Size )
			  tempState.CopyBytes State, 0, State.Size
			  
			  var data as new MemoryBlock( kChunkBytes )
			  var dataLen as UInt64
			  
			  if Buffer <> "" then
			    dataLen = Buffer.Bytes
			    data.StringValue( 0, dataLen ) = Buffer
			  end if
			  
			  Process data, dataLen + CombinedLength, tempState, true
			  
			  return tempState.StringValue( 0, HashLength )
			  
			  
			  
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
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
