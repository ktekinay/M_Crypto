#tag Class
Protected Class Argon2Tests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub RFC2dTest()
		  var memoryKB as integer = 32
		  var iterations as integer = 3
		  var parallelism as integer = 4
		  var tagLength as integer = 32
		  var password as string = DecodeHex( "01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01" )
		  var salt as string = DecodeHex( "02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02" )
		  var secret as string = DecodeHex( "03 03 03 03 03 03 03 03" )
		  var associatedData as string = DecodeHex( "04 04 04 04 04 04 04 04 04 04 04 04" )
		  
		  var expected as string = DecodeHex( _
		  "51 2b 39 1b 6f 11 62 97 " + _
		  "53 71 d3 09 19 73 42 94 " + _
		  "f8 68 e3 be 39 84 f3 c1 " + _
		  "a1 3a 4d b9 fa be 4a cb " _
		  )
		  var actual as string = Argon2_MTC.Hash2d( password, salt, tagLength, parallelism, memoryKB, iterations, secret, associatedData )
		  
		  Assert.AreSame EncodeHex( expected, true ), EncodeHex( actual, true )
		  
		  ' =======================================
		  ' Argon2d version number 19
		  ' =======================================
		  ' Memory: 32 KiB
		  ' Passes: 3
		  ' Parallelism: 4 lanes
		  ' Tag length: 32 bytes
		  ' Password[32]: 01 01 01 01 01 01 01 01
		  '               01 01 01 01 01 01 01 01
		  '               01 01 01 01 01 01 01 01
		  '               01 01 01 01 01 01 01 01
		  ' Salt[16]: 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
		  ' Secret[8]: 03 03 03 03 03 03 03 03
		  ' Associated data[12]: 04 04 04 04 04 04 04 04 04 04 04 04
		  ' Pre-hashing digest: b8 81 97 91 a0 35 96 60
		  '                     bb 77 09 c8 5f a4 8f 04
		  '                     d5 d8 2c 05 c5 f2 15 cc
		  '                     db 88 54 91 71 7c f7 57
		  '                     08 2c 28 b9 51 be 38 14
		  '                     10 b5 fc 2e b7 27 40 33
		  '                     b9 fd c7 ae 67 2b ca ac
		  '                     5d 17 90 97 a4 af 31 09
		  ' 
		  '  After pass 0:
		  ' Block 0000 [  0]: db2fea6b2c6f5c8a
		  ' Block 0000 [  1]: 719413be00f82634
		  ' Block 0000 [  2]: a1e3f6dd42aa25cc
		  ' Block 0000 [  3]: 3ea8efd4d55ac0d1
		  ' ...
		  ' Block 0031 [124]: 28d17914aea9734c
		  ' Block 0031 [125]: 6a4622176522e398
		  ' Block 0031 [126]: 951aa08aeecb2c05
		  ' Block 0031 [127]: 6a6c49d2cb75d5b6
		  ' 
		  '  After pass 1:
		  ' Block 0000 [  0]: d3801200410f8c0d
		  ' Block 0000 [  1]: 0bf9e8a6e442ba6d
		  ' Block 0000 [  2]: e2ca92fe9c541fcc
		  ' Block 0000 [  3]: 6269fe6db177a388
		  ' ...
		  ' Block 0031 [124]: 9eacfcfbdb3ce0fc
		  ' Block 0031 [125]: 07dedaeb0aee71ac
		  ' Block 0031 [126]: 074435fad91548f4
		  ' Block 0031 [127]: 2dbfff23f31b5883
		  ' 
		  '  After pass 2:
		  ' Block 0000 [  0]: 5f047b575c5ff4d2
		  ' Block 0000 [  1]: f06985dbf11c91a8
		  ' Block 0000 [  2]: 89efb2759f9a8964
		  ' Block 0000 [  3]: 7486a73f62f9b142
		  ' ...
		  ' Block 0031 [124]: 57cfb9d20479da49
		  ' Block 0031 [125]: 4099654bc6607f69
		  ' Block 0031 [126]: f142a1126075a5c8
		  ' Block 0031 [127]: c341b3ca45c10da5
		  ' Tag: 51 2b 39 1b 6f 11 62 97
		  '      53 71 d3 09 19 73 42 94
		  '      f8 68 e3 be 39 84 f3 c1
		  '      a1 3a 4d b9 fa be 4a cb
		End Sub
	#tag EndMethod


	#tag Constant, Name = kKibiBytes, Type = Double, Dynamic = False, Default = \"Argon2_MTC.kKibiBytes", Scope = Private
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
