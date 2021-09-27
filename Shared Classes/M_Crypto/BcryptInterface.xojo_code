#tag Interface
Protected Interface BcryptInterface
	#tag Method, Flags = &h0
		Sub EncryptMb(data As MemoryBlock)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Expand0State(repetitions As Integer, ParamArray keys() As MemoryBlock)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExpandState(data As MemoryBlock, key As String)
		  
		End Sub
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
End Interface
#tag EndInterface
