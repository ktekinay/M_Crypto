#tag Class
Protected Class ScryptUnitTester
	#tag Method, Flags = &h0
		Function BlockMix(mb As MemoryBlock) As MemoryBlock
		  dim blockBuffer as new MemoryBlock( mb.Size )
		  dim buffer as new MemoryBlock( 128 )
		  
		  dim newMB as MemoryBlock = mb.StringValue( 0, mb.Size )
		  dim p as ptr = newMB
		  Scrypt_MTC.BlockMix( newMB, p, blockBuffer, buffer )
		  
		  return newMB
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ROMix(mb As MemoryBlock, n As Integer) As MemoryBlock
		  dim blockBuffer as new MemoryBlock( mb.Size )
		  dim buffer as new MemoryBlock( 128 )
		  dim vBuffer as new MemoryBlock( mb.Size * n )
		  
		  dim newMB as MemoryBlock = mb.StringValue( 0, mb.Size )
		  Scrypt_MTC.ROMix( newMB, n, blockBuffer, buffer, vBuffer )
		  
		  return newMB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Salsa(mb As MemoryBlock) As MemoryBlock
		  dim newMB as new MemoryBlock( mb.Size )
		  newMB.StringValue( 0, mb.Size ) = mb
		  Scrypt_MTC.Salsa( newMB )
		  return newMB
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
