#tag Class
Protected Class SHA256Digest_MTC
	#tag Method, Flags = &h21
		Private Function ArrayUInt32(ParamArray arr() As UInt32) As UInt32()
		  return arr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  //
		  // Table of constants
		  //
		  
		  if kMagic is nil then
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
		    
		    kMagic = new MemoryBlock( ( arr.Ubound + 1 ) * 4 )
		    kMagicPtr = kMagic
		    
		    for i as integer = 0 to arr.Ubound
		      kMagicPtr.UInt32( i * 4 ) = arr( i )
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
		  
		  const k2 as UInt32 = 2 ^ 2
		  const k3 as UInt32 = 2 ^ 3
		  const k6 as UInt32 = 2 ^ 6
		  const k7 as UInt32 = 2 ^ 7
		  const k10 as UInt32 = 2 ^ 10
		  const k11 as UInt32 = 2 ^ 11
		  const k13 as UInt32 = 2 ^ 13
		  const k14 as UInt32 = 2 ^ 14
		  const k15 as UInt32 = 2 ^ 15
		  const k17 as UInt32 = 2 ^ 17
		  const k18 as UInt32 = 2 ^ 18
		  const k19 as UInt32 = 2 ^ 19
		  const k21 as UInt32 = 2 ^ 21
		  const k22 as UInt32 = 2 ^ 22
		  const k25 as UInt32 = 2 ^ 25
		  const k26 as UInt32 = 2 ^ 26
		  const k30 as UInt32 = 2 ^ 30
		  
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
		    if padding < 8 then 
		      padding = padding + kChunkBytes
		    end if
		    
		    mbIn.Size = dataLen + padding + 1
		    mbIn.LittleEndian = false
		    
		    //
		    // Set the first bit after the data to 1
		    //
		    mbIn.Byte( dataLen ) = &b10000000
		    
		    //
		    // Copy length of data to the last 8 bytes
		    //
		    mbIn.UInt64Value( mbIn.Size - 8 ) = ( CombinedLength + dataLen ) * 8 // In bits
		    
		  end if
		  
		  dim pIn as ptr = mbIn
		  
		  dim h0 as UInt32 = useRegisters.H0
		  dim h1 as UInt32 = useRegisters.H1
		  dim h2 as UInt32 = useRegisters.H2
		  dim h3 as UInt32 = useRegisters.H3
		  dim h4 as UInt32 = useRegisters.H4
		  dim h5 as UInt32 = useRegisters.H5
		  dim h6 as UInt32 = useRegisters.H6
		  dim h7 as UInt32 = useRegisters.H7
		  
		  dim a, b, c, d, e, f, g, h as UInt32
		  dim word0, word1, word9, word14 as UInt32
		  dim temp1, temp2, maj, ch as UInt32
		  dim s0, s1 as UInt32
		  dim newValue as UInt32
		  
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
		    //
		    // We'll do this two words at a time
		    //
		    const k8_64 as UInt64 = 2 ^ 8
		    const k24_64 as UInt64 = 2 ^ 24
		    
		    const kMask0 as UInt64 = &hFF00000000000000
		    const kMask1 as UInt64 = &h00FF000000000000
		    const kMask2 as UInt64 = &h0000FF0000000000
		    const kMask3 as UInt64 = &h000000FF00000000
		    const kMask4 as UInt64 = &h00000000FF000000
		    const kMask5 as UInt64 = &h0000000000FF0000
		    const kMask6 as UInt64 = &h000000000000FF00
		    const kMask7 as UInt64 = &h00000000000000FF
		    
		    dim t1 as UInt64
		    
		    for i as integer = 0 to lastByteIndex step 8
		      t1 = pIn.UInt64( i )
		      pIn.UInt64( i ) = _
		      _ // Word 1
		      ( ( t1 and kMask0 ) \ k24_64 ) or _
		      ( ( t1 and kMask1 ) \ k8_64 ) or _
		      ( ( t1 and kMask2 ) * k8_64 ) or _
		      ( ( t1 and kMask3 ) * k24_64 ) or _
		      _ // Word 2
		      ( ( t1 and kMask4 ) \ k24_64 ) or _
		      ( ( t1 and kMask5 ) \ k8_64 ) or _
		      ( ( t1 and kMask6 ) * k8_64 ) or _
		      ( ( t1 and kMask7 ) * k24_64 )
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
		    
		    for wordIndex as integer = kChunkBytes to kLastMessageByteIndex step 4
		      word0 = pMessage.UInt32( wordIndex - 64 )
		      word1 = pMessage.UInt32( wordIndex - 60 )
		      word9 = pMessage.UInt32( wordIndex - 28 )
		      word14 = pMessage.UInt32( wordIndex - 8 )
		      
		      'dim s0 as UInt32 = ( RotateRight( word1, 7 ) xor RotateRight( word1, 18 ) ) xor ( word1 \ k3 )
		      s0 = _
		      ( ( ( word1 \ k7 ) or ( word1 * k25 ) ) xor _
		      ( ( word1 \ k18 ) or ( word1 * k14 ) ) ) _
		      xor ( word1 \ k3 )
		      
		      'dim s1 as UInt32 = ( RotateRight( word14, 17 ) xor RotateRight( word14, 19 ) ) xor ( word14 \ k10 )
		      s1 = _
		      ( ( ( word14 \ k17 ) or ( word14 * k15 ) ) xor _
		      ( ( word14 \ k19 ) or ( word14 * k13 ) ) ) _
		      xor ( word14 \ k10 )
		      
		      newValue = word0 + s0 + word9 + s1
		      pMessage.UInt32( wordIndex ) = newValue
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
		      'dim s1 as UInt32 = RotateRight( e, 6 ) xor RotateRight( e, 11 ) xor RotateRight( e, 25 )
		      s1 = _
		      ( ( e \ k6 ) or ( e * k26 ) ) xor _
		      ( ( e \ k11 ) or ( e * k21 ) ) xor _
		      ( ( e \ k25 ) or ( e * k7 ) )
		      
		      ch = ( e and f ) xor ( ( not e ) and g )
		      temp1 = h + s1 + ch + kMagicPtr.UInt32( i * 4 ) + pMessage.UInt32( i * 4 )
		      
		      'dim s0 as UInt32 = RotateRight( a, 2 ) xor RotateRight( a, 13 ) xor RotateRight( a, 22 )
		      s0 = _
		      ( ( a \ k2 ) or ( a * k30 ) ) xor _
		      ( ( a \ k13 ) or ( a * k19 ) ) xor _
		      ( ( a \ k22 ) or ( a * k10 ) )
		      
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
		  Registers.H0 = &h6a09e667
		  Registers.H1 = &hbb67ae85
		  Registers.H2 = &h3c6ef372
		  Registers.H3 = &ha54ff53a
		  Registers.H4 = &h510e527f
		  Registers.H5 = &h9b05688c
		  Registers.H6 = &h1f83d9ab
		  Registers.H7 = &h5be0cd19
		  
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


	#tag Constant, Name = kChunkBytes, Type = Double, Dynamic = False, Default = \"64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLastMessageByteIndex, Type = Double, Dynamic = False, Default = \"255", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLastRoundIndex, Type = Double, Dynamic = False, Default = \"63", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.5.1", Scope = Public
	#tag EndConstant


	#tag Structure, Name = RegisterStruct, Flags = &h21
		H0 As UInt32
		  H1 As UInt32
		  H2 As UInt32
		  H3 As UInt32
		  H4 As UInt32
		  H5 As UInt32
		  H6 As UInt32
		H7 As UInt32
	#tag EndStructure


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
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
