#tag Class
Protected Class StressTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BcryptStressTest()
		  //
		  // Stress test Bcrypt to make sure the result
		  // matches the output from PHP
		  //
		  
		  dim alphabet() as string = split( _
		  "abcdefghijklmnopqrstuvwxyz " + _
		  "!@#$%^&*()_+" + _
		  "=-/.,?><[]{}" + _
		  "¡™£¢∞§¶•ªº–≠⁄€‹›ﬁﬂ‡°·‚—±" + _
		  """'" + _
		  "œ∑áé®†¥üîøπ¬", _
		  "" )
		  
		  dim passwords() as string
		  
		  const kMinLetters = 5
		  const kMaxLetters = 15
		  const kRounds = 10
		  
		  dim r as new Random
		  
		  for letterCount as integer = kMinLetters to kMaxLetters
		    for round as integer = 1 to kRounds
		      dim wordArr() as string
		      
		      for letterIndex as integer = 1 to letterCount
		        dim randomCharIndex as integer = r.InRange( 0, alphabet.Ubound )
		        dim char as string = alphabet( randomCharIndex )
		        wordArr.Append char
		      next letterIndex
		      
		      
		      dim word as string = join( wordArr, "" )
		      passwords.Append word
		    next round
		  next letterCount
		  
		  const kMinCost = 7
		  const kMaxCost = 12
		  
		  for cost as integer = kMinCost to kMaxCost
		    dim salt as string = Bcrypt_MTC.GenerateSalt( cost )
		    
		    for i as integer = 0 to passwords.Ubound
		      dim pw as string = passwords( i )
		      dim myHash as string = Bcrypt_MTC.Hash( pw, salt )
		      Assert.IsTrue PHPVerify( pw, myHash ), "PHP does not match pw «" + pw.ToText + "», cost = " + cost.ToText
		      Assert.IsTrue Bcrypt_MTC.Verify( pw, myHash ), "Internal match failed on «" + pw.ToText + "», cost = " + cost.ToText
		    next
		  next
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlowfishStressTest()
		  //
		  // Stress test Blowfish to make sure the result
		  // matches the output from JavaScript
		  //
		  
		  dim tempFolder as FolderItem = SpecialFolder.Temporary.Child( "M_Crypto Unit Tests" )
		  tempFolder.CreateAsFolder
		  
		  dim dataAlphabet() as string = split( _
		  "abcdefghijklmnopqrstuvwxyz " + _
		  "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + _
		  "!@#$%^&*()_+" + _
		  "=-/.,?><[]{}" + _
		  "¡™£¢∞§¶•ªº", _
		  "" )
		  dim keyAlphabet() as string = split( _
		  "abcdefghijklmnopqrstuvwxyz " + _
		  "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + _
		  "!@#$%^&*()_+" + _
		  "=-/.,?><[]{}", _
		  "" )
		  
		  const kMinDataLetters = 80
		  const kMaxDataLetters = 100
		  const kMinKeyLetters = 1
		  const kMaxKeyLetters = 10
		  
		  dim r as new Random
		  dim sh as new Shell
		  sh.Execute "bash -lc 'which node'"
		  dim node as string = sh.Result.Trim
		  node = node.NthField( EndOfLine.UNIX, node.CountFields( EndOfLine.UNIX ) )
		  
		  sh = new Shell
		  
		  for keyCount as integer = kMinKeyLetters to kMaxKeyLetters
		    //
		    // Create a random key
		    //
		    dim keyArr() as string
		    dim keyLen as integer
		    while keyLen < keyCount
		      dim letter as string = keyAlphabet( r.InRange( 0, keyAlphabet.Ubound ) )
		      keyArr.Append letter
		      keyLen = keyLen + 1
		    wend
		    dim key as string = join( keyArr, "" )
		    dim jsKey as string = key.ReplaceAll( "'", "\'" )
		    
		    dim bf as new Blowfish_MTC( Crypto.MD5( key ), Blowfish_MTC.Padding.PKCS )
		    
		    for dataCount as integer = kMinDataLetters to kMaxDataLetters
		      
		      dim dataArr() as string
		      dim dataLen as integer
		      while dataLen < dataCount
		        dim letter as string = dataAlphabet( r.InRange( 0, dataAlphabet.Ubound ) )
		        dataArr.Append letter
		        dataLen = dataLen + 1
		      wend
		      dim data as string = join( dataArr, "" )
		      dim jsData as string = data.ReplaceAll( "'", "\'" )
		      
		      //
		      // Create the Encrypt file
		      //
		      dim tos as TextOutputStream
		      dim jsEncrypt as FolderItem = tempFolder.Child( "encrypt.js" )
		      jsEncrypt.Delete
		      tos = TextOutputStream.Create( jsEncrypt )
		      tos.Write kJavaScriptEncryptECB.ReplaceAll( "%key%", jsKey ).ReplaceAll( "%data%", jsData )
		      tos.Close
		      
		      sh.Execute node + " " + jsEncrypt.ShellPath
		      dim nativeEncrypted as string = EncodeHex( bf.EncryptECB( data ) )
		      dim jsEncrypted as string = sh.Result.Trim
		      
		      Assert.AreEqual jsEncrypted, nativeEncrypted, "Encryption doesn't match for key «" + key.ToText + "» and data «" + data.ToText + "»"
		      
		      //
		      // Create the Decrypt file
		      //
		      dim jsDecrypt as FolderItem = tempFolder.Child( "decrypt.js" )
		      jsDecrypt.Delete
		      tos = TextOutputStream.Create( jsDecrypt )
		      tos.Write kJavaScriptDecryptECB.ReplaceAll( "%key%", jsKey ).ReplaceAll( "%data%", nativeEncrypted )
		      tos.Close
		      
		      sh.Execute node + " " + jsDecrypt.ShellPath
		      dim nativeDecrypted as string = bf.DecryptECB( DecodeHex( jsEncrypted ) )
		      dim jsDecrypted as string = sh.Result.ReplaceAll( EndOfLine, "" )
		      
		      Assert.AreEqual data, nativeDecrypted, "Native decryption doesn't match for key «" + key.ToText + "» and data «" + data.ToText + "»"
		      
		      Assert.AreEqual data, jsDecrypted, "JS decryption doesn't match for key «" + key.ToText + "» and data «" + data.ToText + "»"
		      
		      jsEncrypt.Delete
		      jsDecrypt.Delete
		    next dataCount
		  next keyCount
		  
		  tempFolder.Delete
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LongBlockEncryptTest()
		  self.StopTestOnFail = true
		  
		  dim encrypters() as M_Crypto.Encrypter
		  encrypters.Append new Blowfish_MTC
		  encrypters.Append new AES_MTC( 128 )
		  encrypters.Append new AES_MTC( 192 )
		  encrypters.Append new AES_MTC( 256 )
		  
		  for each e as M_Crypto.Encrypter in encrypters
		    e.UseFunction = M_Crypto.Encrypter.Functions.CBC
		    e.SetKey "password"
		  next
		  
		  dim paddings() as M_Crypto.Encrypter.Padding
		  paddings.Append M_Crypto.Encrypter.Padding.NullsWithCount
		  paddings.Append M_Crypto.Encrypter.Padding.PKCS
		  paddings.Append M_Crypto.Encrypter.Padding.NullsOnly // Must be last
		  
		  dim r as new Random
		  
		  const kMaxTextLength as integer = 127
		  
		  dim kCharMinCode as integer = 0
		  dim kCharMaxCode as integer = 128
		  
		  dim builder() as string
		  for i as integer = 1 to kMaxTextLength
		    builder.Append Chr( r.InRange( kCharMinCode, kCharMaxCode ) )
		  next
		  
		  const kRounds as integer = 80
		  
		  for round as integer = 1 to kRounds
		    for textLength as integer = 64 to kMaxTextLength
		      //
		      // Change the text of the builder
		      //
		      for spots as integer = 1 to ( kMaxTextLength \ 2 )
		        dim builderIndex as integer = r.InRange( 0, textLength - 1 )
		        builder( builderIndex ) = Chr( r.InRange( kCharMinCode, kCharMaxCode ) )
		      next
		      
		      dim longText as string = join( builder, "" )
		      longText = longText.LeftB( textLength )
		      
		      for each p as M_Crypto.Encrypter.Padding in paddings
		        for each e as M_Crypto.Encrypter in encrypters
		          e.PaddingMethod = p
		          
		          dim stepper as integer = e.BlockSize * 4
		          
		          dim original as string = longText
		          if p = M_Crypto.Encrypter.Padding.NullsOnly and original.RightB( 1 ).AscB = 0 then
		            //
		            // There is no way that would work right anyway
		            //
		            original = original.LeftB( original.LenB - 1 ) + "A"
		          end if
		          
		          dim originalHex as string = EncodeHex( original )
		          
		          
		          dim encryptedArr() as string 
		          for chunkIndex as integer = 1 to original.LenB step stepper
		            dim chunk as string = original.MidB( chunkIndex, stepper )
		            encryptedArr.Append e.Encrypt( chunk, chunkIndex > ( original.LenB - stepper ) )
		          next chunkIndex
		          dim encrypted as string = join( encryptedArr, "" )
		          
		          dim decryptedArr() as string
		          for chunkIndex as integer = 1 to encrypted.LenB step stepper
		            dim chunk as string = encrypted.MidB( chunkIndex, stepper )
		            decryptedArr.Append e.Decrypt( chunk, chunkIndex > encrypted.LenB - stepper )
		          next chunkIndex
		          dim decrypted as string = join( DecryptedArr, "" )
		          decrypted = decrypted.DefineEncoding( original.Encoding )
		          dim decryptedHex as string = EncodeHex( decrypted )
		          Assert.AreEqual originalHex, decryptedHex, Xojo.Introspection.GetType( e ).Name + _
		          if( e isa AES_MTC, "-" +AES_MTC( e ).Bits.ToText, "" ) + _
		          ", padding: " + Integer( p ).ToText + ", length: " + textLength.ToText
		        next e
		      next p
		      
		    next textLength
		  next round
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PHPVerify(key As String, againstHash As String) As Boolean
		  dim r as boolean
		  
		  key = key.ReplaceAll( "'", "\'" )
		  againstHash = againstHash.ReplaceAll( "'", "\'" )
		  
		  dim cmd as string = "$key = '%key%' ; $hash = '%hash%' ; if ( password_verify( $key, $hash ) ) { print 'true'; } else { print 'false' ; } ;"
		  cmd = cmd.ReplaceAll( "%key%", key )
		  cmd = cmd.ReplaceAll( "%hash%", againstHash )
		  
		  r = M_PHP.Execute( cmd ) = "true"
		  
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ScryptStressTest()
		  dim actual as MemoryBlock 
		  dim expected as MemoryBlock 
		  
		  actual = Scrypt_MTC.Hash( "pleaseletmein", "SodiumChloride", 20, 64, 8, 1 )
		  expected = DecodeHex( kScryptOutHex3 )
		  Assert.AreEqual expected, actual
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kJavaScriptDecryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar decipher \x3D crypto.createDecipher(\'bf-ecb\'\x2C key);\n\nvar dec \x3D decipher.update(data\x2C \'hex\'\x2C \'utf8\');\ndec +\x3D decipher.final(\'utf8\');\n\nconsole.log(dec);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJavaScriptEncryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar cipher \x3D crypto.createCipher(\'bf-ecb\'\x2C key);\n\nvar enc \x3D cipher.update(data\x2C \'utf8\'\x2C \'hex\');\nenc +\x3D cipher.final(\'hex\');\n\nconsole.log(enc);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kScryptOutHex3, Type = String, Dynamic = False, Default = \"21 01 cb 9b 6a 51 1a ae ad db be 09 cf 70 f8 81\nec 56 8d 57 4a 2f fd 4d ab e5 ee 98 20 ad aa 47\n8e 56 fd 8f 4b a5 d0 9f fa 1c 6d 92 7c 40 f4 c3\n37 30 40 49 e8 a9 52 fb cb f4 5c 6f a7 7a 41 a4", Scope = Private
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
