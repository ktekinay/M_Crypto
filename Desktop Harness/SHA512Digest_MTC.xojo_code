#tag Class
Protected Class SHA512Digest_MTC
	#tag Method, Flags = &h21
		Private Function ArrayUInt64(ParamArray arr() As UInt64) As UInt64()
		  return arr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  //
		  // Table of constants
		  //
		  
		  if kMagic is nil then
		    dim arr() as UInt64 = ArrayUInt64( _
		    &h428a2f98d728ae22, &h7137449123ef65cd, &hb5c0fbcfec4d3b2f, &he9b5dba58189dbbc, &h3956c25bf348b538, _
		    &h59f111f1b605d019, &h923f82a4af194f9b, &hab1c5ed5da6d8118, &hd807aa98a3030242, &h12835b0145706fbe, _
		    &h243185be4ee4b28c, &h550c7dc3d5ffb4e2, &h72be5d74f27b896f, &h80deb1fe3b1696b1, &h9bdc06a725c71235, _
		    &hc19bf174cf692694, &he49b69c19ef14ad2, &hefbe4786384f25e3, &h0fc19dc68b8cd5b5, &h240ca1cc77ac9c65, _
		    &h2de92c6f592b0275, &h4a7484aa6ea6e483, &h5cb0a9dcbd41fbd4, &h76f988da831153b5, &h983e5152ee66dfab, _
		    &ha831c66d2db43210, &hb00327c898fb213f, &hbf597fc7beef0ee4, &hc6e00bf33da88fc2, &hd5a79147930aa725, _
		    &h06ca6351e003826f, &h142929670a0e6e70, &h27b70a8546d22ffc, &h2e1b21385c26c926, &h4d2c6dfc5ac42aed, _
		    &h53380d139d95b3df, &h650a73548baf63de, &h766a0abb3c77b2a8, &h81c2c92e47edaee6, &h92722c851482353b, _
		    &ha2bfe8a14cf10364, &ha81a664bbc423001, &hc24b8b70d0f89791, &hc76c51a30654be30, &hd192e819d6ef5218, _
		    &hd69906245565a910, &hf40e35855771202a, &h106aa07032bbd1b8, &h19a4c116b8d2d0c8, &h1e376c085141ab53, _
		    &h2748774cdf8eeb99, &h34b0bcb5e19b48a8, &h391c0cb3c5c95a63, &h4ed8aa4ae3418acb, &h5b9cca4f7763e373, _
		    &h682e6ff3d6b2b8a3, &h748f82ee5defb2fc, &h78a5636f43172f60, &h84c87814a1f0ab72, &h8cc702081a6439ec, _
		    &h90befffa23631e28, &ha4506cebde82bde9, &hbef9a3f7b2c67915, &hc67178f2e372532b, &hca273eceea26619c, _
		    &hd186b8c721c0c207, &heada7dd6cde0eb1e, &hf57d4f7fee6ed178, &h06f067aa72176fba, &h0a637dc5a2c898a6, _
		    &h113f9804bef90dae, &h1b710b35131c471b, &h28db77f523047d84, &h32caab7b40c72493, &h3c9ebe0a15c9bebc, _
		    &h431d67c49c100d4c, &h4cc5d4becb3e42b6, &h597f299cfc657e2a, &h5fcb6fab3ad6faec, &h6c44198c4a475817 _
		    )
		    
		    kMagic = new MemoryBlock( ( arr.Ubound + 1 ) * 8 )
		    kMagicPtr = kMagic
		    
		    for i as integer = 0 to arr.Ubound
		      kMagicPtr.UInt64( i * 8 ) = arr( i )
		    next
		    
		    IsLittleEndian = kMagic.LittleEndian
		  end if
		  
		  Message = new MemoryBlock( kMagic.Size )
		  
		  Reset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(mbIn As MemoryBlock, ByRef useRegisters As RegisterStruct, isFinal As Boolean)
		  #if not DebugBuild then
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  const k1 as UInt64 = 2 ^ 1
		  const k3 as UInt64 = 2 ^ 3
		  const k6 as UInt64 = 2 ^ 6
		  const k7 as UInt64 = 2 ^ 7
		  const k8 as UInt64 = 2 ^ 8
		  const k14 as UInt64 = 2 ^ 14
		  const k18 as UInt64 = 2 ^ 18
		  const k19 as UInt64 = 2 ^ 19
		  const k23 as UInt64 = 2 ^ 23
		  const k24 as UInt64 = 2 ^ 24
		  const k25 as UInt64 = 2 ^ 25
		  const k28 as UInt64 = 2 ^ 28
		  const k30 as UInt64 = 2 ^ 30
		  const k34 as UInt64 = 2 ^ 34
		  const k36 as UInt64 = 2 ^ 36
		  const k39 as UInt64 = 2 ^ 39
		  const k40 as UInt64 = 2 ^ 40
		  const k41 as UInt64 = 2 ^ 41
		  const k45 as UInt64 = 2 ^ 45
		  const k46 as UInt64 = 2 ^ 46
		  const k50 as UInt64 = 2 ^ 50
		  const k56 as UInt64 = 2 ^ 56
		  const k61 as UInt64 = 2 ^ 61
		  const k63 as UInt64 = &h8000000000000000 // 2 ^ 63 won't work here
		  
		  //
		  // Make local for easier debugging
		  //
		  dim message as MemoryBlock = self.Message
		  dim kMagicPtr as ptr = self.kMagicPtr
		  
		  dim pMessage as ptr = message
		  
		  dim dataLen as integer = mbIn.Size
		  
		  if isFinal then
		    
		    //
		    // Add one char to the length
		    //
		    dim padding as integer = kChunkBytes - ( ( dataLen + 1 ) mod kChunkBytes )
		    
		    //
		    // Check if we have enough room for inserting the length
		    //
		    if padding < 16 then 
		      padding = padding + kChunkBytes
		    end if
		    
		    mbIn.Size = dataLen + padding + 1
		    mbIn.LittleEndian = false
		    
		    //
		    // Set the first bit after the data to 1
		    //
		    mbIn.Byte( dataLen ) = &b10000000
		    
		    //
		    // Copy length of data to the last 8 bytes since we can't really do 16, as the spec requires
		    //
		    mbIn.UInt64Value( mbIn.Size - 8 ) = ( CombinedLength + dataLen ) * 8 // In bits
		    
		  end if
		  
		  dim pIn as ptr = mbIn
		  
		  dim h0 as UInt64 = useRegisters.H0
		  dim h1 as UInt64 = useRegisters.H1
		  dim h2 as UInt64 = useRegisters.H2
		  dim h3 as UInt64 = useRegisters.H3
		  dim h4 as UInt64 = useRegisters.H4
		  dim h5 as UInt64 = useRegisters.H5
		  dim h6 as UInt64 = useRegisters.H6
		  dim h7 as UInt64 = useRegisters.H7
		  
		  dim a, b, c, d, e, f, g, h as UInt64
		  dim word0, word1, word9, word14 as UInt64
		  dim temp1, temp2, maj, ch as UInt64
		  dim s0, s1 as UInt64
		  dim newValue as UInt64
		  
		  dim lastByteIndex as integer = mbIn.Size - 1
		  
		  //
		  // If the natural state is LittleEndian, we have
		  // to flip the bytes around in the data so
		  // we can use Ptr below.
		  // 
		  // Unbelievably, this is faster than using the
		  // MemoryBlock functions to access the data.
		  //
		  if IsLittleEndian then
		    const kMask1 as UInt64 = &h00FF000000000000
		    const kMask2 as UInt64 = &h0000FF0000000000
		    const kMask3 as UInt64 = &h000000FF00000000
		    const kMask4 as UInt64 = &h00000000FF000000
		    const kMask5 as UInt64 = &h0000000000FF0000
		    const kMask6 as UInt64 = &h000000000000FF00
		    
		    for i as integer = 0 to lastByteIndex step 8
		      temp1 = pIn.UInt64( i )
		      pIn.UInt64( i ) = _
		      ( temp1 \ k56 ) or _
		      ( ( temp1 and kMask1 ) \ k40 ) or _
		      ( ( temp1 and kMask2 ) \ k24 ) or _
		      ( ( temp1 and kMask3 ) \ k8 ) or _
		      ( ( temp1 and kMask4 ) * k8 ) or _
		      ( ( temp1 and kMask5 ) * k24 ) or _
		      ( ( temp1 and kMask6 ) * k40 ) or _
		      ( temp1 * k56 )
		    next
		  end if
		  
		  for chunkIndex as integer = 0 to lastByteIndex step kChunkBytes // Split into blocks
		    //
		    // Copy the chunk to the Message (faster than StringValue)
		    //
		    dim copyIndex as integer = 0
		    while copyIndex < kChunkBytes
		      pMessage.UInt64( copyIndex ) = pIn.UInt64( chunkIndex + copyIndex )
		      copyIndex = copyIndex + 8
		    wend
		    
		    for wordIndex as integer = kChunkBytes to kLastMessageByteIndex step 8
		      word0 = pMessage.UInt64( wordIndex - 128 )
		      word1 = pMessage.UInt64( wordIndex - 120 )
		      word9 = pMessage.UInt64( wordIndex - 56 )
		      word14 = pMessage.UInt64( wordIndex - 16 )
		      
		      'dim s0 as UInt64 = ( RotateRight( word1, 1 ) xor RotateRight( word1, 8 ) ) xor ( word1 \ k7 )
		      s0 = _
		      ( ( ( word1 \ k1 ) or ( word1 * k63 ) ) xor _
		      ( ( word1 \ k8 ) or ( word1 * k56 ) ) ) _
		      xor ( word1 \ k7 )
		      
		      'dim s1 as UInt64 = ( RotateRight( word14, 19 ) xor RotateRight( word14, 61 ) ) xor ( word14 \ k6 )
		      s1 = _
		      ( ( ( word14 \ k19 ) or ( word14 * k45 ) ) xor _
		      ( ( word14 \ k61 ) or ( word14 * k3 ) ) ) _
		      xor ( word14 \ k6 )
		      
		      newValue = word0 + s0 + word9 + s1
		      pMessage.UInt64( wordIndex ) = word0 + s0 + word9 + s1
		    next
		    
		    a = h0 
		    b = h1 
		    c = h2 
		    d = h3
		    e = h4
		    f = h5
		    g = h6
		    h = h7
		    
		    for i as integer = 0 to kLastRoundIndex
		      'dim s1 as UInt64 = RotateRight( e, 14 ) xor RotateRight( e, 18 ) xor RotateRight( e, 41 )
		      s1 = _
		      ( ( e \ k14 ) or ( e * k50 ) ) xor _
		      ( ( e \ k18 ) or ( e * k46 ) ) xor _
		      ( ( e \ k41 ) or ( e * k23 ) )
		      ch = ( e and f ) xor ( ( not e ) and g )
		      temp1 = h + s1 + ch + kMagicPtr.UInt64( i * 8 ) + pMessage.UInt64( i * 8 )
		      
		      'dim s0 as UInt64 = RotateRight( a, 28 ) xor RotateRight( a, 34 ) xor RotateRight( a, 39 )
		      s0 = _
		      ( ( a \ k28 ) or ( a * k36 ) ) xor _
		      ( ( a \ k34 ) or ( a * k30 ) ) xor _
		      ( ( a \ k39 ) or ( a * k25 ) )
		      
		      maj = ( a and b ) xor ( a and c ) xor ( b and c )
		      temp2 = s0 + maj
		      
		      h = g
		      g = f
		      f = e
		      e = d + temp1
		      d = c
		      c = b
		      b = a
		      a = temp1 + temp2
		    next
		    
		    h0 = h0 + a
		    h1 = h1 + b
		    h2 = h2 + c
		    h3 = h3 + d
		    h4 = h4 + e
		    h5 = h5 + f
		    h6 = h6 + g
		    h7 = h7 + h
		    
		  next chunkIndex
		  
		  useRegisters.H0 = h0
		  useRegisters.H1 = h1
		  useRegisters.H2 = h2
		  useRegisters.H3 = h3
		  useRegisters.H4 = h4
		  useRegisters.H5 = h5
		  useRegisters.H6 = h6
		  useRegisters.H7 = h7
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process(data As String)
		  if Buffer <> "" then
		    data = Buffer + data
		    Buffer = ""
		  end if
		  
		  dim dataLen as integer = data.LenB
		  dim remainder as integer = dataLen mod kChunkBytes
		  if remainder <> 0 then
		    Buffer = data.RightB( remainder )
		    dataLen = dataLen - remainder
		    data = data.LeftB( dataLen )
		  end if
		  
		  if data <> "" then
		    Process data, Registers, false
		    CombinedLength = CombinedLength + dataLen
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  Registers.H0 = &h6a09e667f3bcc908
		  Registers.H1 = &hbb67ae8584caa73b
		  Registers.H2 = &h3c6ef372fe94f82b
		  Registers.H3 = &ha54ff53a5f1d36f1
		  Registers.H4 = &h510e527fade682d1
		  Registers.H5 = &h9b05688c2b3e6c1f
		  Registers.H6 = &h1f83d9abfb41bd6b
		  Registers.H7 = &h5be0cd19137e2179
		  
		  CombinedLength = 0
		  Buffer = ""
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Buffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CombinedLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared IsLittleEndian As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared kMagic As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared kMagicPtr As Ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Message As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Registers As RegisterStruct
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim tempRegisters as RegisterStruct = Registers
			  Process Buffer, tempRegisters, true
			  
			  return tempRegisters.StringValue( false )
			End Get
		#tag EndGetter
		Value As String
	#tag EndComputedProperty


	#tag Constant, Name = kChunkBytes, Type = Double, Dynamic = False, Default = \"128", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLastMessageByteIndex, Type = Double, Dynamic = False, Default = \"639", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLastRoundIndex, Type = Double, Dynamic = False, Default = \"79", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.7", Scope = Public
	#tag EndConstant


	#tag Structure, Name = RegisterStruct, Flags = &h0
		H0 As UInt64
		  H1 As UInt64
		  H2 As UInt64
		  H3 As UInt64
		  H4 As UInt64
		  H5 As UInt64
		  H6 As UInt64
		H7 As UInt64
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
