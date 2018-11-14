#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  StopProfiling
		  
		  dim w as new WndEncryption
		  w.Show
		  
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileEncryptionWindow() As Boolean Handles FileEncryptionWindow.Action
			dim w as new WndEncryption
			w.Show
			return true
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function FileUnitTestsWindow() As Boolean Handles FileUnitTestsWindow.Action
			XojoUnitTestWindow.Show
			return true
		End Function
	#tag EndMenuHandler


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
