#tag Window
Begin Window WndEncryption
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   410277764
   MenuBarVisible  =   True
   MinHeight       =   400
   MinimizeButton  =   True
   MinWidth        =   694
   Placement       =   0
   Resizeable      =   True
   Title           =   "Encryption"
   Visible         =   True
   Width           =   694
   Begin PushButton btnTest
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Do It"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   594
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   16
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin TextArea fldResult
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   204
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   176
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   654
   End
   Begin TextField fldKey
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   22
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   False
      Left            =   98
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "password"
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   14
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   127
   End
   Begin Label lblLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   0
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      Text            =   "Password:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   16
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin PopupMenu mnuTests
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   ""
      Italic          =   False
      Left            =   364
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   15
      Underline       =   False
      Visible         =   True
      Width           =   218
   End
   Begin Label lblLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   1
      InitialParent   =   ""
      Italic          =   False
      Left            =   312
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      Text            =   "Test:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin Label lblLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   21
      HelpTag         =   ""
      Index           =   2
      InitialParent   =   ""
      Italic          =   False
      Left            =   46
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      Text            =   "Data:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   47
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   40
   End
   Begin TextArea fldData
      AcceptTabs      =   False
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   True
      BackColor       =   &cFFFFFF00
      Bold            =   False
      Border          =   True
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   85
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   98
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   True
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "This is some data to encrypt. The data should really be in blocks of eight bytes, as this is, but the engine will pad in case it is not."
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   46
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   576
   End
   Begin Label lblLabel
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   21
      HelpTag         =   ""
      Index           =   3
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   11
      TabPanelIndex   =   0
      Text            =   "Result:"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   143
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   89
   End
   Begin PushButton btnClear
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Clear"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   594
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   143
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin CheckBox cbMD5
      AutoDeactivate  =   True
      Bold            =   False
      Caption         =   "MD5"
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   237
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      State           =   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   16
      Underline       =   False
      Value           =   False
      Visible         =   True
      Width           =   63
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  if zTempFolder isa FolderItem then
		    dim files() as FolderItem
		    dim cnt as integer = zTempFolder.Count
		    for i as integer = 1 to cnt
		      files.Append zTempFolder.Item( i )
		    next
		    
		    for i as integer = files.Ubound downto 0
		      files( i ).Delete
		    next
		    
		    zTempFolder.Delete
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddToResult(msg As String)
		  fldResult.AppendText msg
		  fldResult.AppendText EndOfLine
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BcryptStressTest()
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
		  const kRounds = 50
		  
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
		    AddToResult "Cost: " + str( cost )
		    
		    dim salt as string = Bcrypt_MTC.GenerateSalt( cost )
		    
		    for each pw as string in passwords
		      dim myHash as string = Bcrypt_MTC.Bcrypt( pw, salt )
		      if not PHPVerify( pw, myHash ) then
		        AddToResult "PHP no match: " + pw
		      elseif not Bcrypt_MTC.Verify( pw, myHash ) then
		        AddToResult "Internal no match: " + pw
		      end if
		      if UserCancelled then
		        AddToResult "Cancelled"
		        exit for cost
		      end if
		    next
		    fldResult.Refresh
		  next
		  
		  AddToResult "Bcrypt Stress Test Finished"
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BlowfishStressTest()
		  //
		  // Stress test Blowfish to make sure the result
		  // matches the output from JavaScript
		  //
		  
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
		  
		  const kMinDataLetters = 1
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
		    
		    dim bf as new Blowfish_MTC( Crypto.MD5( key ), Blowfish_MTC.Padding.PKCS5 )
		    
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
		      dim jsEncrypt as FolderItem = TempFolder.Child( "encrypt.js" )
		      jsEncrypt.Delete
		      tos = TextOutputStream.Create( jsEncrypt )
		      tos.Write kJavaScriptEncryptECB.ReplaceAll( "%key%", jsKey ).ReplaceAll( "%data%", jsData )
		      tos.Close
		      
		      sh.Execute node + " " + jsEncrypt.ShellPath
		      dim nativeEncrypted as string = EncodeHex( bf.EncryptECB( data ) )
		      dim jsEncrypted as string = sh.Result.Trim
		      
		      if nativeEncrypted <> jsEncrypted then
		        AddToResult "Encryption doesn't match for key «" + key + "» and data «" + data + "»"
		      end if
		      
		      //
		      // Create the Decrypt file
		      //
		      dim jsDecrypt as FolderItem = TempFolder.Child( "decrypt.js" )
		      jsDecrypt.Delete
		      tos = TextOutputStream.Create( jsDecrypt )
		      tos.Write kJavaScriptDecryptECB.ReplaceAll( "%key%", jsKey ).ReplaceAll( "%data%", nativeEncrypted )
		      tos.Close
		      
		      sh.Execute node + " " + jsDecrypt.ShellPath
		      dim nativeDecrypted as string = bf.DecryptECB( DecodeHex( jsEncrypted ) )
		      dim jsDecrypted as string = sh.Result.ReplaceAll( EndOfLine, "" )
		      
		      if StrComp( nativeDecrypted, data, 0 ) <> 0 then
		        AddToResult "Native decryption doesn't match for key «" + key + "» and data «" + data + "», " + _
		        "returned «" + nativeDecrypted.DefineEncoding( Encodings.UTF8 ) + "»"
		        'continue for dataCount
		      end if
		      
		      if StrComp( jsDecrypted, data, 0 ) <> 0 then
		        AddToResult "JS decryption doesn't match for key «" + key + "» and data «" + data + "», " + _
		        "returned «" + jsDecrypted.DefineEncoding( Encodings.UTF8 ) + "»"
		        'continue for dataCount
		      end if
		      
		    next dataCount
		  next keyCount
		  
		  AddToResult "Blowfish Stress Test Finished"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PHPVerify(key As String, againstHash As String) As Boolean
		  dim r as boolean
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  
		  key = key.ReplaceAll( "'", "\'" )
		  againstHash = againstHash.ReplaceAll( "'", "\'" )
		  
		  dim cmd as string = "$key = '%key%' ; $hash = '%hash%' ; if ( password_verify( $key, $hash ) ) { print 'true'; } else { print 'false' ; } ;"
		  cmd = cmd.ReplaceAll( "%key%", key )
		  cmd = cmd.ReplaceAll( "%hash%", againstHash )
		  
		  r = M_PHP.Execute( cmd ) = "true"
		  
		  sw.Stop
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TempFolder() As FolderItem
		  if zTempFolder is nil then
		    zTempFolder = SpecialFolder.Temporary.Child( "Blowfish_Harness_Temp" )
		    zTempFolder.CreateAsFolder
		  end if
		  
		  return zTempFolder
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestBcrypt(key As String, salt As String, sw As Stopwatch_MTC)
		  AddToResult "Salt: " + salt
		  sw.Start
		  dim hash as string = Bcrypt_MTC.Bcrypt( key, salt )
		  sw.Stop
		  AddToResult "Hash: " + hash
		  
		  // See if we can compare PHP
		  dim phpHash as string = M_PHP.Bcrypt( key, salt )
		  AddToResult "PHP: " + phpHash
		  
		  if StrComp( hash, phpHash, 0 ) = 0 then
		    AddToResult "(they match)"
		  else
		    AddToResult "(NO MATCH!!)"
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private zTempFolder As FolderItem
	#tag EndProperty


	#tag Constant, Name = kJavaScriptDecryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar decipher \x3D crypto.createDecipher(\'bf-ecb\'\x2C key);\n\nvar dec \x3D decipher.update(data\x2C \'hex\'\x2C \'utf8\');\ndec +\x3D decipher.final(\'utf8\');\n\nconsole.log(dec);\n", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kJavaScriptEncryptECB, Type = String, Dynamic = False, Default = \"var crypto \x3D require(\'crypto\');\nvar key \x3D \'%key%\';\nvar data \x3D \'%data%\';\nvar cipher \x3D crypto.createCipher(\'bf-ecb\'\x2C key);\n\nvar enc \x3D cipher.update(data\x2C \'utf8\'\x2C \'hex\');\nenc +\x3D cipher.final(\'hex\');\n\nconsole.log(enc);\n", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events btnTest
	#tag Event
		Sub Action()
		  const kVector as string = "0123456789ABCDEF"
		  
		  dim data as string = fldData.Text
		  dim key as string = fldKey.Text
		  if cbMD5.Value then
		    key = Crypto.MD5( key )
		  end if
		  dim salt as string = "$2y$10$1234567890123456789012" // For bcrypt
		  
		  dim blf as new Blowfish_MTC( key )
		  dim sw as new Stopwatch_MTC
		  
		  if fldResult.Text.LenB <> 0 then
		    AddToResult "---"
		  end if
		  AddToResult "Testing: " + mnuTests.List( mnuTests.ListIndex )
		  
		  select case mnuTests.ListIndex
		  case 0 // Encrypt
		    sw.Start
		    data = blf.Encrypt( data )
		    sw.Stop
		    AddToResult "Encrypted: " + EncodeHex( data, true )
		    sw.Start
		    data = blf.Decrypt( data )
		    sw.Stop
		    AddToResult "Decrypted: " + data
		    
		  case 1 // ECB
		    sw.Start
		    data = blf.EncryptECB( data )
		    sw.Stop
		    AddToResult "Encrypted: " + EncodeHex( data, true )
		    sw.Start
		    data = blf.DecryptECB( data )
		    sw.Stop
		    AddToResult "Decrypted: " + data
		    
		  case 2 // CBC
		    sw.Start
		    blf.PaddingMethod = Blowfish_MTC.Padding.PKCS5
		    data = blf.EncryptCBC( data )
		    sw.Stop
		    AddToResult "Encrypted: " + EncodeHex( data, true )
		    sw.Start
		    data = blf.DecryptCBC( data )
		    sw.Stop
		    AddToResult "Decrypted: " + data
		    
		  case 3 // Chained
		    // Will break up the text into blocks of eight and pad the last block.
		    // Simulates reading from a file or stream.
		    dim byteIndex as integer = 1
		    dim encrypted as string
		    blf.PaddingMethod = Blowfish_MTC.Padding.PKCS5
		    while byteIndex <= data.LenB
		      dim block as string = data.MidB( byteIndex, 8 )
		      byteIndex = byteIndex + 8
		      sw.Start
		      encrypted = encrypted + blf.EncryptCBC( block, byteIndex > data.LenB )
		      sw.Stop
		    wend
		    AddToResult "Encrypted: " + EncodeHex( encrypted, true )
		    
		    byteIndex = 1
		    data = ""
		    blf.PaddingMethod = Blowfish_MTC.Padding.PKCS5
		    while byteIndex <= encrypted.LenB
		      dim block as string = encrypted.MidB( byteIndex, 8 )
		      byteIndex = byteIndex + 8
		      sw.Start
		      data = data + blf.DecryptCBC( block, byteIndex > encrypted.LenB )
		      sw.Stop
		    wend
		    AddToResult "Decrypted: " + data
		    
		  case 4 // Chained, modified vector
		    // Same as chained, but starting with a different vector.
		    dim byteIndex as integer = 1
		    dim encrypted as string
		    dim block as string
		    
		    dim vector as string = kVector // Don't need to do this, but if you do, be sure to store the vector for decryption
		    // You can supply either an 8-byte string or hex representing 8 bytes
		    blf.SetVector( vector )
		    blf.PaddingMethod = Blowfish_MTC.Padding.PKCS5
		    while byteIndex <= data.LenB
		      block = data.MidB( byteIndex, 8 )
		      byteIndex = byteIndex + 8
		      sw.Start
		      encrypted = encrypted + blf.EncryptCBC( block, byteIndex > data.LenB ) // The last vector will be retained until isFinalBlock is true or ResetVector or SetVector is called
		      sw.Stop
		    wend
		    AddToResult "Encrypted: " + EncodeHex( encrypted, true )
		    
		    byteIndex = 1
		    data = ""
		    while byteIndex <= encrypted.LenB
		      block = encrypted.MidB( byteIndex, 8 )
		      byteIndex = byteIndex + 8
		      sw.Start
		      data = data + blf.DecryptCBC( block, byteIndex > encrypted.LenB )
		      sw.Stop
		    wend
		    AddToResult "Decrypted: " + data
		    
		  case 6 // Bcrypt
		    TestBcrypt( key, salt, sw )
		    
		  case 7 // Generate Salt
		    sw.Start
		    AddToResult Bcrypt_MTC.GenerateSalt( 6 )
		    AddToResult Bcrypt_MTC.GenerateSalt( 10, Bcrypt_MTC.Prefix.Y )
		    sw.Stop
		    
		  case 8 // Verify
		    dim hash as string = "$2a$10$123456789012345678901uRYpa/ge9OYdnnseqfe9ZYWxLa1GUiyi"
		    dim pw as string = "password"
		    sw.Start
		    dim verified as boolean = Bcrypt_MTC.Verify( pw, hash )
		    sw.Stop
		    
		    if verified then
		      AddToResult "Verified"
		    else
		      AddToResult "VERIFICATION FAILED!"
		    end if
		    
		  case 10 // Bcrypt stress test
		    BcryptStressTest
		    
		  case 11 // Blowfish stress test
		    BlowfishStressTest
		    
		  else
		    AddToResult "Unrecognized Index: " + str( mnuTests.ListIndex )
		    
		  end select
		  
		  AddToResult " "
		  AddToResult "Elapsed Milliseconds: " + format( sw.ElapsedMilliseconds, "#,0.###" )
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuTests
	#tag Event
		Sub Open()
		  // Construct tests here
		  
		  dim tests() as string = Array( _
		  "Encrypt / Decrypt", _
		  "EncryptECB / DecryptECB", _
		  "EncryptCBC / DecryptCBC", _
		  "EcryptCBC / DecryptCBC (chained)", _
		  "EncryptCBC / DecryptCBC (chained, modified vector)", _
		  "-", _
		  "Bcrypt", _
		  "Generate Salt", _
		  "Verify", _
		  "-", _
		  "Bcrypt Stress Test", _
		  "Blowfish Stress Test" _
		  )
		  
		  me.AddRows tests
		  me.ListIndex = 0
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnClear
	#tag Event
		Sub Action()
		  fldResult.Text = ""
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
