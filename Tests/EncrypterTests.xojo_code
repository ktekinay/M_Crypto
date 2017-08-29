#tag Class
Protected Class EncrypterTests
Inherits TestGroup
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
		  
		  e = new Blowfish_MTC
		  
		  e.SetKey "password1"
		  encrypted = e.EncryptCBC( "data" )
		  decrypted = e.DecryptCBC( encrypted )
		  Assert.AreEqual "data", decrypted, "BF 1"
		  
		  e.SetKey "password2"
		  encrypted2 = e.EncryptCBC( "data" )
		  Assert.AreNotEqual encrypted, encrypted2, "BF same encryption!"
		  Assert.AreEqual "data", e.DecryptCBC( encrypted2 ), "BF 2"
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
