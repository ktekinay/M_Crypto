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
   Height          =   474
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   True
   MaxWidth        =   32000
   MenuBar         =   0
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Encryption"
   Visible         =   True
   Width           =   792
   Begin TextArea fldSource
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
      Height          =   135
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   2
      ScrollbarHorizontal=   False
      ScrollbarVertical=   True
      Styled          =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   51
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   752
   End
   Begin TextArea fldDestination
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
      Height          =   135
      HelpTag         =   ""
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LimitText       =   0
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   2
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
      Top             =   295
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   752
   End
   Begin Label Labels
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
      Scope           =   2
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      Text            =   "Source"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   69
   End
   Begin PopupMenu mnuAction
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
      Left            =   101
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   20
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin PopupMenu mnuFromEncoding
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
      Left            =   326
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   19
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin PopupMenu mnuToEncoding
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
      Left            =   522
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   19
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
   Begin PopupMenu mnuPadding
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
      Left            =   368
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "SystemSmall"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   197
      Underline       =   False
      Visible         =   True
      Width           =   146
   End
   Begin Label Labels
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
      Left            =   274
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      Text            =   "From"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   19
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   47
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   2
      InitialParent   =   ""
      Italic          =   False
      Left            =   468
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      Text            =   "To"
      TextAlign       =   1
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   19
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   42
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   3
      InitialParent   =   ""
      Italic          =   False
      Left            =   287
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      Text            =   "Padding"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   197
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   47
   End
   Begin PopupMenu mnuEncryptFunction
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
      Left            =   621
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   197
      Underline       =   False
      Visible         =   True
      Width           =   134
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   4
      InitialParent   =   ""
      Italic          =   False
      Left            =   543
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   11
      TabPanelIndex   =   0
      Text            =   "Function"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   197
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   66
   End
   Begin PopupMenu mnuEncrypter
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      InitialValue    =   "AES-256\nAES-192\nAES-128\n-\nBlowFish"
      Italic          =   False
      Left            =   101
      ListIndex       =   -1
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   197
      Underline       =   False
      Visible         =   True
      Width           =   152
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   5
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   13
      TabPanelIndex   =   0
      Text            =   "Encrypter"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   198
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   77
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
      Left            =   89
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   14
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   229
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   174
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   6
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   15
      TabPanelIndex   =   0
      Text            =   "Key"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   231
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   77
   End
   Begin PopupMenu mnuKeyEncoding
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
      Left            =   275
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   231
      Underline       =   False
      Visible         =   True
      Width           =   146
   End
   Begin TextField fldVector
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
      Left            =   89
      LimitText       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Mask            =   ""
      Password        =   False
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   261
      Underline       =   False
      UseFocusRing    =   True
      Visible         =   True
      Width           =   174
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   7
      InitialParent   =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   18
      TabPanelIndex   =   0
      Text            =   "Vector"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   263
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   57
   End
   Begin PopupMenu mnuKeyHash
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
      Left            =   543
      ListIndex       =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   19
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   231
      Underline       =   False
      Visible         =   True
      Width           =   179
   End
   Begin Label Labels
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   8
      InitialParent   =   ""
      Italic          =   False
      Left            =   454
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   20
      TabPanelIndex   =   0
      Text            =   "Apply Hash"
      TextAlign       =   0
      TextColor       =   &c00000000
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   231
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   77
   End
   Begin PushButton btnExecute
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Execute"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   654
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   21
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   262
      Underline       =   False
      Visible         =   True
      Width           =   118
   End
   Begin PushButton btnSwap
      AutoDeactivate  =   True
      Bold            =   False
      ButtonStyle     =   "0"
      Cancel          =   False
      Caption         =   "Swap"
      Default         =   False
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   510
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   22
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   263
      Underline       =   False
      Visible         =   True
      Width           =   118
   End
   Begin Label lblTiming
      AutoDeactivate  =   True
      Bold            =   False
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   False
      Left            =   604
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   23
      TabPanelIndex   =   0
      Text            =   "0 ms"
      TextAlign       =   2
      TextColor       =   &c00000000
      TextFont        =   "SmallSystem"
      TextSize        =   0.0
      TextUnit        =   0
      Top             =   442
      Transparent     =   True
      Underline       =   False
      Visible         =   True
      Width           =   168
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Function Decode(s As String, encoding As String) As String
		  select case encoding
		  case kLabelPlainText
		    return s
		    
		  case kLabelHex
		    return DecodeHex( s )
		    
		  case kLabelBase64
		    return DecodeBase64( s )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Encode(s As String, encoding As String) As String
		  select case encoding
		  case kLabelPlainText
		    return s
		    
		  case kLabelHex
		    return EncodeHex( s )
		    
		  case kLabelBase64
		    return EncodeBase64( s )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Execute()
		  dim result as string
		  
		  dim e as M_Crypto.Encrypter = self.Encrypter
		  e.UseFunction = mnuEncryptFunction.RowTag( mnuEncryptFunction.ListIndex )
		  
		  dim source as string = Decode( fldSource.Text, mnuFromEncoding.Text )
		  
		  dim key as string = Decode( fldKey.Text, mnuKeyEncoding.Text )
		  select case mnuKeyHash.Text
		  case kLabelMD5
		    key = Crypto.MD5( key )
		    
		  case kLabelSHA1
		    key = Crypto.SHA1( key )
		    
		  case kLabelSHA256
		    key = Crypto.SHA256( key )
		    
		  case kLabelSHA512
		    key = Crypto.SHA512( key )
		    
		  end select
		  e.SetKey key
		  
		  dim vector as string = fldVector.Text
		  e.SetVector vector
		  
		  e.UseFunction = mnuEncryptFunction.RowTag( mnuEncryptFunction.ListIndex )
		  
		  e.PaddingMethod = mnuPadding.RowTag( mnuPadding.ListIndex )
		  
		  dim sw as new Stopwatch_MTC
		  sw.Start
		  
		  select case mnuAction.Text
		  case kLabelEncrypt
		    result = e.Encrypt( source )
		    
		  case kLabelDecrypt
		    result = e.Decrypt( source )
		    
		  end select
		  sw.Stop
		  
		  result = Encode( result, mnuToEncoding.Text )
		  
		  lblTiming.Text = format( sw.ElapsedMilliseconds, "#,0.00" ) + " ms"
		  
		  exception err as RuntimeException
		    result = "Error: " + err.Message
		    
		  finally
		    fldDestination.Text = result
		    
		    
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Encrypter As M_Crypto.Encrypter
	#tag EndProperty


	#tag Constant, Name = kLabelBase64, Type = String, Dynamic = False, Default = \"Base64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelCBC, Type = String, Dynamic = False, Default = \"CBC", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelDecrypt, Type = String, Dynamic = False, Default = \"Decrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelDefault, Type = String, Dynamic = False, Default = \"Default", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelECB, Type = String, Dynamic = False, Default = \"ECB", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelEncrypt, Type = String, Dynamic = False, Default = \"Encrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelHex, Type = String, Dynamic = False, Default = \"Hex", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelMD5, Type = String, Dynamic = False, Default = \"MD5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelNone, Type = String, Dynamic = False, Default = \"None", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelNullsOnly, Type = String, Dynamic = False, Default = \"Nulls Only", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelNullsWithCount, Type = String, Dynamic = False, Default = \"Nulls With Count", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelPKCS, Type = String, Dynamic = False, Default = \"PKCS", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelPlainText, Type = String, Dynamic = False, Default = \"Plain Text", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelSHA1, Type = String, Dynamic = False, Default = \"SHA1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelSHA256, Type = String, Dynamic = False, Default = \"SHA256", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLabelSHA512, Type = String, Dynamic = False, Default = \"SHA512", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events mnuAction
	#tag Event
		Sub Open()
		  mnuFromEncoding.AddRows array( kLabelBase64, kLabelHex )
		  mnuToEncoding.AddRows array( kLabelBase64, kLabelHex )
		  
		  me.AddRows array( kLabelEncrypt, kLabelDecrypt )
		  me.ListIndex = 0
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Change()
		  dim fromText as string = mnuFromEncoding.Text
		  dim toText as string = mnuToEncoding.Text
		  
		  select case me.Text
		  case kLabelEncrypt
		    if mnuFromEncoding.ListCount = 2 then
		      mnuFromEncoding.AddRow kLabelPlainText
		    end if
		    
		    if mnuToEncoding.ListCount = 3 then
		      mnuToEncoding.RemoveRow 2
		    end if
		    
		    if fromText = "" then
		      fromText = kLabelHex
		    end if
		    if toText = "" then
		      toText = kLabelPlainText
		    end if
		    
		  case kLabelDecrypt
		    if mnuFromEncoding.ListCount = 3 then
		      mnuFromEncoding.RemoveRow 2
		    end if
		    
		    if mnuToEncoding.ListCount = 2 then
		      mnuToEncoding.AddRow kLabelPlainText
		    end if
		    
		    if fromText = "" then
		      fromText = kLabelPlainText
		    end if
		    if toText = "" then
		      toText = kLabelHex
		    end if
		    
		  end select
		  
		  for i as integer = 0 to mnuFromEncoding.ListCount - 1
		    if mnuFromEncoding.List( i ) = toText then
		      mnuFromEncoding.ListIndex = i
		      exit
		    end if
		  next
		  
		  for i as integer = 0 to mnuToEncoding.ListCount - 1
		    if mnuToEncoding.List( i ) = fromText then
		      mnuToEncoding.ListIndex = i
		      exit
		    end if
		  next
		  
		  if mnuFromEncoding.ListIndex = -1 then
		    mnuFromEncoding.ListIndex = mnuFromEncoding.ListCount - 1
		  end if
		  
		  if mnuToEncoding.ListIndex = -1 then
		    mnuToEncoding.ListIndex = mnuToEncoding.ListCount - 1
		  end if
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuFromEncoding
#tag EndEvents
#tag Events mnuToEncoding
#tag EndEvents
#tag Events mnuPadding
	#tag Event
		Sub Open()
		  me.AddRows array( kLabelPKCS, kLabelNullsWithCount, kLabelNullsOnly )
		  me.RowTag( 0 ) = M_Crypto.Encrypter.Padding.PKCS5
		  me.RowTag( 1 ) = M_Crypto.Encrypter.Padding.NullsWithCount
		  me.RowTag( 2 ) = M_Crypto.Encrypter.Padding.NullsOnly
		  
		  me.ListIndex = 0
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuEncryptFunction
	#tag Event
		Sub Open()
		  me.AddRows array( kLabelDefault, kLabelECB, kLabelCBC )
		  me.RowTag( 0 ) = M_Crypto.Encrypter.Functions.Default
		  me.RowTag( 1 ) = M_Crypto.Encrypter.Functions.ECB
		  me.RowTag( 2 ) = M_Crypto.Encrypter.Functions.CBC
		  
		  me.ListIndex = 2
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuEncrypter
	#tag Event
		Sub Change()
		  Encrypter = M_Crypto.GetEncrypter( me.Text )
		  fldVector.CueText = "plain or hex of " + str( Encrypter.BlockSize ) + " bytes"
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  me.ListIndex = 0
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuKeyEncoding
	#tag Event
		Sub Open()
		  me.AddRows array( kLabelPlainText, kLabelHex, kLabelBase64 )
		  me.ListIndex = 0
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events mnuKeyHash
	#tag Event
		Sub Open()
		  me.AddRows array( kLabelNone, kLabelMD5, kLabelSHA1, kLabelSHA256, kLabelSHA512 )
		  me.ListIndex = 0
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnExecute
	#tag Event
		Sub Action()
		  self.Execute
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnSwap
	#tag Event
		Sub Action()
		  dim dest as string = fldDestination.Text
		  if dest = "" then
		    return
		  end if
		  
		  fldSource.Text = dest
		  fldDestination.Text = ""
		  mnuAction.ListIndex = mnuAction.ListIndex xor 1
		  
		  Execute
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Background"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Frame"
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
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Behavior"
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
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Size"
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
		Group="Behavior"
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
		Group="Frame"
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
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
