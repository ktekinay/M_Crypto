#tag Class
Protected Class AES128AdditionalModesTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub CFBTest()
		  dim key as string 
		  dim data as string 
		  dim expectedBase64 as string 
		  dim vectorHex as string
		  dim encrypted as string
		  dim e as AES_MTC
		  
		  vectorHex = "000102030405060708090a0b0c0d0e0f"
		  key = DecodeHex( "12345678901234567890123456789012" )
		  data = "The quick brown fox jumps over the lazy dog."
		  expectedBase64 = "monf9urxPIRzEKjeOqQ1H7A84Vo05K2MgWnGfCKRbVgd/0WpAxn1TS6r+CE="
		  
		  e = GetAES( key )
		  e.SetInitialVector vectorHex
		  
		  encrypted = e.EncryptCFB( data )
		  Assert.AreEqual expectedBase64, EncodeBase64( encrypted, 0 ), "Encrypted doesn't match 1"
		  
		  encrypted = e.EncryptCFB( data )
		  Assert.AreEqual expectedBase64, EncodeBase64( encrypted, 0 ), "Encrypted doesn't match 2"
		  
		  dim decrypted as string = e.DecryptCFB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreEqual data, decrypted, "Decrypted doesn't match"
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetAES(key As String) As AES_MTC
		  return new AES_MTC( key, AES_MTC.EncryptionBits.Bits128, AES_MTC.Padding.None )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OFBTest()
		  dim key as string 
		  dim data as string 
		  dim expectedBase64 as string 
		  dim vectorHex as string
		  dim encrypted as string
		  dim e as AES_MTC
		  
		  vectorHex = "000102030405060708090a0b0c0d0e0f"
		  key = DecodeHex( "12345678901234567890123456789012" )
		  data = "The quick brown fox jumps over the lazy dog."
		  expectedBase64 = "monf9urxPIRzEKjeOqQ1HwvW3cNHqA3MIwHWxbXr7EWSd6LUN2lKhG2ma8A="
		  
		  e = GetAES( key )
		  e.SetInitialVector vectorHex
		  
		  encrypted = e.EncryptOFB( data )
		  Assert.AreEqual expectedBase64, EncodeBase64( encrypted, 0 ), "Encrypted doesn't match 1"
		  
		  encrypted = e.EncryptOFB( data )
		  Assert.AreEqual expectedBase64, EncodeBase64( encrypted, 0 ), "Encrypted doesn't match 2"
		  
		  dim decrypted as string = e.DecryptOFB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreEqual data, decrypted, "Decrypted doesn't match"
		  
		  
		  
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
