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
		  const k2 as UInt32 = 2
		  const k3 as UInt32 = 3
		  const k10 as UInt32 = 10
		  
		  dim dataLen as integer = data.LenB
		  
		  // Add one char to the length
		  dim padding as integer = 64 - ( ( dataLen + 1 ) mod 64 )
		  
		  // Check if we have enough room for inserting the length
		  if padding < 8 then 
		    padding = padding + 64
		  end if
		  
		  dim mbIn as new MemoryBlock( dataLen + padding + 1 )
		  mbIn.LittleEndian = false
		  
		  mbIn.StringValue( 0, dataLen ) = data
		  
		  // Set the first bit after the data to 1
		  mbIn.Byte( dataLen ) = &b10000000
		  
		  // Copy length of data to the last 8 bytes
		  mbIn.UInt64Value( mbIn.Size - 8 ) = dataLen * 8 // In bits
		  
		  // Table of constants
		  static k() as UInt32 = ArrayUInt32( _
		  &h428a2f98, &h71374491, &hb5c0fbcf, &he9b5dba5, &h3956c25b, &h59f111f1, &h923f82a4, &hab1c5ed5, _
		  &hd807aa98, &h12835b01, &h243185be, &h550c7dc3, &h72be5d74, &h80deb1fe, &h9bdc06a7, &hc19bf174, _
		  &he49b69c1, &hefbe4786, &h0fc19dc6, &h240ca1cc, &h2de92c6f, &h4a7484aa, &h5cb0a9dc, &h76f988da, _
		  &h983e5152, &ha831c66d, &hb00327c8, &hbf597fc7, &hc6e00bf3, &hd5a79147, &h06ca6351, &h14292967, _
		  &h27b70a85, &h2e1b2138, &h4d2c6dfc, &h53380d13, &h650a7354, &h766a0abb, &h81c2c92e, &h92722c85, _
		  &ha2bfe8a1, &ha81a664b, &hc24b8b70, &hc76c51a3, &hd192e819, &hd6990624, &hf40e3585, &h106aa070, _
		  &h19a4c116, &h1e376c08, &h2748774c, &h34b0bcb5, &h391c0cb3, &h4ed8aa4a, &h5b9cca4f, &h682e6ff3, _
		  &h748f82ee, &h78a5636f, &h84c87814, &h8cc70208, &h90befffa, &ha4506ceb, &hbef9a3f7, &hc67178f2 _
		  )
		  
		  dim h0 as UInt32 = &h6a09e667
		  dim h1 as UInt32 = &hbb67ae85
		  dim h2 as UInt32 = &h3c6ef372
		  dim h3 as UInt32 = &ha54ff53a
		  dim h4 as UInt32 = &h510e527f
		  dim h5 as UInt32 = &h9b05688c
		  dim h6 as UInt32 = &h1f83d9ab
		  dim h7 as UInt32 = &h5be0cd19
		  dim a, b, c, d, e, f, g, h as UInt32
		  
		  dim lastByteIndex as integer = mbIn.Size - 1
		  for chunkIndex as integer = 0 to lastByteIndex step 64 // Split into block of 64 bytes
		    dim w as new MemoryBlock( 256 )
		    w.LittleEndian = false
		    
		    w.StringValue( 0, 64 ) = mbIn.StringValue( chunkIndex, 64 )
		    
		    for wordIndex as integer = 64 to 255 step 4
		      dim word0 as UInt32 = w.UInt32Value( wordIndex - 64 )
		      dim word1 as UInt32 = w.UInt32Value( wordIndex - 60 )
		      dim word9 as UInt32 = w.UInt32Value( wordIndex - 28 )
		      dim word14 as UInt32 = w.UInt32Value( wordIndex - 8 )
		      
		      dim s0 as UInt32 = ( RotateRight( word1, 7 ) xor RotateRight( word1, 18 ) ) xor ( word1 \ CType( k2 ^ k3, UInt32 ) )
		      dim s1 as UInt32 = ( RotateRight( word14, 17 ) xor RotateRight( word14, 19 ) ) xor ( word14 \ CType( k2 ^ k10, UInt32 ) )
		      
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
		    
		    for i as integer = 0 to 63
		      dim s1 as UInt32 = RotateRight( e, 6 ) xor RotateRight( e, 11 ) xor RotateRight( e, 25 )
		      dim ch as UInt32 = ( e and f ) xor ( ( not e ) and g )
		      dim temp1 as UInt32 = h + s1 + ch + k( i ) + w.UInt32Value( i * 4 )
		      
		      dim s0 as UInt32 = RotateRight( a, 2 ) xor RotateRight( a, 13 ) xor RotateRight( a, 22 )
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
		  
		  mValue.UInt32Value( 0 ) = h0
		  mValue.UInt32Value( 4 ) = h1
		  mValue.UInt32Value( 8 ) = h2
		  mValue.UInt32Value( 12 ) = h3
		  mValue.UInt32Value( 16 ) = h4
		  mValue.UInt32Value( 20 ) = h5
		  mValue.UInt32Value( 24 ) = h6
		  mValue.UInt32Value( 28 ) = h7
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  mValue = new MemoryBlock( 32 )
		  mValue.LittleEndian = false
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RotateRight(x As UInt32, places As UInt32) As UInt32
		  const k2 as UInt32 = 2
		  const k32 as UInt32 = 32
		  
		  dim diff as UInt32 = k32 - places
		  dim leftMost as UInt32 = x * CType( k2 ^ diff, UInt32 )
		  dim rightMost as UInt32 = x \ CType( k2 ^ places, UInt32 )
		  
		  dim result as UInt32 = leftMost or rightMost
		  
		  #if DebugBuild and FALSE then
		    const kZeros as string = "00000000000000000000000000000000"
		    System.DebugLog "Places: " + str( places )
		    System.DebugLog "Orig: " + Right( kZeros + bin( x ), 32 )
		    System.DebugLog "Left: " + Right( kZeros + bin( leftMost ), 32 )
		    System.DebugLog "Rigt: " + Right( kZeros + bin( rightMost ), 32 )
		    System.DebugLog "Resl: " + Right( kZeros + bin( result ), 32 )
		    System.DebugLog "----"
		  #endif
		  
		  return result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mValue As MemoryBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mValue
			End Get
		#tag EndGetter
		Value As String
	#tag EndComputedProperty


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
