#tag Module
Protected Module M_Crypto
	#tag Method, Flags = &h1
		Protected Function GetEncrypter(fromCode As String) As M_Crypto.Encrypter
		  dim result as M_Crypto.Encrypter
		  
		  dim rx as new RegEx
		  rx.SearchPattern = kRxEncryptCode
		  
		  dim match as RegExMatch = rx.Search( fromCode )
		  
		  if match isa object then
		    
		    select case match.SubExpressionString( 1 )
		    case "aes"
		      dim bits as integer = 128
		      if match.SubExpressionCount > 2 then
		        bits = match.SubExpressionString( 2 ).Val
		      end if
		      result = new AES_MTC( bits )
		      
		    case "bf", "blowfish"
		      result = new Blowfish_MTC
		      
		    end select
		    
		  end if
		  
		  if result is nil then
		    raise new InvalidCodeException
		  end if
		  
		  if match.SubExpressionCount = 4 then
		    select case match.SubExpressionString( 3 )
		    case "cbc"
		      result.UseFunction = Encrypter.Functions.CBC
		      
		    case "ecb"
		      result.UseFunction = Encrypter.Functions.ECB
		      
		    end select
		  end if
		  
		  return result
		End Function
	#tag EndMethod


	#tag Constant, Name = kCodeAES128CBC, Type = String, Dynamic = False, Default = \"aes-128-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeAES128ECB, Type = String, Dynamic = False, Default = \"aes-128-ecb", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeAES192CBC, Type = String, Dynamic = False, Default = \"aes-192-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeAES192ECB, Type = String, Dynamic = False, Default = \"aes-192-ecb", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeAES256CBC, Type = String, Dynamic = False, Default = \"aes-256-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeAES256ECB, Type = String, Dynamic = False, Default = \"aes-256-ecb", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeBlowfishCBC, Type = String, Dynamic = False, Default = \"bf-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kCodeBlowfishECB, Type = String, Dynamic = False, Default = \"bf-ecb", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kRxEncryptCode, Type = String, Dynamic = False, Default = \"(\?x)\n\\A\n(\?|\n  (aes) (\?:-\?(\?:(128|192|256)))\?\n  | (bf) \n  | (blowfish)\n)\n\\b \n(\?:-(cbc|ecb))\?\n\\z", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.0", Scope = Protected
	#tag EndConstant


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
End Module
#tag EndModule
