#tag Class
Protected Class SHA256Digest_MTC
	#tag Method, Flags = &h21
		Private Function ArrayUInt32(ParamArray arr() As UInt32) As UInt32()
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
		  const k2 as UInt32 = 2
		  const k3 as UInt32 = 3
		  const k6 as UInt32 = 6
		  const k7 as UInt32 = 7
		  const k10 as UInt32 = 10
		  const k11 as UInt32 = 11
		  const k13 as UInt32 = 13
		  const k14 as UInt32 = 14
		  const k15 as UInt32 = 15
		  const k17 as UInt32 = 17
		  const k18 as UInt32 = 18
		  const k19 as UInt32 = 19
		  const k21 as UInt32 = 21
		  const k22 as UInt32 = 22
		  const k25 as UInt32 = 25
		  const k26 as UInt32 = 26
		  const k30 as UInt32 = 30
		  
		  //
		  // Table of constants
		  //
		  static k as MemoryBlock
		  static kPtr as ptr
		  
		  if k is nil then
		    static arr() as UInt32 = ArrayUInt32( _
		    &h428a2f98, &h71374491, &hb5c0fbcf, &he9b5dba5, &h3956c25b, &h59f111f1, &h923f82a4, &hab1c5ed5, _
		    &hd807aa98, &h12835b01, &h243185be, &h550c7dc3, &h72be5d74, &h80deb1fe, &h9bdc06a7, &hc19bf174, _
		    &he49b69c1, &hefbe4786, &h0fc19dc6, &h240ca1cc, &h2de92c6f, &h4a7484aa, &h5cb0a9dc, &h76f988da, _
		    &h983e5152, &ha831c66d, &hb00327c8, &hbf597fc7, &hc6e00bf3, &hd5a79147, &h06ca6351, &h14292967, _
		    &h27b70a85, &h2e1b2138, &h4d2c6dfc, &h53380d13, &h650a7354, &h766a0abb, &h81c2c92e, &h92722c85, _
		    &ha2bfe8a1, &ha81a664b, &hc24b8b70, &hc76c51a3, &hd192e819, &hd6990624, &hf40e3585, &h106aa070, _
		    &h19a4c116, &h1e376c08, &h2748774c, &h34b0bcb5, &h391c0cb3, &h4ed8aa4a, &h5b9cca4f, &h682e6ff3, _
		    &h748f82ee, &h78a5636f, &h84c87814, &h8cc70208, &h90befffa, &ha4506ceb, &hbef9a3f7, &hc67178f2 _
		    )
		    
		    k = new MemoryBlock( ( arr.Ubound + 1 ) * 4 )
		    kPtr = k
		    
		    for i as integer = 0 to arr.Ubound
		      kPtr.UInt32( i * 4 ) = arr( i )
		    next
		  end if
		  
		  if Message is nil then
		    Message = new MemoryBlock( k.Size )
		    Message.LittleEndian = false
		  end if
		  
		  dim dataLen as integer = data.LenB
		  dim mbIn as MemoryBlock
		  
		  if isFinal then
		    
		    //
		    // Add one char to the length
		    //
		    dim padding as integer = kChunkBytes - ( ( dataLen + 1 ) mod kChunkBytes )
		    
		    //
		    // Check if we have enough room for inserting the length
		    //
		    if padding < 8 then 
		      padding = padding + kChunkBytes
		    end if
		    
		    mbIn = new MemoryBlock( dataLen + padding + 1 )
		    mbIn.LittleEndian = false
		    
		    //
		    // Set the first bit after the data to 1
		    //
		    mbIn.Byte( dataLen ) = &b10000000
		    
		    //
		    // Copy length of data to the last 8 bytes
		    //
		    mbIn.UInt64Value( mbIn.Size - 8 ) = ( CombinedLength + dataLen ) * 8 // In bits
		    
		    if dataLen <> 0 then
		      mbIn.StringValue( 0, dataLen ) = data
		    end if
		    
		  else // Not isFinal so the data will already be a multiple 
		    
		    mbIn = data
		    mbIn.LittleEndian = false
		    
		  end if
		  
		  dim h0 as UInt32 = useRegisters.UInt32Value( 0 )
		  dim h1 as UInt32 = useRegisters.UInt32Value( 4 )
		  dim h2 as UInt32 = useRegisters.UInt32Value( 8 )
		  dim h3 as UInt32 = useRegisters.UInt32Value( 12 )
		  dim h4 as UInt32 = useRegisters.UInt32Value( 16 )
		  dim h5 as UInt32 = useRegisters.UInt32Value( 20 )
		  dim h6 as UInt32 = useRegisters.UInt32Value( 24 )
		  dim h7 as UInt32 = useRegisters.UInt32Value( 28 )
		  
		  dim a, b, c, d, e, f, g, h as UInt32
		  
		  dim lastByteIndex as integer = mbIn.Size - 1
		  for chunkIndex as integer = 0 to lastByteIndex step kChunkBytes // Split into blocks
		    dim w as MemoryBlock = Message // Convenience
		    
		    w.StringValue( 0, kChunkBytes ) = mbIn.StringValue( chunkIndex, kChunkBytes )
		    
		    dim lastMessageByteIndex as integer = w.Size - 1
		    for wordIndex as integer = kChunkBytes to lastMessageByteIndex step 4
		      dim word0 as UInt32 = w.UInt32Value( wordIndex - 64 )
		      dim word1 as UInt32 = w.UInt32Value( wordIndex - 60 )
		      dim word9 as UInt32 = w.UInt32Value( wordIndex - 28 )
		      dim word14 as UInt32 = w.UInt32Value( wordIndex - 8 )
		      
		      'dim s0 as UInt32 = ( RotateRight( word1, 7 ) xor RotateRight( word1, 18 ) ) xor ( word1 \ CType( k2 ^ k3, UInt32 ) )
		      dim s0 as UInt32 = _
		      ( ( ( word1 \ CType( k2 ^ k7, UInt32 ) ) or ( word1 * CType( k2 ^ k25, UInt32 ) ) ) xor _
		      ( ( word1 \ CType( k2 ^ k18, UInt32 ) ) or ( word1 * CType( k2 ^ k14, UInt32 ) ) ) ) _
		      xor ( word1 \ CType( k2 ^ k3, UInt32 ) )
		      
		      'dim s1 as UInt32 = ( RotateRight( word14, 17 ) xor RotateRight( word14, 19 ) ) xor ( word14 \ CType( k2 ^ k10, UInt32 ) )
		      dim s1 as UInt32 = _
		      ( ( ( word14 \ CType( k2 ^ k17, UInt32 ) ) or ( word14 * CType( k2 ^ k15, UInt32 ) ) ) xor _
		      ( ( word14 \ CType( k2 ^ k19, UInt32 ) ) or ( word14 * CType( k2 ^ k13, UInt32 ) ) ) ) _
		      xor ( word14 \ CType( k2 ^ k10, UInt32 ) )
		      
		      w.UInt32Value( wordIndex ) = word0 + s0 + word9 + s1
		    next
		    
		    a = h0 
		    b = h1 
		    c = h2 
		    d = h3
		    e = h4
		    f = h5
		    g = h6
		    h = h7
		    
		    dim lastRoundIndex as integer = ( k.Size \ 4 ) - 1
		    for i as integer = 0 to lastRoundIndex
		      'dim s1 as UInt32 = RotateRight( e, 6 ) xor RotateRight( e, 11 ) xor RotateRight( e, 25 )
		      dim s1 as UInt32 = _
		      ( ( e \ CType( k2 ^ k6, UInt32 ) ) or ( e * CType( k2 ^ k26, UInt32 ) ) ) xor _
		      ( ( e \ CType( k2 ^ k11, UInt32 ) ) or ( e * CType( k2 ^ k21, UInt32 ) ) ) xor _
		      ( ( e \ CType( k2 ^ k25, UInt32 ) ) or ( e * CType( k2 ^ k7, UInt32 ) ) )
		      
		      dim ch as UInt32 = ( e and f ) xor ( ( not e ) and g )
		      dim temp1 as UInt32 = h + s1 + ch + kPtr.UInt32( i * 4 ) + w.UInt32Value( i * 4 )
		      
		      'dim s0 as UInt32 = RotateRight( a, 2 ) xor RotateRight( a, 13 ) xor RotateRight( a, 22 )
		      dim s0 as UInt32 = _
		      ( ( a \ CType( k2 ^ k2, UInt32 ) ) or ( a * CType( k2 ^ k30, UInt32 ) ) ) xor _
		      ( ( a \ CType( k2 ^ k13, UInt32 ) ) or ( a * CType( k2 ^ k19, UInt32 ) ) ) xor _
		      ( ( a \ CType( k2 ^ k22, UInt32 ) ) or ( a * CType( k2 ^ k10, UInt32 ) ) )
		      
		      dim maj as UInt32 = ( a and b ) xor ( a and c ) xor ( b and c )
		      dim temp2 as UInt32 = s0 + maj
		      
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
		  
		  useRegisters.UInt32Value( 0 ) = h0
		  useRegisters.UInt32Value( 4 ) = h1
		  useRegisters.UInt32Value( 8 ) = h2
		  useRegisters.UInt32Value( 12 ) = h3
		  useRegisters.UInt32Value( 16 ) = h4
		  useRegisters.UInt32Value( 20 ) = h5
		  useRegisters.UInt32Value( 24 ) = h6
		  useRegisters.UInt32Value( 28 ) = h7
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  if Registers is nil then
		    Registers = new MemoryBlock( 32 )
		    Registers.LittleEndian = false
		  end if
		  
		  Registers.UInt32Value( 0 ) = &h6a09e667
		  Registers.UInt32Value( 4 ) = &hbb67ae85
		  Registers.UInt32Value( 8 ) = &h3c6ef372
		  Registers.UInt32Value( 12 ) = &ha54ff53a
		  Registers.UInt32Value( 16 ) = &h510e527f
		  Registers.UInt32Value( 20 ) = &h9b05688c
		  Registers.UInt32Value( 24 ) = &h1f83d9ab
		  Registers.UInt32Value( 28 ) = &h5be0cd19
		  
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
		Private Message As MemoryBlock
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


	#tag Constant, Name = kChunkBytes, Type = Double, Dynamic = False, Default = \"64", Scope = Private
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
	#tag EndViewBehavior
End Class
#tag EndClass
