#tag Class
Protected Class Blake2bDigest_MTC
	#tag Method, Flags = &h21
		Private Sub Compress(statePtr As Ptr, dataPtr As Ptr, compressed As UInt64, isFinal As Boolean)
		  const kHalfway as integer = kChunkBytes \ 2
		  
		  var localVector as new MemoryBlock( kChunkBytes )
		  localVector.CopyBytes statePtr, 0, kHalfway
		  localVector.CopyBytes IV, 0, IV.Size, kHalfway
		  
		  var localVectorPtr as ptr = localVector
		  
		  localVectorPtr.UInt64( 12 ) = localVectorPtr.UInt64( 12 ) xor compressed
		  localVectorPtr.UInt64( 13 ) = localVectorPtr.UInt64( 13 ) xor 0 // Supposed to be the high bits, but we don't have them
		  
		  if isFinal then
		    localVectorPtr.UInt64( 14 ) = localVectorPtr.UInt64( 14 ) xor &hFFFFFFFFFFFFFFFF
		  end if
		  
		  for round as integer = 0 to Sigma.LastIndex
		    var sigmaPtr as ptr = Sigma( round )
		    
		    Mix localVectorPtr.UInt64( 0 ), localVectorPtr.UInt64( 4 ), localVectorPtr.UInt64( 8 ), localVectorPtr.UInt64( 12 ), dataPtr.UInt64( sigmaPtr.Byte( 0 ) ), dataPtr.UInt64( sigmaPtr.Byte( 1 ) )
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(key As String = "", hashLength As Integer = kMaxLength)
		  if IV is nil then
		    InitIV
		    InitSigma
		  end if
		  
		  if hashLength < 1 or hashLength > kMaxLength  then
		    raise new OutOfBoundsException
		  end if
		  
		  self.HashLength = hashLength
		  
		  if key <> "" then
		    self.Key = key
		    self.Key.Size = 128
		  end if
		  
		  Reset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function FromBytes(ParamArray bytes() As Byte) As MemoryBlock
		  var mb as new MemoryBlock( bytes.Count )
		  var p as Ptr = mb
		  
		  for i as integer = 0 to bytes.LastIndex
		    p.Byte( i ) = bytes( i )
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
		  
		  var newMb as MemoryBlock
		  
		  newMb = FromBytes( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5 )
		  Sigma.Add newMB
		  
		  newMb = FromBytes( 10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0 )
		  Sigma.Add newMB
		  
		  //
		  // Last two rounds are the same as the first two
		  //
		  Sigma.Add Sigma( 0 )
		  Sigma.Add Sigma( 1 )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(mbIn As MemoryBlock, statePtr As Ptr, isFinal As Boolean)
		  //
		  // mbIn will be kChunkSize exactly
		  //
		  
		  var combinedLength as integer = self.CombinedLength
		  
		  var dataPtr as Ptr = MbIn
		  
		  for byteIndex as integer = 0 to mbIn.Size step kChunkBytes
		    combinedLength = combinedLength + kChunkBytes
		    Compress statePtr, Ptr( integer( dataPtr ) + byteIndex ), combinedLength, isFinal
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
		  
		  if remainder <> 0 then
		    Buffer = data.RightBytes( remainder )
		    dataLen = dataLen - remainder
		    data = data.LeftBytes( dataLen )
		  end if
		  
		  if data <> "" then
		    Process data, State, false
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
		    mixValue = mixValue or ( Key.Size * CType( 256^2, UInt64 ) )
		  end if
		   
		  State.UInt64Value( 0 ) = State.UInt64Value( 0 ) xor mixValue
		  
		  CombinedLength = 0
		  
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
		Private Shared Sigma() As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private State As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var returnMB as MemoryBlock = State
			  
			  var tempState as new MemoryBlock( State.Size )
			  tempState.CopyBytes State, 0, State.Size
			  
			  var data as MemoryBlock = Buffer
			  data.Size = kChunkBytes // Even if Buffer is empty, process zeros
			  
			  Process data, tempState, true
			  returnMB = tempState
			  
			  return returnMB
			  
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
	#tag EndViewBehavior
End Class
#tag EndClass
