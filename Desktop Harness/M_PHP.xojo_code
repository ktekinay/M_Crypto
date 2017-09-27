#tag Module
Protected Module M_PHP
	#tag Method, Flags = &h1
		Protected Function Bcrypt(key As String, salt As String) As String
		  key = key.ReplaceAll( "'", "\'" )
		  
		  dim cmd as string = "$key = '%key%' ; $salt = '%salt%' ; print crypt( $key, $salt ) ;"
		  cmd = cmd.ReplaceAll( "%key%", key )
		  cmd = cmd.ReplaceAll( "%salt%", salt )
		  
		  dim phpHash as string = Execute( cmd )
		  return phpHash
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Execute(code As String) As String
		  dim cmd as string = PHPCommand
		  if cmd <> "" then
		    dim params as string = "-r '" + code.ReplaceAll( "'", "'\''" ) + "'"
		    
		    dim sh as new Shell
		    sh.Execute cmd, params
		    return sh.Result.Trim
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PHPCommand() As String
		  #if not TargetWin32
		    dim sh as new Shell
		    sh.Execute "which php"
		    return sh.Result.Trim
		  #endif
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
End Module
#tag EndModule
