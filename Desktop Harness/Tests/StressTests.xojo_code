#tag Class
Protected Class StressTests
Inherits EncrypterTestGroup
	#tag Method, Flags = &h0
		Sub AESCBCTimingTest()
		  //
		  // Timing test
		  //
		  
		  const kRounds = 1000
		  const kFormat as text = "#,###,###,##0.0###"
		  
		  dim loc as Xojo.Core.Locale = Xojo.Core.Locale.Current
		  
		  dim e as new AES_MTC( 256 )
		  e.UseFunction = AES_MTC.Functions.CBC
		  e.SetKey Crypto.SHA256( "Some password" )
		  
		  dim s as string = kLongData
		  Assert.Message "Data is " + s.Bytes.ToText( loc, "#,###,##0" ) + " bytes"
		  Assert.Message "Using " + kRounds.ToText( loc, "#,###,##0" ) + " rounds"
		  
		  dim sw as new Stopwatch_MTC
		  
		  dim encrypted as string
		  for i as integer = 1 to kRounds
		    sw.Start
		    StartProfiling
		    encrypted = e.Encrypt( s )
		    StopProfiling
		    sw.Stop
		  next
		  
		  Assert.Message "Encryption took " + sw.ElapsedMilliSeconds.ToText( loc, kFormat ) + "  ms"
		  sw.Reset
		  
		  dim decrypted as string
		  for i as integer = 1 to kRounds
		    sw.Start
		    StartProfiling
		    decrypted = e.Decrypt( encrypted )
		    StopProfiling
		    sw.Stop
		  next
		  
		  Assert.Message "Decryption took " + sw.ElapsedMilliSeconds.ToText( loc, kFormat ) + "  ms"
		  
		  decrypted = decrypted.DefineEncoding( s.Encoding )
		  Assert.AreSame( s, decrypted )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AESECBTimingTest()
		  //
		  // Timing test
		  //
		  
		  const kRounds = 1000
		  const kFormat as text = "#,###,###,##0.0###"
		  
		  dim loc as Xojo.Core.Locale = Xojo.Core.Locale.Current
		  
		  dim e as new AES_MTC( 256 )
		  e.UseFunction = AES_MTC.Functions.ECB
		  e.SetKey Crypto.SHA256( "Some password" )
		  
		  dim s as string = kLongData
		  Assert.Message "Data is " + s.Bytes.ToText( loc, "#,###,##0" ) + " bytes"
		  Assert.Message "Using " + kRounds.ToText( loc, "#,###,##0" ) + " rounds"
		  
		  dim sw as new Stopwatch_MTC
		  
		  dim encrypted as string
		  for i as integer = 1 to kRounds
		    sw.Start
		    StartProfiling
		    encrypted = e.Encrypt( s )
		    StopProfiling
		    sw.Stop
		  next
		  
		  Assert.Message "Encryption took " + sw.ElapsedMilliSeconds.ToText( loc, kFormat ) + "  ms"
		  sw.Reset
		  
		  dim decrypted as string
		  for i as integer = 1 to kRounds
		    sw.Start
		    StartProfiling
		    decrypted = e.Decrypt( encrypted )
		    StopProfiling
		    sw.Stop
		  next
		  
		  Assert.Message "Decryption took " + sw.ElapsedMilliSeconds.ToText( loc, kFormat ) + "  ms"
		  
		  decrypted = decrypted.DefineEncoding( s.Encoding )
		  Assert.AreSame( s, decrypted )
		  
		End Sub
	#tag EndMethod

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
		Sub BcryptTimingTest()
		  //
		  // Times Bcrypt as compared to PHP
		  //
		  
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  const kPassword as string = "password"
		  const kRounds as integer = 20
		  const kCost as integer = 12
		  
		  dim pwArr() as string
		  pwArr.Append kPassword + kPassword + kPassword
		  for i as integer = 3 to kRounds
		    pwArr.Append kPassword + pwArr( 0 ).Left( i )
		  next
		  pwArr.Append kPassword
		  Assert.AreEqual kRounds, CType( pwArr.Ubound, integer ) + 1, "Password array count does not match"
		  
		  Assert.Message "Rounds: " + kRounds.ToText + ", Cost: " + kCost.ToText
		  
		  dim phpScript as string = kBcryptTimingScript
		  phpScript = phpScript.Replace( "%rounds%", str( kRounds ) )
		  phpScript = phpScript.Replace( "%cost%", str( kCost ) )
		  phpScript = phpScript.Replace( "%pw_list%", "'" + join( pwArr, "', '" ) + "'" )
		  
		  System.DebugLog phpScript
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  dim phpHash as string = M_PHP.Execute( phpScript )
		  sw.Stop
		  
		  phpHash = ReplaceLineEndings( phpHash, EndOfLine )
		  dim phpHashes() as string = split( phpHash, EndOfLine )
		  Assert.AreEqual pwArr.Ubound, phpHashes.Ubound, "PHP hash list does not match pwArr"
		  
		  dim avgMs as double = sw.ElapsedMilliseconds / CType( kRounds, Double )
		  sw.Reset
		  
		  Assert.Message "PHP: " + avgMs.ToText + " ms per round"
		  
		  for i as integer = 0 to phpHashes.Ubound
		    Assert.IsTrue BCrypt_MTC.Verify( pwArr( i ), phpHashes( i ) ), "Verifying PHP hash on " + pwArr( i ).ToText
		  next
		  
		  dim nativeHash as string
		  
		  sw.Start
		  StartProfiling
		  nativeHash = Bcrypt_MTC.Hash( kPassword, kCost )
		  StopProfiling
		  sw.Stop
		  
		  Assert.Message "Bcrypt_MTC (once) : " + sw.ElapsedMilliseconds.ToText + " ms"
		  sw.Reset
		  
		  for i as integer = 0 to pwArr.UBound
		    dim pw as string = pwArr( i )
		    sw.Start
		    nativeHash = Bcrypt_MTC.Hash( pw, kCost )
		    sw.Stop
		  next
		  
		  avgMs = sw.ElapsedMilliseconds / CType( kRounds, Double )
		  
		  Assert.Message "Bcrypt_MTC: " + avgMs.ToText + " ms per round"
		  Assert.IsTrue PHPVerify( kPassword, nativeHash )
		  
		  Assert.Message "Calculated on: " + &u0A + join( pwArr, EndOfLine ).ToText
		  
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
		    
		    dim bf as new Blowfish_MTC( key, Blowfish_MTC.Padding.PKCS )
		    
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
		Sub CompareToOpenSSLTest()
		  //
		  // Compares results to openssl
		  //
		  
		  #if TargetWindows then
		    //
		    // Need openssl
		    //
		    return
		  #endif
		  
		  //
		  // We are going to use the same key and iv
		  //
		  const kKeyHex as string = "000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f"
		  const kIVHex as string = "0123456789abcdeffedcba9876543210"
		  
		  dim key as string = DecodeHex( kKeyHex )
		  dim iv as string = DecodeHex( kIVHex )
		  dim data as string = kLongData
		  while ( data.Len mod 16 ) <> 0 
		    data = data + str( data.Len mod 16 )
		  wend
		  
		  //
		  // Get the openssl tool
		  //
		  dim openssl as string = GetCommand( "openssl" )
		  Assert.IsTrue openssl <> "", "Cannot locate openssl"
		  if openssl = "" then
		    return
		  end if
		  
		  Assert.Pass "Using " + openssl.ToText
		  
		  dim b64 as string = GetCommand( "base64" )
		  Assert.IsTrue b64 <> "", "Cannot locate base64"
		  if b64 = "" then
		    return
		  end if
		  
		  //
		  // Set standard switches
		  //
		  dim baseCmd as string = _
		  "echo -n '" + EncodeBase64( data, 0 ) + "' | " + _
		  b64 + " --decode | " + _
		  openssl + " enc -nosalt -nopad -a -A "
		  
		  //
		  // Data will be given in Base64, and
		  // results will be in Base64
		  //
		  
		  dim ciphers() as string = array( _
		  M_Crypto.kCodeBlowfishCFB, _
		  M_Crypto.kCodeBlowfishCBC, _
		  M_Crypto.kCodeBlowfishECB, _
		  M_Crypto.kCodeBlowfishOFB, _
		  _
		  M_Crypto.kCodeAES128CBC, _
		  M_Crypto.kCodeAES128CFB, _
		  M_Crypto.kCodeAES128ECB, _
		  M_Crypto.kCodeAES128OFB, _
		  _
		  M_Crypto.kCodeAES192CBC, _
		  M_Crypto.kCodeAES192CFB, _
		  M_Crypto.kCodeAES192ECB, _
		  M_Crypto.kCodeAES192OFB, _
		  _
		  M_Crypto.kCodeAES256CBC, _
		  M_Crypto.kCodeAES256CFB, _
		  M_Crypto.kCodeAES256ECB, _
		  M_Crypto.kCodeAES256OFB _
		  )
		  
		  dim sh as new Shell
		  
		  for each cipher as string in ciphers
		    dim e as M_Crypto.Encrypter = M_Crypto.GetEncrypter( cipher )
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		    
		    dim cmd as string = baseCmd + "-" + cipher
		    if cipher.InStr( "ecb" ) = 0 then
		      iv = kIVHex.Left( e.BLockSize * 2 )
		      dim ivSwitch as string = " -iv " + iv
		      cmd = cmd + ivSwitch
		    else
		      iv = ""
		    end if
		    
		    dim thisKey as string
		    if cipher.Left( 3 ) = "bf-" then
		      thisKey = kKeyHex.Left( 32 )
		    elseif cipher.InStr( "128" ) <> 0 then
		      thisKey = kKeyHex.Left( 32 )
		    elseif cipher.InStr( "192" ) <> 0 then
		      thisKey = kKeyHex.Left( 48 )
		    else 
		      thisKey = kKeyHex
		    end if
		    
		    cmd = cmd + " -K " + thisKey
		    
		    sh.Execute cmd
		    if sh.ErrorCode <> 0 then
		      Assert.Fail "Could not execute cipher " + cipher.ToText
		      continue
		    end if
		    
		    dim expected as string = sh.Result.DefineEncoding( Encodings.UTF8 ).Trim
		    expected = ReplaceLineEndings( expected, "" )
		    
		    e.SetKey DecodeHex( thisKey )
		    e.SetInitialVector iv
		    
		    dim actual as string
		    #pragma BreakOnExceptions false
		    try
		      actual = e.Encrypt( data )
		    catch err as M_Crypto.UnsupportedFunctionException
		      Assert.Fail cipher.ToText + " not implemented"
		      #pragma BreakOnExceptions default
		      continue
		    end try
		    #pragma BreakOnExceptions default 
		    
		    actual = EncodeBase64( actual, 0 )
		    
		    if expected = actual then
		      Assert.Pass cipher.ToText + " passed"
		    else
		      Assert.AreEqual expected.Left( 6 ) + "..." + expected.Right( 6 ), _
		      actual.Left( 6 ) + "..." + actual.Right( 6), _
		      cipher.ToText
		    end if
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCommand(cmd As String) As String
		  dim sh as new Shell
		  sh.Execute "bash -l -c 'which " + cmd + "'"
		  if sh.ErrorCode <> 0 then
		    return ""
		  end if
		  
		  dim tool as string = sh.Result.DefineEncoding( Encodings.UTF8 ).Trim
		  tool = ReplaceLineEndings( tool, &uA )
		  tool = tool.NthField( &uA, tool.CountFields( &uA ) )
		  return tool
		  
		End Function
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


	#tag Constant, Name = kBcryptTimingScript, Type = String, Dynamic = False, Default = \"$options \x3D [ \'cost\' \x3D> %cost% ];\n$pwlist \x3D [%pw_list%];\n$hash \x3D [];\nforeach ($pwlist as $pw) {\n  $hash[] \x3D password_hash ( $pw\x2C PASSWORD_BCRYPT\x2C $options );\n};\necho implode(\"\\n\"\x2C $hash);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJavaScriptDecryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar decipher \x3D crypto.createDecipheriv(\'bf-ecb\'\x2C key\x2C null);\n\nvar dec \x3D decipher.update(data\x2C \'hex\'\x2C \'utf8\');\ndec +\x3D decipher.final(\'utf8\');\n\nconsole.log(dec);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJavaScriptEncryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar cipher \x3D crypto.createCipheriv(\'bf-ecb\'\x2C key\x2C null);\n\nvar enc \x3D cipher.update(data\x2C \'utf8\'\x2C \'hex\');\nenc +\x3D cipher.final(\'hex\');\n\nconsole.log(enc);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kScryptOutHex3, Type = String, Dynamic = False, Default = \"21 01 cb 9b 6a 51 1a ae ad db be 09 cf 70 f8 81\nec 56 8d 57 4a 2f fd 4d ab e5 ee 98 20 ad aa 47\n8e 56 fd 8f 4b a5 d0 9f fa 1c 6d 92 7c 40 f4 c3\n37 30 40 49 e8 a9 52 fb cb f4 5c 6f a7 7a 41 a4", Scope = Private
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
