#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  Parser.Parse args
		  
		  if Parser.HelpRequested then
		    Parser.ShowHelp
		    return 0
		  end if
		  
		  select case Parser.StringValue( kOptionExecute, "" ).Left( 1 )
		  case kActionEncrypt.Left( 1 )
		    Action = Actions.Encrypt
		  case kActionDecrypt.Left( 1 )
		    Action = Actions.Decrypt
		  case kActionBcrypt.Left( 1 )
		    Action = Actions.Bcrypt
		  case kActionVerifyBcrypt.Left( 1 )
		    Action = Actions.VerifyBcrypt
		  end select
		  
		  //
		  // Sanity check
		  //
		  if Action = Actions.Encrypt or Action = Actions.Decrypt then
		    if not Parser.OptionValue( kOptionEncrypter ).WasSet then
		      StdErr.WriteLine "An encrypter must be specified"
		      StdErr.WriteLine ""
		      Parser.ShowHelp
		      return 1
		    end if
		  end if
		  
		  if Parser.BooleanValue( kOptionKeyStdIn ) and Parser.BooleanValue( kOptionDataStdIn ) then
		    StdErr.WriteLine "Both key and data cannot be on StdIn"
		    return 1
		  end if
		  
		  if Parser.Extra.Ubound > 0 then
		    StdErr.WriteLine "Too much data given"
		    return 1
		  end if
		  
		  dim extra as string = if( Parser.Extra.Ubound = 0, Parser.Extra( 0 ), "" )
		  
		  dim dataFile as FolderItem = Parser.FileValue( kOptionDataFile, nil )
		  
		  if extra <> "" xor dataFile isa FolderItem xor Parser.BooleanValue( kOptionDataStdIn ) then
		    //
		    // That's fine
		    //
		  else
		    StdErr.WriteLine "Too many data sources, or no data provided"
		    return 1
		  end if
		  
		  //
		  // Set properties
		  //
		  DataEncoding = StringToBinaryEncoding( Parser.StringValue( kOptionDataEncoding ) )
		  OutputEncoding = StringToBinaryEncoding( Parser.StringValue( kOptionOutputEncoding ) )
		  KeyEncoding = StringToBinaryEncoding( Parser.StringValue( kOptionKeyEncoding ) )
		  
		  //
		  // Get the data
		  //
		  dim dataSource as variant
		  
		  if extra <> "" then
		    dataSource = extra
		  elseif dataFile isa FolderItem then
		    if dataFile.IsReadable then
		      dataSource = dataFile
		    else
		      StdErr.WriteLine "The data file is not readable"
		      return 1
		    end if
		  elseif Parser.BooleanValue( kOptionDataStdIn ) then
		    dataSource = StdIn
		  end if
		  
		  dim reader as new DataReader( dataSource )
		  
		  if reader.EOF then
		    StdErr.WriteLine "No data provided"
		    return 1
		  end if
		  
		  //
		  // Set up the output
		  //
		  if parser.OptionValue( kOptionOutputFile ).WasSet then
		    dim f as FolderItem = parser.FileValue( kOptionOutputFile )
		    dim bs as BinaryStream = BinaryStream.Create( f, true )
		    OutputWriter = bs
		  else
		    OutputWriter = StdOut
		  end if
		  
		  //
		  // Do what they asked
		  //
		  dim errCode as integer
		  
		  select case Action
		  case Actions.Encrypt, Actions.Decrypt
		    errCode = DoEncryption( reader )
		    
		  case Actions.Bcrypt, Actions.VerifyBcrypt
		    errCode = DoBcrypt( reader )
		    
		  case else
		    StdErr.WriteLine "Unrecognized action " + parser.StringValue( kOptionExecute )
		    errCode = 1
		    
		  end select
		  
		  dim defaultEOL as boolean = OutputWriter isa StandardOutputStream
		  if Parser.BooleanValue( kOptionEOL, defaultEOL ) then
		    OutputWriter.Write EndOfLine
		  end if
		  
		  if OutputWriter isa BinaryStream then
		    BinaryStream( OutputWriter ).Close
		    OutputWriter = nil
		  end if
		  
		  return errCode
		  
		  Exception err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    dim msg as string = err.Message
		    if msg = "" then
		      msg = "An error of type " + Introspection.GetType( err ).Name + " has occurred"
		    end if
		    
		    StdErr.WriteLine msg
		    return 1
		    
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function Decode(data As String, encoding As BinaryEncodings) As String
		  #if DebugBuild
		    dim dataLenB as integer = data.LenB
		    #pragma unused dataLenB
		  #endif
		  
		  select case encoding
		  case BinaryEncodings.None
		    return data
		    
		  case BinaryEncodings.Hex
		    return DecodeHex( data.Trim )
		    
		  case BinaryEncodings.Base64
		    return DecodeBase64( data )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoBcrypt(reader As DataReader) As Integer
		  dim result as string
		  
		  dim data as string = reader.ReadAll
		  data = Decode( data, DataEncoding )
		  
		  dim salt as string = Parser.StringValue( kOptionSalt )
		  dim rounds as integer = Parser.IntegerValue( kOptionBcryptRounds, kDefaultBcryptRounds )
		  
		  select case Action
		  case Actions.Bcrypt
		    if salt <> "" then
		      result = Bcrypt_MTC.Hash( data, salt )
		    else
		      result = Bcrypt_MTC.Hash( data, rounds )
		    end if
		    
		  case Actions.VerifyBcrypt
		    dim against as string = Parser.StringValue( kOptionVerifyAgainstHash )
		    if Bcrypt_MTC.Verify( data, against ) then
		      result = "valid"
		    else
		      result = "INVALID"
		    end if
		    
		  end select
		  
		  Write result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoEncryption(reader As DataReader) As Integer
		  dim key as string
		  
		  //
		  // More sanity checks
		  //
		  if Parser.OptionValue( kOptionKeyFile ).WasSet xor Parser.OptionValue( kOptionKey ).WasSet xor _
		    Parser.BooleanValue( kOptionKeyStdIn ) then
		    //
		    // Fine
		    //
		  elseif not ( Parser.OptionValue( kOptionKeyFile ).WasSet or Parser.OptionValue( kOptionKey ).WasSet or _
		    Parser.BooleanValue( kOptionKeyStdIn ) ) then
		    //
		    // Also fine
		    //
		  else
		    StdErr.WriteLine "Too many key sources specified"
		    return 1
		  end if
		  
		  if Action = Actions.Encrypt and OutputWriter isa StandardOutputStream and OutputEncoding = BinaryEncodings.None then
		    StdErr.WriteLine "Unencoded data cannot be written to StdOut, use --" + _
		    kOptionOutputFile + " to specify a file or --" + kOptionOutputEncoding + _
		    " to specify an encoding"
		    return 1
		  end if
		  
		  if Parser.OptionValue( kOptionKeyFile ).WasSet then
		    dim bs as BinaryStream = BinaryStream.Open( Parser.FileValue( kOptionKeyFile ) )
		    key = bs.Read( bs.Length )
		    bs.Close
		    
		  elseif Parser.OptionValue( kOptionKey ).WasSet then
		    key = Parser.StringValue( kOptionKey )
		    
		  elseif Parser.BooleanValue( kOptionKeyStdIn ) then
		    key = StdIn.ReadAll
		    
		  elseif Parser.BooleanValue( kOptionDataStdIn ) then
		    StdErr.WriteLine "When data is given on StdIn, a key must be specified"
		    return 1
		    
		  else
		    dim onStdIn as string = StdIn.ReadAll
		    if not StdIn.EOF and onStdIn <> "" then
		      //
		      // This really shouldn't happen
		      //
		      StdErr.WriteLine "Can't get a key because there is already data on StdIn: " + onStdIn
		      return 1
		      
		    else
		      StdErr.Write "Enter key: "
		      key = StdIn.ReadLineANSIWithoutEcho
		      if key <> "" then
		        StdErr.Write "Again: "
		        dim keyCompare as string = StdIn.ReadLineANSIWithoutEcho
		        if StrComp( key, keyCompare, 0 ) <> 0 then
		          StdErr.WriteLine "Keys do not match"
		          return 1
		        end if
		      end if
		    end if
		    
		  end if
		  
		  if key = "" then
		    StdErr.WriteLine "You must provide a key"
		    return 1
		  end if
		  
		  key = Decode( key, KeyEncoding )
		  select case Parser.StringValue( kOptionKeyHash, "" )
		  case "", "N", "None"
		    //
		    // Do nothing
		    //
		    
		  case "MD5", "M"
		    key = Crypto.MD5( key )
		    
		  case "SHA1", "S1"
		    key = Crypto.SHA1( key )
		    
		  case "SHA256", "S256"
		    key = Crypto.SHA256( key )
		    
		  case "SHA512", "S512"
		    key = Crypto.SHA512( key )
		    
		  end select
		  
		  dim code as string = Parser.StringValue( kOptionEncrypter )
		  dim e as M_Crypto.Encrypter 
		  
		  try
		    e = M_Crypto.GetEncrypter( code )
		  catch err as M_Crypto.InvalidCodeException
		    StdErr.WriteLine "Invalid encrypter code " + code
		    return 1
		  end try
		  
		  e.SetKey key
		  
		  select case Parser.StringValue( kOptionPadding, kPaddingPKCS )
		  case kPaddingNullsOnly
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		    
		  case kPaddingNullsWithCount
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsWithCount
		    
		  case kPaddingPKCS
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		    
		  end select
		  
		  e.SetInitialVector Parser.StringValue( kOptionInitialVector, "" )
		  
		  const kBase64BytesPerLine = 57
		  const kBase64CharsPerLine = 76
		  const kMinBlockSize = 8
		  const kChunkMultiplier = 10
		  const kChunkSize = kBase64BytesPerLine * kBase64CharsPerLine * kMinBlockSize * kChunkMultiplier
		  
		  while not reader.EOF
		    dim result as string
		    
		    dim data as string = NextDataChunk( reader, kChunkSize )
		    #if DebugBuild
		      dim dataLenB as integer = data.LenB
		      #pragma unused dataLenB
		    #endif
		    
		    if Action = Actions.Encrypt then
		      result = e.Encrypt( data, reader.EOF )
		    else
		      try
		        result = e.Decrypt( data, reader.EOF )
		      catch err as M_Crypto.InvalidPaddingException
		        StdErr.WriteLine "Could not decrypt"
		        return 1
		      end try
		    end if
		    
		    Write result
		  wend
		  
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Encode(data As String) As String
		  select case OutputEncoding
		  case BinaryEncodings.None
		    return data
		    
		  case BinaryEncodings.Hex
		    return EncodeHex( data )
		    
		  case BinaryEncodings.Base64
		    return EncodeBase64( data )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NextDataChunk(reader As DataReader, chunkSize As Integer) As String
		  static rawBuffer as string
		  dim result as string = rawBuffer
		  rawBuffer = ""
		  
		  //
		  // Translate to the encoded size we need
		  //
		  dim trueCharCount as integer = chunkSize
		  dim adjustedChunkSize as integer = trueCharCount
		  
		  select case DataEncoding
		  case BinaryEncodings.Hex
		    adjustedChunkSize = adjustedChunkSize * 4
		    trueCharCount = trueCharCount * 2
		    
		  case BinaryEncodings.Base64
		    trueCharCount = trueCharCount * 4 / 3
		    adjustedChunkSize = trueCharCount + ( trueCharCount \ 76 * 2 )
		  end select
		  
		  dim count as integer = adjustedChunkSize
		  
		  while not reader.EOF and count > 0 and result.LenB < trueCharCount
		    result = result + reader.Read( count )
		    
		    //
		    // With Base64 and Hex, strip any EOL or whitespace
		    //
		    select case DataEncoding
		    case BinaryEncodings.Hex, BinaryEncodings.Base64
		      result = ReplaceLineEndings( result.Trim, "" )
		      result = result.ReplaceAllB( " ", "" )
		    end select
		    
		    //
		    // Make sure we get all the raw data we want
		    //
		    count = adjustedChunkSize - result.LenB
		  wend
		  
		  rawBuffer = result.MidB( trueCharCount + 1 )
		  result = result.LeftB( trueCharCount )
		  result = Decode( result, DataEncoding )
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StringToBinaryEncoding(s As String) As BinaryEncodings
		  select case s.Left( 1 )
		  case "N", ""
		    return BinaryEncodings.None
		    
		  case "H"
		    return BinaryEncodings.Hex
		    
		  case "B"
		    return BinaryEncodings.Base64
		    
		  case else
		    return BinaryEncodings.Unknown
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Write(data As String)
		  data = Encode( data )
		  OutputWriter.Write data
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Action As Actions
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DataEncoding As BinaryEncodings
	#tag EndProperty

	#tag Property, Flags = &h21
		Private KeyEncoding As BinaryEncodings
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OutputEncoding As BinaryEncodings
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OutputWriter As Writeable
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static parser as OptionParser
			  
			  if parser is nil then
			    parser = new OptionParser
			    dim o as Option
			    
			    o = new Option( "x", kOptionExecute, "The action to perform", Option.OptionType.String )
			    o.IsRequired = true
			    o.AddAllowedValue _
			    kActionEncrypt, kActionEncrypt.Left( 1 ), kActionDecrypt, kActionDecrypt.Left( 1 ), _
			    kActionBcrypt, kActionBcrypt.Left( 1 ), kActionVerifyBcrypt, kActionVerifyBcrypt.Left( 1 )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionSalt, "The specific salt to use for Bcrypt in the correct format (testing option not normally used)", _
			    Option.OptionType.String )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionBcryptRounds, _
			    "The number of rounds to use for Bcrypt if salt is not specified [default " + str( kDefaultBcryptRounds ) + "]", _
			    Option.OptionType.Integer )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionVerifyAgainstHash, "The hash to verify with Bcrypt", _
			    Option.OptionType.String )
			    parser.AddOption o
			    
			    o = new Option( "e", kOptionEncrypter, "Encrypter to use for encrypt/decrypt", Option.OptionType.String )
			    o.AddAllowedValue _
			    "aes-128", "aes-128-cbc", "aes-128-ecb", _
			    "aes-192", "aes-192-cbc", "aes-192-ecb", _
			    "aes-256", "aes-256-cbc", "aes-256-ecb", _
			    "bf", "bf-cbc", "bf-ecb"
			    parser.AddOption o
			    
			    o = new Option( "k", kOptionKey, "The encryption key as plain, hex, or Base64", Option.OptionType.String )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionKeyFile, "The file that contains the key", Option.OptionType.File )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionKeyStdIn, "The key has been piped in through StdIn", Option.OptionType.Boolean )
			    parser.AddOption o
			    
			    o = new Option( "K", kOptionKeyEncoding, "The encoding of the key [default None]", Option.OptionType.String )
			    o.AddAllowedValue "None", "N", "Hex", "H", "Base64", "B"
			    parser.AddOption o
			    
			    o = new Option( "H", kOptionKeyHash, "The hash to apply to the key [default None]", Option.OptionType.String )
			    o.AddAllowedValue "None", "N", "MD5", "M", "SHA1", "S1", "SHA256", "S256", "SHA512", "S512"
			    parser.AddOption o
			    
			    o = new Option( "p", kOptionPadding, "The padding to use [default PKCS]", Option.OptionType.String )
			    o.AddAllowedValue kPaddingNullsOnly, kPaddingNullsWithCount, kPaddingPKCS
			    parser.AddOption o
			    
			    o = new Option( "", kOptionInitialVector, "With CBC encryption, the initial vector as plain or hex", Option.OptionType.String )
			    parser.AddOption o
			    
			    o = new Option( "D", kOptionDataEncoding, "The encoding of the data [default None]", Option.OptionType.String )
			    o.AddAllowedValue "None", "N", "Hex", "H", "Base64", "B"
			    parser.AddOption o
			    
			    o = new Option( "", kOptionDataFile, "The file that contains the data", Option.OptionType.File )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionDataStdIn, "The data has been piped in through StdIn", Option.OptionType.Boolean )
			    parser.AddOption o
			    
			    o = new Option( "O", kOptionOutputEncoding, "Encode the result of encryption/decryption [default None]", Option.OptionType.String )
			    o.AddAllowedValue "None", "N", "Hex", "H", "Base64", "B"
			    parser.AddOption o
			    
			    o = new Option( "", kOptionOutputFile, "The output file that will be overwritten", Option.OptionType.File )
			    parser.AddOption o
			    
			    o = new Option( "", kOptionEOL, "Include an EOL in the output [default TRUE]", Option.OptionType.Boolean )
			    parser.AddOption o
			    
			    parser.AppDescription = "Encrypt/Decrypt/Bcrypt utilty"
			    parser.AdditionalHelpNotes = kHelpNotes
			  end if
			  
			  return parser
			End Get
		#tag EndGetter
		Private Parser As OptionParserModule.OptionParser
	#tag EndComputedProperty


	#tag Constant, Name = kActionBcrypt, Type = String, Dynamic = False, Default = \"Bcrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kActionDecrypt, Type = String, Dynamic = False, Default = \"Decrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kActionEncrypt, Type = String, Dynamic = False, Default = \"Encrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kActionVerifyBcrypt, Type = String, Dynamic = False, Default = \"Verify-bcrypt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDefaultBcryptRounds, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kHelpNotes, Type = String, Dynamic = False, Default = \"If data is not given and no file specified\x2C it will be pulled from StdIn.\n\nWhen encrypting/decrypting\x2C if a key is not given it will be requested unless the --data-stdin switch is present.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionBcryptRounds, Type = String, Dynamic = False, Default = \"rounds", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionDataEncoding, Type = String, Dynamic = False, Default = \"data-encoding", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionDataFile, Type = String, Dynamic = False, Default = \"data-file", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionDataStdIn, Type = String, Dynamic = False, Default = \"data-stdin", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionEncrypter, Type = String, Dynamic = False, Default = \"encrypter", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionEOL, Type = String, Dynamic = False, Default = \"eol", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionExecute, Type = String, Dynamic = False, Default = \"execute", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionInitialVector, Type = String, Dynamic = False, Default = \"iv", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionKey, Type = String, Dynamic = False, Default = \"key", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionKeyEncoding, Type = String, Dynamic = False, Default = \"key-encoding", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionKeyFile, Type = String, Dynamic = False, Default = \"key-file", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionKeyHash, Type = String, Dynamic = False, Default = \"key-hash", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionKeyStdIn, Type = String, Dynamic = False, Default = \"key-stdin", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionOutputEncoding, Type = String, Dynamic = False, Default = \"output-encoding", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionOutputFile, Type = String, Dynamic = False, Default = \"output-file", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionPadding, Type = String, Dynamic = False, Default = \"padding", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionSalt, Type = String, Dynamic = False, Default = \"salt", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionVerifyAgainstHash, Type = String, Dynamic = False, Default = \"against-hash", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPaddingNullsOnly, Type = String, Dynamic = False, Default = \"Nulls-Only", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPaddingNullsWithCount, Type = String, Dynamic = False, Default = \"Nulls-With-Count", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPaddingPKCS, Type = String, Dynamic = False, Default = \"PKCS", Scope = Private
	#tag EndConstant


	#tag Enum, Name = Actions, Type = Integer, Flags = &h21
		Unknown
		  Encrypt
		  Decrypt
		  Bcrypt
		VerifyBcrypt
	#tag EndEnum

	#tag Enum, Name = BinaryEncodings, Type = Integer, Flags = &h21
		Unknown
		  None
		  Base64
		Hex
	#tag EndEnum


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
