#tag Class
Protected Class ScryptUnitTester
	#tag Method, Flags = &h0
		Function BlockMix(mb As MemoryBlock) As MemoryBlock
		  dim newMB as MemoryBlock
		  newMB = mb.StringValue( 0, mb.Size )
		  Scrypt_MTC.BlockMix( newMB )
		  return newMB
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ROMix(mb As MemoryBlock, n As Integer) As MemoryBlock
		  return Scrypt_MTC.ROMix( mb, n )
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
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
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
