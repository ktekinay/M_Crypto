#tag Class
Protected Class SHA512Digest_MTC
	#tag Method, Flags = &h21
		Private Function ArrayUInt64(ParamArray arr() As UInt64) As UInt64()
		  return arr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Reset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process(data As String)
		  data = Buffer + data
		  Buffer = ""
		  
		  dim remainder as integer = data.LenB mod kChunkBytes
		  if remainder <> 0 then
		    Buffer = data.RightB( remainder )
		    data = data.LeftB( data.LenB - buffer.LenB )
		  end if
		  
		  if data <> "" then
		    Process data, Registers, false
		    CombinedLength = CombinedLength + data.LenB
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Process(data As String, useRegisters As MemoryBlock, isFinal As Boolean)
		  const k2 as UInt64 = 2
		  const k6 as UInt64 = 6
		  const k7 as UInt64 = 7
		  
		  //
		  // Table of constants
		  //
		  static k() as UInt64 = ArrayUInt64( _
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
		  
		  dim dataLen as integer = data.LenB
		  dim mbIn as MemoryBlock
		  
		  if isFinal then
		    
		    // Add one char to the length
		    dim padding as integer = kChunkBytes - ( ( dataLen + 1 ) mod kChunkBytes )
		    
		    // Check if we have enough room for inserting the length
		    if padding < 16 then 
		      padding = padding + kChunkBytes
		    end if
		    
		    mbIn = new MemoryBlock( dataLen + padding + 1 )
		    mbIn.LittleEndian = false
		    
		    //
		    // Set the first bit after the data to 1
		    //
		    mbIn.Byte( dataLen ) = &b10000000
		    
		    //
		    // Copy length of data to the last 8 bytes since we can't really do 16, as the spec requires
		    //
		    mbIn.UInt64Value( mbIn.Size - 8 ) = ( CombinedLength + dataLen ) * 8 // In bits
		    
		    if dataLen <> 0 then
		      mbIn.StringValue( 0, dataLen ) = data
		    end if
		    
		  else // Not isFinal so the data will already be a multiple of 64
		    
		    mbIn = data
		    mbIn.LittleEndian = false
		    
		  end if
		  
		  dim h0 as UInt64 = useRegisters.UInt64Value( 0 )
		  dim h1 as UInt64 = useRegisters.UInt64Value( 8 )
		  dim h2 as UInt64 = useRegisters.UInt64Value( 16 )
		  dim h3 as UInt64 = useRegisters.UInt64Value( 24 )
		  dim h4 as UInt64 = useRegisters.UInt64Value( 32 )
		  dim h5 as UInt64 = useRegisters.UInt64Value( 40 )
		  dim h6 as UInt64 = useRegisters.UInt64Value( 48 )
		  dim h7 as UInt64 = useRegisters.UInt64Value( 56 )
		  
		  dim a, b, c, d, e, f, g, h as UInt64
		  
		  dim lastByteIndex as integer = mbIn.Size - 1
		  for chunkIndex as integer = 0 to lastByteIndex step kChunkBytes // Split into blocks
		    dim w as new MemoryBlock( ( k.Ubound + 1 ) * 8 )
		    w.LittleEndian = false
		    
		    w.StringValue( 0, kChunkBytes ) = mbIn.StringValue( chunkIndex, kChunkBytes )
		    
		    dim lastMessageByteIndex as integer = w.Size - 1
		    for wordIndex as integer = kChunkBytes to lastMessageByteIndex step 8
		      dim word0 as UInt64 = w.UInt64Value( wordIndex - 128 )
		      dim word1 as UInt64 = w.UInt64Value( wordIndex - 120 )
		      dim word9 as UInt64 = w.UInt64Value( wordIndex - 56 )
		      dim word14 as UInt64 = w.UInt64Value( wordIndex - 16 )
		      
		      dim s0 as UInt64 = ( RotateRight( word1, 1 ) xor RotateRight( word1, 8 ) ) xor ( word1 \ CType( k2 ^ k7, UInt64 ) )
		      dim s1 as UInt64 = ( RotateRight( word14, 19 ) xor RotateRight( word14, 61 ) ) xor ( word14 \ CType( k2 ^ k6, UInt64 ) )
		      
		      w.UInt64Value( wordIndex ) = word0 + s0 + word9 + s1
		    next
		    
		    a = h0 
		    b = h1 
		    c = h2 
		    d = h3
		    e = h4
		    f = h5
		    g = h6
		    h = h7
		    
		    for i as integer = 0 to k.Ubound
		      dim s1 as UInt64 = RotateRight( e, 14 ) xor RotateRight( e, 18 ) xor RotateRight( e, 41 )
		      dim ch as UInt64 = ( e and f ) xor ( ( not e ) and g )
		      dim temp1 as UInt64 = h + s1 + ch + k( i ) + w.UInt64Value( i * 8 )
		      
		      dim s0 as UInt64 = RotateRight( a, 28 ) xor RotateRight( a, 34 ) xor RotateRight( a, 39 )
		      dim maj as UInt64 = ( a and b ) xor ( a and c ) xor ( b and c )
		      dim temp2 as UInt64 = s0 + maj
		      
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
		  
		  useRegisters.UInt64Value( 0 ) = h0
		  useRegisters.UInt64Value( 8 ) = h1
		  useRegisters.UInt64Value( 16 ) = h2
		  useRegisters.UInt64Value( 24 ) = h3
		  useRegisters.UInt64Value( 32 ) = h4
		  useRegisters.UInt64Value( 40 ) = h5
		  useRegisters.UInt64Value( 48 ) = h6
		  useRegisters.UInt64Value( 56 ) = h7
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  if Registers is nil then
		    Registers = new MemoryBlock( 64 )
		    Registers.LittleEndian = false
		  end if
		  
		  Registers.UInt64Value( 0 ) = &h6a09e667f3bcc908
		  Registers.UInt64Value( 8 ) = &hbb67ae8584caa73b
		  Registers.UInt64Value( 16 ) = &h3c6ef372fe94f82b
		  Registers.UInt64Value( 24 ) = &ha54ff53a5f1d36f1
		  Registers.UInt64Value( 32 ) = &h510e527fade682d1
		  Registers.UInt64Value( 40 ) = &h9b05688c2b3e6c1f
		  Registers.UInt64Value( 48 ) = &h1f83d9abfb41bd6b
		  Registers.UInt64Value( 56 ) = &h5be0cd19137e2179
		  
		  CombinedLength = 0
		  Buffer = ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RotateRight(x As UInt64, places As UInt64) As UInt64
		  const k2 as UInt64 = 2
		  const k64 as UInt64 = 64
		  
		  dim diff as UInt64 = k64 - places
		  dim leftMost as UInt64 = x * CType( k2 ^ diff, UInt64 )
		  dim rightMost as UInt64 = x \ CType( k2 ^ places, UInt64 )
		  
		  dim result as UInt64 = leftMost or rightMost
		  
		  #if DebugBuild and FALSE then
		    const kZeros as string = "0000000000000000000000000000000000000000000000000000000000000000"
		    System.DebugLog "Places: " + str( places )
		    System.DebugLog "Orig: " + Right( kZeros + bin( x ), 64 )
		    System.DebugLog "Left: " + Right( kZeros + bin( leftMost ), 64 )
		    System.DebugLog "Rigt: " + Right( kZeros + bin( rightMost ), 64 )
		    System.DebugLog "Resl: " + Right( kZeros + bin( result ), 64 )
		    System.DebugLog "----"
		  #endif
		  
		  return result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Buffer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private CombinedLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Registers As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim r as string = Registers // To string
			  dim tempRegister as MemoryBlock = r // From string
			  tempRegister.LittleEndian = false
			  Process Buffer, tempRegister, true
			  
			  return tempRegister
			End Get
		#tag EndGetter
		Value As String
	#tag EndComputedProperty


	#tag Constant, Name = kChunkBytes, Type = Double, Dynamic = False, Default = \"128", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
