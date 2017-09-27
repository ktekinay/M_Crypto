#tag Module
Protected Module M_ANSI
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h1
		Protected Function ApplyFormat(s As String, ParamArray modes() As M_ANSI.Gmodes) As String
		  return M_ANSI.Format( modes ) + s + M_ANSI.NoFormat
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AssembleCode(value As String) As String
		  if IsDisabled or TargetWindows then
		    return ""
		  else
		    static prefix as string = kEscape + "["
		    return prefix + value
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AssembleMoveCode(value As Integer, suffix As String) As String
		  return AssembleCode( str( value ) + suffix )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Beep() As String
		  static char as string = ChrB( 7 ) // ctrl-G
		  return char
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorBack(columns As Integer = 1) As String
		  return AssembleMoveCode( columns, "D" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorDown(rows As Integer = 1) As String
		  return AssembleMoveCode( rows, "B" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorForward(columns As Integer = 1) As String
		  return AssembleMoveCode( columns, "C" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorHome() As String
		  return AssembleCode( "H" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorPosition(row As Integer, column As Integer) As String
		  return AssembleCode( str( row ) + ";" + str( column ) + "H" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CursorUp(rows As Integer = 1) As String
		  return AssembleMoveCode( rows, "A" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EraseDisplay() As String
		  return AssembleCode( "2J" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EraseLine() As String
		  return AssembleCode( "K" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Format(modes() As GModes) As String
		  dim arr() as string
		  for i as integer = 0 to modes.Ubound
		    arr.Append str( integer( modes( i ) ) )
		  next
		  
		  return AssembleCode( join( arr, ";" ) + "m" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Format(ParamArray modes() As GModes) As String
		  return M_ANSI.Format( modes )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HumanReadable(encoded As String) As String
		  return encoded.ReplaceAll( kEscape, "<esc>" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Interpret(withCodes As String, existing As M_ANSI.InterpretedString = Nil) As M_ANSI.InterpretedString
		  if existing is nil then
		    existing = new M_ANSI.InterpretedString
		  end if
		  
		  dim buffer() as string = existing.Buffer
		  dim chars() as string = withCodes.Split( "" )
		  
		  dim inEscape as boolean
		  dim escSequence as string
		  
		  for charIndex as integer = 0 to chars.Ubound
		    dim char as string = chars( charIndex )
		    if inEscape then
		      if char = "[" then
		        //
		        // Ignore that
		        //
		        
		      elseif char = "3" then
		        //
		        // Forward delete, keep going until "~"
		        //
		        escSequence = char
		        
		      elseif char = "~" then
		        inEscape = false
		        
		      else
		        escSequence = escSequence + char
		        inEscape = false
		      end if
		      
		      if inEscape then
		        char = "" 
		        
		      else
		        //
		        // Process the sequence
		        //
		        select case escSequence
		          'case "A" // Up
		          'char = ""
		          '
		          'case "B" // Down
		          'char = ""
		          
		        case "C" // Right
		          char = &u06
		          
		        case "D" // Left
		          char = &u02
		          
		        case "3" // Forward delete
		          char = &u04
		          
		        case else
		          char = ""
		          
		        end select
		        
		        escSequence = ""
		      end if
		      
		    elseif char = kEscape then
		      inEscape = true
		      char = ""
		      
		    end if
		    
		    if char <> "" then
		      if char = &u7F or char = &u08 then // Delete
		        if existing.CursorPosition > 1 then
		          dim newPosition as integer = existing.CursorPosition - 1
		          buffer.Remove existing.BufferIndex
		          existing.CursorPosition = newPosition
		        end if
		        
		      elseif char = &u0B  then // Ctrl-K - kill to end of line
		        redim existing.Buffer( existing.BufferIndex )
		        
		      elseif char = &u15 then // Ctrl-U - kill to front of line
		        while existing.BufferIndex > -1
		          buffer.Remove existing.BufferIndex
		          existing.BufferIndex = existing.BufferIndex - 1
		        wend
		        
		      elseif char = &u04 then // Ctrl-D - forward delete
		        if not existing.EOF then
		          buffer.Remove existing.BufferIndex + 1
		        end if
		        
		      elseif char = &u01 then // Ctrl-A - to beginning of line
		        existing.CursorPosition = 1
		        
		      elseif char = &u02 then // Ctrl-B - back one
		        existing.CursorPosition = existing.CursorPosition - 1
		        
		      elseif char = &u05 then // Ctrl-E - to end of line
		        existing.BufferIndex = buffer.Ubound
		        
		      elseif char = &u06 then // Ctrl-F - forward one
		        existing.CursorPosition = existing.CursorPosition + 1
		        
		      elseif char = &u14 then // Ctrl-T - swap
		        if existing.BufferIndex <> -1 and not existing.EOF then
		          dim temp as string = buffer( existing.BufferIndex )
		          buffer( existing.BufferIndex ) = buffer( existing.BufferIndex + 1 )
		          buffer( existing.BufferIndex + 1 ) = temp
		        end if
		        
		      elseif char.Asc < 32 then
		        //
		        // Control character, ignore it
		        //
		        
		      else // Some other character
		        buffer.Insert existing.BufferIndex + 1, char
		        existing.CursorPosition = existing.CursorPosition + 1
		      end if
		    end if
		  next
		  
		  return existing
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function NoFormat() As String
		  return M_ANSI.Format( GModes.AllOff )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadLineANSI(Extends std As StandardInputStream) As String
		  #if TargetWindows then
		    #pragma unused std
		    
		    dim s as string = Input
		    return Interpret( s )
		    
		  #else
		    
		    dim console as new StandardOutputStream // In case the app is piping
		    
		    dim useEncoding as TextEncoding = Encodings.UTF8
		    
		    dim oldEcho as boolean = WillEcho
		    
		    if oldEcho then
		      WillEcho = false
		    end if
		    
		    dim state as new M_ANSI.InterpretedString
		    dim startingString as string
		    dim startingPosition as integer = state.CursorPosition
		    
		    do
		      dim seq as string = std.ReadAll.DefineEncoding( useEncoding )
		      if seq = &u0A or seq = &u0D then
		        exit
		      end if
		      
		      if seq <> "" then
		        state = Interpret( seq, state )
		        
		        dim newString as string = state.Interpreted
		        
		        if state.CursorPosition = startingPosition and StrComp( startingString, newString, 0 ) = 0 then
		          //
		          // Nothing has changed so beep
		          //
		          console.Write Beep
		          
		        else
		          dim backSpace as integer = startingPosition - 1
		          console.Write if( backSpace > 0, CursorBack( backSpace ), "" ) + EraseLine + newString + _
		          if( not state.EOF, CursorBack( newString.Len - state.CursorPosition + 1 ), "" )
		        end if
		        
		        startingPosition = state.CursorPosition
		        startingString = newString
		      end if
		      
		      if App.CurrentThread is nil then
		        App.DoEvents
		      else
		        App.YieldToNextThread
		      end if
		    loop
		    
		    if oldEcho then
		      WillEcho = true
		      console.WriteLine ""
		    end if
		    
		    return state.Interpreted
		    
		    Exception err as RuntimeException
		      if oldEcho then
		        WillEcho = oldEcho
		        console.WriteLine ""
		      end if
		      
		      raise err
		      
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadLineANSIWithoutEcho(Extends std As StandardInputStream) As String
		  #pragma unused std
		  
		  dim console as new StandardOutputStream // In case the app is piping
		  
		  dim oldEcho as boolean = WillEcho
		  
		  if oldEcho then
		    WillEcho = false
		  end if
		  
		  dim s as string = Input
		  
		  if oldEcho then
		    WillEcho = true
		    console.WriteLine ""
		  end if
		  
		  return Interpret( s ).Interpreted
		  
		  Exception err as RuntimeException
		    System.DebugLog CurrentMethodName + ": Exception of type " + Introspection.GetType( err ).FullName
		    
		    if oldEcho then
		      WillEcho = oldEcho
		    end if
		    
		    console.WriteLine ""
		    
		    raise err
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadWithoutEcho(Extends std As StandardInputStream, count As Integer, enc As TextEncoding = Nil) As String
		  dim oldEcho as boolean = WillEcho
		  
		  if oldEcho then
		    WillEcho = false
		  end if
		  
		  dim s as string = std.Read( count, enc )
		  
		  if oldEcho then
		    WillEcho = true
		  end if
		  
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function RestoreCursorPosition() As String
		  return AssembleCode( "u" )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SaveCursorPosition() As String
		  return AssembleCode( "s" )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TcGetAttr() As Termios
		  dim values as Termios
		  
		  #if not TargetWindows then
		    soft declare sub tcgetattr lib kTermLib (file as Integer, ByRef values as Termios)
		    
		    tcgetattr( 0, values )
		  #endif
		  
		  return values
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TcSetAttr(values As Termios)
		  #if not TargetWindows then
		    
		    soft declare sub tcsetattr lib kTermLib (file as Integer, when as Integer, ByRef values as Termios)
		    tcsetattr( 0, 0, values )
		    
		  #else
		    
		    #pragma unused values
		    
		  #endif
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected IsDisabled As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  return &u1B
			End Get
		#tag EndGetter
		Private kEscape As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  dim values as Termios = TcGetAttr
			  return ( values.LocalFlags and kTermEcho ) = kTermEcho
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  dim term as Termios = TcGetAttr
			  if value then
			    term.LocalFlags = term.LocalFlags or kTermEcho
			  else
			    term.LocalFlags = term.LocalFlags and ( not kTermEcho )
			  end if
			  
			  TcSetAttr term
			  
			End Set
		#tag EndSetter
		Private WillEcho As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = kTermEcho, Type = Double, Dynamic = False, Default = \"&h00000008", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTermLib, Type = String, Dynamic = False, Default = \"", Scope = Private
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"libncurses.dylib"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"ncurses"
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.1", Scope = Protected
	#tag EndConstant


	#tag Structure, Name = Termios, Flags = &h21
		InputFlags As UInteger
		  OutputFlags As UInteger
		  ControlFlags As UInteger
		  LocalFlags As UInteger
		  ControlChars(19) As Byte
		  InputSpeed As UInteger
		OutputSpeed As UInteger
	#tag EndStructure


	#tag Enum, Name = GModes, Type = Integer, Flags = &h1
		AllOff = 0
		  Bold = 1
		  Underscore = 4
		  Blink = 5
		  Reverse = 7
		  Concealed = 8
		  BlackForeground = 30
		  RedForeground = 31
		  GreenForeground = 32
		  YellowForeground = 33
		  BlueForeground = 34
		  MagentaForeground = 35
		  CyanForeground = 36
		  WhiteForeground = 37
		  BlackBackground = 40
		  RedBackground = 41
		  GreenBackground = 42
		  YellowBackground = 43
		  BlueBackground = 44
		  MagentaBackground = 45
		  CyanBackground = 46
		WhiteBackground = 47
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
