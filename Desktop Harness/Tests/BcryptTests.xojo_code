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
		  Assert.Message "PHP: " + phpHash
		  Assert.Message "PHP: " + sw.ElapsedMilliseconds.ToString + " ms"
		  sw.Reset
		  
		  sw.Start
		  dim hash as string = Bcrypt_MTC.Hash( key, salt )
		  sw.Stop
		  Assert.Message "Hash: " + hash
		  Assert.Message "Hash: " + sw.ElapsedMilliseconds.ToString + " ms"
		  
		  
		  Assert.AreSame phpHash, hash
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValidateTest()
		  self.StopTestOnFail = true
		  
		  dim keyArr() as string = array( _
		  "password", _
		  "1", _
		  "12", _
		  "123", _
		  "1234", _
		  "really really long" _
		  )
		  dim saltArr() as string = array( _
		  "$2y$10$gFlYVWnr3suQtSP5MINSye", _
		  "$2y$10$K6Tbm93Hq/wz6v5GkdOsuu", _
		  "$2y$10$dRgsk7crlrRpmv4h/o5DYO", _
		  "$2y$10$OT44pEPnCJX3jrZfIatGX.", _
		  "$2a$10$TP/2KuWipRCCoVrLeIrULO", _
		  "$2y$10$tTZb/RTD5ns0n0rt71dGKu" _
		  )
		  
		  dim expectedArr() as string = array( _
		  "$2y$10$gFlYVWnr3suQtSP5MINSyeZ3VAss3hTfwuu2d.GGOM7dYkzeTxkH.", _ // password
		  "$2y$10$K6Tbm93Hq/wz6v5GkdOsuuVfo/H85.CPDKGxRQE4PiCo63rq3eSm2", _ // 1
		  "$2y$10$dRgsk7crlrRpmv4h/o5DYO2SiqAAdzcWd2KeA0iKCKJZP7exk9yLu", _ // 12
		  "$2y$10$OT44pEPnCJX3jrZfIatGX.jvbqmIpXOy8RS0K3ClDEYkWizlCbjj6", _ // 123
		  "$2a$10$TP/2KuWipRCCoVrLeIrULOsg1AgzX3BnSrgJnxtCIWiBf.VOCp1W2", _ // 1234
		  "$2y$10$tTZb/RTD5ns0n0rt71dGKuxire5RnOFHQddFauFUE1PP.0EGc2q4." _ // really really long
		  )
		  
		  for i as integer = 0 to keyArr.Ubound
		    dim key as string = keyArr( i )
		    dim salt as string = saltArr( i )
		    dim expected as string = expectedArr( i )
		    
		    dim actual as string = Bcrypt_MTC.Hash( key, salt )
		    Assert.AreSame( expected, actual, "Hashes differ for " + key )
		    Assert.IsTrue Bcrypt_MTC.Verify( key, expected ), "Failed to verify " + key
		  next
		  
		  dim hash as string = "$2a$12$fEYmH3px9mOdUMQw4mglvubfTSJLb55SK/3wWe3nQ5kpxCLDXtSoG"
		  
		  StartTestTimer "Verification of 12 rounds"
		  dim isValid as boolean = Bcrypt_MTC.Verify( "test123", hash )
		  LogTestTimer "Verification of 12 rounds"
		  
		  Assert.IsTrue isValid, "Verify test123"
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kSalt, Type = String, Dynamic = False, Default = \"$2y$10$1234567890123456789012", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
