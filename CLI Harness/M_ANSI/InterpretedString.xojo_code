#tag Class
Protected Class InterpretedString
	#tag Property, Flags = &h0
		Buffer() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return CursorPosition - 2
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  CursorPosition = value + 2
			  
			End Set
		#tag EndSetter
		BufferIndex As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mCursorPosition
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value < 1 then
			    value = 1
			  elseif value > ( Buffer.Ubound + 2 ) then
			    value = Buffer.Ubound + 2
			  end if
			  
			  mCursorPosition = value
			End Set
		#tag EndSetter
		CursorPosition As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return BufferIndex >= Buffer.Ubound
			End Get
		#tag EndGetter
		EOF As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return join( Buffer, "" )
			  
			End Get
		#tag EndGetter
		Interpreted As String
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Attributes( hidden ) Private mCursorPosition As Integer = 1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BufferIndex"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CursorPosition"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EOF"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Interpreted"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
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
