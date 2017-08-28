#tag Module
Protected Module M_OpenSSL
	#tag Method, Flags = &h1
		Protected Function Encrypt(algorithm As String, data As String, key As String, vectorHex As String = "") As String
		  const kSaltedPrefix = "Salted__"
		  
		  dim cmd as string = "echo '" + data.ReplaceAll( "'", "'\''" ) + "' | " + _
		  kPath + "enc -" + algorithm + " -base64 -pass pass:" + key 
		  if vectorHex <> "" then
		    cmd = cmd + " -iv " + vectorHex
		  end if
		  
		  dim sh as new shell
		  sh.Execute cmd
		  if sh.ErrorCode <> 0 then
		    raise new RuntimeException
		  end if
		  
		  dim result as string = sh.Result.Trim
		  result = DecodeBase64( result )
		  if result.LeftB( kSaltedPrefix.LenB ) = kSaltedPrefix then
		    result = result.MidB( kSaltedPrefix.LenB + 1 )
		  end if
		  
		  return result
		End Function
	#tag EndMethod


	#tag Constant, Name = kAES128CBC, Type = String, Dynamic = False, Default = \"aes-128-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kAES128ECB, Type = String, Dynamic = False, Default = \"aes-128-ecb", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kAES256CBC, Type = String, Dynamic = False, Default = \"aes-256-cbc", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kPath, Type = String, Dynamic = False, Default = \"/usr/bin/openssl ", Scope = Private
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
