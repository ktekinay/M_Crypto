#tag Class
Protected Class Blake2bDigestTest
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub EmptyTest()
		  TestIt "", "786A02F742015903C6C6FD852552D272912F4740E15847618A86E217F71F5419D25E1031AFEE585313896444934EB04B903A685B1448B755D56F701AFE9BE2CE"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Exact128Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF", _
		  "7fdc929ec9743915de5f12ab3fa5b4901a23ad78e3f6606a4bb4edcd55c9d15cdaf7a96f3cc11938fefb31f2b9c2ea2c3b02bfa67cfa03f403ff899dca19fe5f"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitTest()
		  var b as new Blake2bDigest_MTC
		  Assert.IsNotNil b
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LargeFileTest()
		  var file as FolderItem = SpecialFolder.Resources.Child( "Testing Resources" ).Child( "Res_ipsa.html" )
		  var tis as TextInputStream = TextInputStream.Open( file )
		  var contents as string = tis.ReadAll( Encodings.UTF8 )
		  tis.Close
		  
		  StartTestTimer "mine"
		  TestIt contents, _
		  "e03b0e727add73d2ea1a0e852b170fa04fdaca3473ae24c1a3f3f6897a76112f292a06bb85466a85a2a405c7a756fb53ef18890dbdf59a364f4197e010c719cd"
		  LogTestTimer "mine"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoreThan128Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEFx", _
		  "e5291e6b6010615ae681d20a96f14c5d22bbb84ac3a504c3b296121431093d9f7a821a5f913038b6711aa22f3f917eb7eb257c92f2ac35dcfec296ecbd42581a"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoreThan256Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEFx", _
		  "37a70d386a6a3ccd943d6041d6a3436032898bb08109cad33bf0335776af7bf981b242e57b7ce39bedb0a21a5044813869291d253c659cd0addc6be82a7f7aa3"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RFCTest()
		  TestIt "abc", _
		  "BA 80 A5 3F 98 1C 4D 0D 6A 27 97 B6 9F 12 F6 E9" + _
		  "4C 21 2F 14 68 5A C4 B7 4B 12 BB 6F DB FF A2 D1" + _
		  "7D 87 C5 39 2A AB 79 2D C2 52 D5 DE 45 33 CC 95" + _
		  "18 D3 8A A8 DB F1 92 5A B9 23 86 ED D4 00 99 23"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestIt(data As String, expected As String)
		  var b as new Blake2bDigest_MTC
		  
		  b.Process data
		  var actual as string = EncodeHex( b.Value )
		  Assert.AreEqual expected.ReplaceAll( " ", "" ).Lowercase, actual.Lowercase, data.Left( 50 )
		  
		End Sub
	#tag EndMethod


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
