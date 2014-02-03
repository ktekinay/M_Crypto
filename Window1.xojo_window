#tag Window
Begin Window Window1
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
   MinWidth        =   600
   Placement       =   0
   Resizeable      =   True
   Title           =   "Blowfish MTC"
   Visible         =   True
   Width           =   600
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
      Left            =   500
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
      Top             =   15
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
      Height          =   211
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
      Top             =   169
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   560
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
      Top             =   13
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   137
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
      Top             =   15
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
      Left            =   299
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
      Width           =   163
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
      Left            =   247
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
      Top             =   16
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
      Width           =   482
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
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h0
		Sub AddToResult(msg As String)
		  fldResult.AppendText msg
		  fldResult.AppendText EndOfLine
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pPHPCommand() As String
		  #if not TargetWin32
		    dim sh as new Shell
		    sh.Execute "which php"
		    return sh.Result.Trim
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pTestBcrypt(key As String, salt As String, sw As Stopwatch_MTC)
		  AddToResult "Salt: " + salt
		  sw.Start
		  dim hash as string = Bcrypt_MTC.Bcrypt( key, salt )
		  sw.Stop
		  AddToResult "Hash: " + hash
		  
		  // See if we can compare PHP
		  dim php as string = pPHPCommand
		  if php <> "" then
		    key = key.ReplaceAll( "'", "'\\\''" )
		    
		    dim cmd as string = "$key = '%key%' ; $salt = '%salt%' ; print crypt( $key, $salt ) ;"
		    cmd = cmd.ReplaceAll( "'", "'\''" )
		    cmd = cmd.ReplaceAll( "%key%", key )
		    cmd = cmd.ReplaceAll( "%salt%", salt )
		    
		    dim sh as new Shell
		    sh.Execute(  php, "-r '" + cmd + "'" )
		    dim phpHash as string = sh.Result.Trim
		    AddToResult "PHP: " + phpHash
		    
		    if StrComp( hash, phpHash, 0 ) = 0 then
		      AddToResult "(they match)"
		    else
		      AddToResult "(NO MATCH!!)"
		    end if
		  end if
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events btnTest
	#tag Event
		Sub Action()
		  dim data as string = fldData.Text
		  dim key as string = fldKey.Text
		  dim salt as string = "$2a$10$1234567890123456789012" // For bcrypt
		  
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
		    
		  case 1 // EBC
		    sw.Start
		    data = blf.EncryptEBC( data )
		    sw.Stop
		    AddToResult "Encrypted: " + EncodeHex( data, true )
		    sw.Start
		    data = blf.DecryptEBC( data )
		    sw.Stop
		    AddToResult "Decrypted: " + data
		    
		  case 2 // CBC
		    sw.Start
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
		    
		    dim vector as string = "12345678" // Don't need to do this, but if you do, be sure to store the vector for decryption
		    blf.SetVector( vector )
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
		    blf.SetVector( vector )
		    while byteIndex <= encrypted.LenB
		      block = encrypted.MidB( byteIndex, 8 )
		      byteIndex = byteIndex + 8
		      sw.Start
		      data = data + blf.DecryptCBC( block, byteIndex > encrypted.LenB )
		      sw.Stop
		    wend
		    AddToResult "Decrypted: " + data
		    
		  case 6 // Bcrypt
		    pTestBcrypt( key, salt, sw )
		    
		  case 7 // Generate Salt
		    sw.Start
		    AddToResult Bcrypt_MTC.GenerateSalt( 6 )
		    AddToResult Bcrypt_MTC.GenerateSalt( 10, Bcrypt_MTC.Prefix.Y )
		    sw.Stop
		    
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
		  // Constuct tests here
		  
		  dim tests() as string = Array( _
		  "Encrypt / Decrypt", _
		  "EncryptEBC / DecryptEBC", _
		  "EncryptCBC / DecryptCBC", _
		  "EcryptCBC / DecryptCBC (chained)", _
		  "EncryptCBC / DecryptCBC (chained, modified vector)", _
		  "-", _
		  "Bcrypt", _
		  "Generate Salt" _
		  )
		  
		  me.AddRows tests
		  me.ListIndex = 0
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
			"10 - Drawer Window"
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
