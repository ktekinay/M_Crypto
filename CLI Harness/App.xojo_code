#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  dim parser as OptionParserModule.OptionParser = GetOptionParser
		  parser.Parse args
		  
		  if parser.HelpRequested then
		    parser.ShowHelp
		    return 0
		  end if
		  
		  dim action as string = parser.StringValue( kOptionExecute, "" )
		  
		  //
		  // Sanity check
		  //
		  if action.Left( 1 ) = kActionEncrypt.Left( 1 ) or action.Left( 1 ) = kActionDecrypt.Left( 1 ) then
		    if not parser.OptionValue( kOptionEncrypter ).WasSet then
		      print "An encrypter must be specified"
		      print ""
		      parser.ShowHelp
		      return 1
		    end if
		  end if
		  
		  if parser.Extra.Ubound > 0 then
		    print "Too much data given"
		    return 1
		  end if
		  
		  dim extra as string = if( parser.Extra.Ubound = 0, parser.Extra( 0 ), "" )
		  
		  dim dataFile as FolderItem = parser.FileValue( kOptionDataFile, nil )
		  if dataFile isa FolderItem and extra <> "" then
		    print "Data file specified, extra data ignored"
		  end if
		  
		  //
		  // Get the data
		  //
		  dim data as string
		  
		  if dataFile is nil then
		    data = extra
		  else
		    dim bs as BinaryStream = BinaryStream.Open( dataFile )
		    data = bs.Read( bs.Length )
		    bs.Close
		  end if
		  
		  if data = "" then
		    print "No data provided"
		    return 1
		  end if
		  
		  data = Decode( data, parser.StringValue( kOptionDataEncoding, "" ) )
		  
		  //
		  // Do what they asked
		  //
		  dim errCode as integer
		  
		  try
		    select case action.Left( 1 )
		    case kActionEncrypt.Left( 1 ), kActionDecrypt.Left( 1 )
		      errCode = DoEncryption( data, action, parser )
		      
		    case kActionBcrypt.Left( 1 ), kActionVerifyBcrypt.Left( 1 )
		      errCode = DoBcrypt( data, action, parser )
		      
		    case else
		      print "Unrecognized action " + action
		      errCode = 1
		      
		    end select
		    
		  catch err as RuntimeException
		    if err isa EndException or err isa ThreadEndException then
		      raise err
		    end if
		    
		    print err.Message
		    errCode = 1
		  end try
		  
		  if parser.BooleanValue( kOptionEOL, true ) then
		    print ""
		  end if
		  
		  return errCode
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function Decode(data As String, type As String) As String
		  select case type.Left( 1 )
		  case "", "N"
		    return data
		    
		  case "H"
		    return DecodeHex( data.Trim )
		    
		  case "B"
		    return DecodeBase64( data.Trim )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoBcrypt(data As String, action As String, parser As OptionParserModule.OptionParser) As Integer
		  dim result as string
		  
		  dim salt as string = parser.StringValue( kOptionSalt )
		  dim rounds as integer = parser.IntegerValue( kOptionBcryptRounds, kDefaultBcryptRounds )
		  
		  select case action.Left( 1 )
		  case kActionBcrypt.Left( 1 )
		    if salt <> "" then
		      result = Bcrypt_MTC.Hash( data, salt )
		    else
		      result = Bcrypt_MTC.Hash( data, rounds )
		    end if
		    
		  case kActionVerifyBcrypt.Left( 1 )
		    dim against as string = parser.StringValue( kOptionVerifyAgainstHash )
		    if Bcrypt_MTC.Verify( data, against ) then
		      result = "valid"
		    else
		      result = "INVALID"
		    end if
		    
		  end select
		  
		  result = Encode( result, parser.StringValue( kOptionOutputEncoding ) )
		  StdOut.Write result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoEncryption(data As String, action As String, parser As OptionParserModule.OptionParser) As Integer
		  dim key as string
		  
		  if parser.OptionValue( kOptionKeyFile ).WasSet and parser.OptionValue( kOptionKey ).WasSet then
		    print "Both key and key-file was specified"
		    return 1
		  end if
		  
		  if parser.OptionValue( kOptionKeyFile ).WasSet then
		    dim bs as BinaryStream = BinaryStream.Open( parser.FileValue( kOptionKeyFile ) )
		    key = bs.Read( bs.Length )
		    bs.Close
		    
		  elseif parser.OptionValue( kOptionKey ).WasSet then
		    key = parser.StringValue( kOptionKey )
		    
		  else
		    StdOut.Write "Enter key: "
		    key = StdIn.ReadLineANSIWithoutEcho
		  end if
		  
		  if key = "" then
		    print "You must provide a key"
		    return 1
		  end if
		  
		  key = Decode( key, parser.StringValue( kOptionKeyEncoding ) )
		  select case parser.StringValue( kOptionKeyHash, "" )
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
		  
		  dim code as string = parser.StringValue( kOptionEncrypter )
		  dim e as M_Crypto.Encrypter 
		  
		  try
		    e = M_Crypto.GetEncrypter( code )
		  catch err as M_Crypto.InvalidCodeException
		    print "Invalid encrypter code " + code
		    return 1
		  end try
		  
		  e.SetKey key
		  
		  select case parser.StringValue( kOptionPadding, kPaddingPKCS )
		  case kPaddingNullsOnly
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsOnly
		    
		  case kPaddingNullsWithCount
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.NullsWithCount
		    
		  case kPaddingPKCS
		    e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
		    
		  end select
		  
		  e.SetInitialVector parser.StringValue( kOptionInitialVector, "" )
		  
		  dim result as string
		  if action.Left( 1 ) = kActionEncrypt.Left( 1 ) then
		    result = e.Encrypt( data )
		  else
		    try
		      result = e.Decrypt( data )
		    catch err as M_Crypto.InvalidPaddingException
		      print "Could not decrypt"
		      return 1
		    end try
		  end if
		  
		  result = Encode( result, parser.StringValue( kOptionOutputEncoding ) )
		  StdOut.Write result
		  
		  return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Encode(data As String, type As String) As String
		  select case type.Left( 1 )
		  case "", "N"
		    return data
		    
		  case "H"
		    return EncodeHex( data )
		    
		  case "B"
		    return EncodeBase64( data )
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetOptionParser() As OptionParserModule.OptionParser
		  dim parser as new OptionParser
		  dim o as Option
		  
		  o = new Option( "x", kOptionExecute, "The action to perform", Option.OptionType.String )
		  o.IsRequired = true
		  o.AddAllowedValue _
		  kActionEncrypt, kActionEncrypt.Left( 1 ), kActionDecrypt, kActionDecrypt.Left( 1 ), _
		  kActionBcrypt, kActionBcrypt.Left( 1 ), kActionVerifyBcrypt, kActionVerifyBcrypt.Left( 1 )
		  parser.AddOption o
		  
		  o = new Option( "s", kOptionSalt, "The salt to use for Bcrypt (automatically generated otherwise)", _
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
		  
		  o = new Option( "", kOptionOutputEncoding, "Encode the result of encryption/decryption [default None]", Option.OptionType.String )
		  o.AddAllowedValue "None", "N", "Hex", "H", "Base64", "B"
		  parser.AddOption o
		  
		  o = new Option( "", kOptionEOL, "Include an EOL in the output [default TRUE]", Option.OptionType.Boolean )
		  parser.AddOption o
		  
		  parser.AppDescription = "Encrypt/Decrypt/Bcrypt"
		  parser.AdditionalHelpNotes = kHelpNotes
		  
		  return parser
		End Function
	#tag EndMethod


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

	#tag Constant, Name = kHelpNotes, Type = String, Dynamic = False, Default = \"If data is not given and no file specified\x2C it will be pulled from StdIn.\n\nWhen encrypting/decrypting\x2C if a key is not given it will be requested.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionBcryptRounds, Type = String, Dynamic = False, Default = \"rounds", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionDataEncoding, Type = String, Dynamic = False, Default = \"data-encoding", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptionDataFile, Type = String, Dynamic = False, Default = \"data-file", Scope = Private
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

	#tag Constant, Name = kOptionOutputEncoding, Type = String, Dynamic = False, Default = \"output-encoding", Scope = Private
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


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
