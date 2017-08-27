#tag Class
Protected Class BlowfishPKCS5Tests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub EncryptECB1BlockTest()
		  dim bf as Blowfish_MTC
		  dim data as string
		  dim expectedHex as string
		  dim encrypted as string
		  dim decrypted as string
		  
		  bf = GetBF( "password" )
		  data = "12345678"
		  expectedHex = "da6003664651d15399e68f92e83dce67"
		  encrypted = bf.EncryptECB( data )
		  Assert.AreEqual expectedHex, EncodeHex( encrypted ), "Encryption"
		  decrypted = bf.DecryptECB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreSame data, decrypted, "Decryption"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EncryptECB2BlockTest()
		  dim bf as Blowfish_MTC
		  dim data as string
		  dim expectedHex as string
		  dim encrypted as string
		  dim decrypted as string
		  
		  bf = GetBF( "password" )
		  data = "1234567890123456"
		  expectedHex = "da6003664651d153a7a2d764bd89e4bf99e68f92e83dce67"
		  encrypted = bf.EncryptECB( data )
		  Assert.AreEqual expectedHex, EncodeHex( encrypted ), "Encryption"
		  decrypted = bf.DecryptECB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreSame data, decrypted, "Decryption"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EncryptECBUnevenBlockTest()
		  dim bf as Blowfish_MTC
		  dim data as string
		  dim expectedHex as string
		  dim encrypted as string
		  dim decrypted as string
		  
		  bf = GetBF( "password" )
		  
		  data = "N"
		  expectedHex = "e21ec1d9a23d143a"
		  encrypted = bf.EncryptECB( data )
		  Assert.AreEqual expectedHex, EncodeHex( encrypted ), "Encryption of " + data.ToText
		  decrypted = bf.DecryptECB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreSame data, decrypted, "Decryption of " + data.ToText
		  
		  data = "Nope"
		  expectedHex = "e1e00849d0cd5eb9"
		  encrypted = bf.EncryptECB( data )
		  Assert.AreEqual expectedHex, EncodeHex( encrypted ), "Encryption of " + data.ToText
		  decrypted = bf.DecryptECB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreSame data, decrypted, "Decryption of " + data.ToText
		  
		  data = "NopeNopeNo"
		  expectedHex = "1fa5147ed028840603bb89b28fa91460"
		  encrypted = bf.EncryptECB( data )
		  Assert.AreEqual expectedHex, EncodeHex( encrypted ), "Encryption of " + data.ToText
		  decrypted = bf.DecryptECB( encrypted ).DefineEncoding( data.Encoding )
		  Assert.AreSame data, decrypted, "Decryption of " + data.ToText
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetBF(key As String) As Blowfish_MTC
		  return new Blowfish_MTC( key, Blowfish_MTC.Padding.PKCS5 )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitializeTest()
		  dim bf as Blowfish_MTC = GetBF( "pw" )
		  Assert.IsNotNil bf
		End Sub
	#tag EndMethod


End Class
#tag EndClass
