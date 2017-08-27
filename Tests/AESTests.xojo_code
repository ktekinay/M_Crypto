#tag Class
Protected Class AESTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub EncryptECBTest()
		  dim key as string = DecodeHex( "2b7e151628aed2a6abf7158809cf4f3c" )
		  dim data as string = "6bc1bee22e409f96e93d7e117393172a"
		  dim expected as string = "3ad77bb40d7a3660a89ecaf32466ef97"
		  
		  dim e as new AES_MTC( key )
		  e.PaddingMethod = AES_MTC.Padding.NullPadding
		  dim encrypted as string = e.EncryptECB( DecodeHex( data ) )
		  Assert.AreEqual expected, EncodeHex( encrypted ) , "Encrypted doesn't match"
		  
		  dim decrypted as string = EncodeHex( e.DecryptECB( encrypted ) )
		  Assert.AreEqual data, decrypted, "Decrypted doesn't match"
		  
		  
		  key = "password"
		  data = "This is a very long string that should be hard to encrypt"
		  expected = "56ae03aa6ce6bf0cb7be7fbea8d2253cf42bea48361ce4c006c8e79aa1eae329191b801a0811a80ad319252fb5428f3c22e9ff89befb2188be9338a913330b3c"
		  
		  e = new AES_MTC( key )
		  e.PaddingMethod = AES_MTC.Padding.NullPadding
		  encrypted = e.EncryptECB( data )
		  Assert.AreEqual expected, EncodeHex( encrypted ), "Long encryption doesn't match"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitializeTest()
		  dim e as new AES_MTC( "password" )
		  Assert.IsNotNil e
		End Sub
	#tag EndMethod


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
