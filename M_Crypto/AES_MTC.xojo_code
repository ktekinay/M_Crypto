#tag Class
Class AES_MTC
Inherits M_Crypto.Encrypter
	#tag Method, Flags = &h0
		Sub Constructor(key As String, bits As EncryptionBits = EncryptionBits.Bits128, paddingMethod As Padding = Padding.PKCS5)
		  RaiseErrorIf key = "", kErrorKeyCannotBeEmpty
		  
		  self.Bits = Integer( bits )
		  self.PaddingMethod = paddingMethod
		  
		  select case bits
		  case AES_MTC.EncryptionBits.Bits256
		    Nk = 8
		    KeyLen = 32
		    Nr = 14
		    KeyExpSize = 240
		    
		  case AES_MTC.EncryptionBits.Bits192
		    Nk = 6
		    KeyLen = 24
		    Nr = 12
		    KeyExpSize = 208
		    
		  case AES_MTC.EncryptionBits.Bits128
		    Nk = 4
		    KeyLen = 16
		    Nr = 10
		    KeyExpSize = 176
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Bits As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyExpSize As Byte
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyLen As Byte
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Nk As Byte
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Nr As Byte
	#tag EndProperty


	#tag Constant, Name = kBlockLen, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kNb, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


	#tag Enum, Name = EncryptionBits, Type = Integer, Flags = &h0
		Bits128 = 128
		  Bits192 = 192
		Bits256 = 256
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="CurrentVector"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
			Name="PaddingMethod"
			Group="Behavior"
			Type="Padding"
			EditorType="Enum"
			#tag EnumValues
				"0 - NullPadding"
				"1 - PKCS5"
			#tag EndEnumValues
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
