#tag Class
Protected Class BcryptTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CompareToPHPTest()
		  dim key as string = "password"
		  dim salt as string = kSalt
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  dim phpHash as string = M_PHP.Bcrypt( key, salt )
		  sw.Stop
		  
		  if PHPHash = "" then
		    Assert.Message "Unavailable on this platform"
		    return
		  end if
		  
		  // See if we can compare PHP
		  Assert.Message "PHP: " + phpHash.ToText
		  Assert.Message "PHP: " + sw.ElapsedMilliseconds.ToText + " ms"
		  sw.Reset
		  
		  sw.Start
		  dim hash as string = Bcrypt_MTC.Hash( key, salt )
		  sw.Stop
		  Assert.Message "Hash: " + hash.ToText
		  Assert.Message "Hash: " + sw.ElapsedMilliseconds.ToText + " ms"
		  
		  
		  Assert.AreSame phpHash, hash
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValidateTest()
		  dim keyArr() as string = array( _
		  "password", _
		  "another", _
		  "really really long" _
		  )
		  dim saltArr() as string = array( _
		  "$2a$10$Rx0ZYqbDsF1OOzEULWc4xO", _
		  "$2a$10$gmXEULzll3Cu3LfWNRdk6u", _
		  "$2y$09$jRqLcPxXQBAX8MG0DMINWu" _
		  )
		  
		  dim expectedArr() as string = array( _
		  "$2a$10$Rx0ZYqbDsF1OOzEULWc4xO5m26RF0qsgd6iUL2P4mTCmfFlVRBogC", _
		  "$2a$10$gmXEULzll3Cu3LfWNRdk6u5pcI0/HMSU/o04Zs1nX79EA78wq3KN6", _
		  "$2y$09$jRqLcPxXQBAX8MG0DMINWuVmvzHri3/SvxyDjY./OU57IRZT6Nh72" _
		  )
		  
		  for i as integer = 0 to keyArr.Ubound
		    dim key as string = keyArr( i )
		    dim salt as string = saltArr( i )
		    dim expected as string = expectedArr( i )
		    
		    dim actual as string = Bcrypt_MTC.Hash( key, salt )
		    Assert.AreSame( expected, actual )
		    Assert.IsTrue Bcrypt_MTC.Verify( key, expected )
		  next
		  
		  dim hash as string = "$2a$12$fEYmH3px9mOdUMQw4mglvubfTSJLb55SK/3wWe3nQ5kpxCLDXtSoG"
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  
		  dim isValid as boolean = Bcrypt_MTC.Verify( "test123", hash )
		  
		  sw.Stop
		  
		  Assert.IsTrue isValid
		  Assert.Message "Verification of 12 rounds took " + sw.ElapsedSeconds.ToText( Xojo.Core.Locale.Current, "###,###,###,0.0##" ) + " s"
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kSalt, Type = String, Dynamic = False, Default = \"$2y$10$1234567890123456789012", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
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
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
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
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
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
