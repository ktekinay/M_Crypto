#tag Class
Protected Class EncrypterTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BadCloneTest()
		  dim e1 as new AES_MTC( 128 )
		  
		  #pragma BreakOnExceptions false
		  try
		    dim e2 as new Blowfish_MTC( e1 )
		    #pragma unused e2
		    Assert.Fail "Should have raised an exception"
		  catch err as TypeMismatchException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChangePasswordTest()
		  dim e as M_Crypto.Encrypter
		  
		  e = new AES_MTC( AES_MTC.EncryptionBits.Bits128 )
		  
		  e.SetKey "password1"
		  dim encrypted as string = e.EncryptCBC( "data" )
		  dim decrypted as string = e.DecryptCBC( encrypted )
		  Assert.AreEqual "data", decrypted, "AES 1"
		  
		  e.SetKey "password2"
		  dim encrypted2 as string = e.EncryptCBC( "data" )
		  Assert.AreNotEqual encrypted, encrypted2, "AES same encryption!"
		  Assert.AreEqual "data", e.DecryptCBC( encrypted2 ), "AES 2"
		  
		  e.SetKey "password1"
		  encrypted2 = e.EncryptCBC( "data" )
		  Assert.AreSame encrypted, encrypted2, "AES inconsistent result"
		  
		  e = new Blowfish_MTC
		  e.SetKey "password1"
		  encrypted = e.EncryptCBC( "data" )
		  decrypted = e.DecryptCBC( encrypted )
		  Assert.AreEqual "data", decrypted, "BF 1"
		  
		  e.SetKey "password2"
		  encrypted2 = e.EncryptCBC( "data" )
		  Assert.AreNotEqual encrypted, encrypted2, "BF same encryption!"
		  Assert.AreEqual "data", e.DecryptCBC( encrypted2 ), "BF 2"
		  
		  e.SetKey "password1"
		  encrypted2 = e.EncryptCBC( "data" )
		  Assert.AreSame encrypted, encrypted2, "BF inconsistent result"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetFromCodeTest()
		  dim actual as M_Crypto.Encrypter
		  dim expected as M_Crypto.Encrypter
		  dim code as string 
		  dim data as string = "data"
		  dim key as string = "password"
		  
		  code = M_Crypto.kCodeAES128CBC
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 128 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptCBC( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeAES128ECB
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 128 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptECB( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeAES192CBC
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 192 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptCBC( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeAES192ECB
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 192 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptECB( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeAES256CBC
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 256 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptCBC( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeAES256ECB
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new AES_MTC( 256 )
		  expected.SetKey key
		  Assert.AreSame expected.EncryptECB( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeBlowfishCBC
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new Blowfish_MTC
		  expected.SetKey key
		  Assert.AreSame expected.EncryptCBC( data ), actual.Encrypt( data ), code.ToText
		  
		  code = M_Crypto.kCodeBlowfishECB
		  actual = M_Crypto.GetEncrypter( code )
		  actual.SetKey key
		  expected = new Blowfish_MTC
		  expected.SetKey key
		  Assert.AreSame expected.EncryptECB( data ), actual.Encrypt( data ), code.ToText
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InvalidPaddingTest()
		  dim e as M_Crypto.Encrypter = new Blowfish_MTC( "password" )
		  dim data as string = "12345678"
		  dim pad as string
		  dim encrypted as string
		  dim decrypted as string
		  dim description as text
		  
		  description = "Nonsense padding"
		  pad = "ABCDEF01"
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		  encrypted = e.Encrypt( data + pad )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		  #pragma BreakOnExceptions false
		  try
		    decrypted = e.Decrypt( encrypted )
		    Assert.Fail description
		  catch err as M_Crypto.InvalidPaddingException
		    Assert.Pass description
		  end try
		  #pragma BreakOnExceptions default
		  
		  description = "Alternate padding"
		  pad = "12345" + ChrB( 0 ) + ChrB( 0 ) + ChrB( 3 )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		  encrypted = e.Encrypt( data + pad )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		  #pragma BreakOnExceptions false
		  try
		    decrypted = e.Decrypt( encrypted )
		    Assert.Fail description
		  catch err as M_Crypto.InvalidPaddingException
		    Assert.Pass description
		  end try
		  #pragma BreakOnExceptions default
		  
		  description = "No padding"
		  pad = ""
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		  encrypted = e.Encrypt( data + pad )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		  #pragma BreakOnExceptions false
		  try
		    decrypted = e.Decrypt( encrypted )
		    Assert.Fail description
		  catch err as M_Crypto.InvalidPaddingException
		    Assert.Pass description
		  end try
		  #pragma BreakOnExceptions default
		  
		  description = "Only padding"
		  data = ""
		  pad = ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 ) + ChrB( 8 )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		  encrypted = e.Encrypt( data + pad )
		  e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		  #pragma BreakOnExceptions false
		  try
		    decrypted = e.Decrypt( encrypted )
		    dim expected as string = ""
		    Assert.AreEqual expected, decrypted, description
		  catch err as M_Crypto.InvalidPaddingException
		    Assert.Fail description
		  end try
		  #pragma BreakOnExceptions default
		  
		  
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
