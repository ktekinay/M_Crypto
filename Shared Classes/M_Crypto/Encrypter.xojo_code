#tag Class
Protected Class Encrypter
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  //
		  // Subclasses should implement their own Constructors
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(cloneFrom As M_Crypto.Encrypter)
		  //
		  // Clone Constructor
		  //
		  
		  zBlockSize = cloneFrom.zBlockSize
		  WasKeySet = cloneFrom.WasKeySet
		  UseFunction = cloneFrom.UseFunction
		  PaddingMethod = cloneFrom.PaddingMethod
		  
		  if cloneFrom.InitialVector isa object then
		    InitialVector = cloneFrom.InitialVector
		  end if
		  
		  RaiseEvent CloneFrom( cloneFrom )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Decrypt(f As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data.Size = 0 then
		    return
		  end if
		  
		  select case f
		  case Functions.Default, Functions.CBC, Functions.ECB
		    RaiseErrorIf( PaddingMethod = Padding.None, kErrorPaddingCannotBeNone )
		    
		    if isFinalBlock then
		      RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorDecryptionBlockSize )
		    else
		      RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		    end if
		    
		    RaiseEvent Decrypt( f, data, isFinalBlock )
		    
		    if isFinalBlock then
		      DepadIfNeeded( data )
		      zCurrentVector = nil
		    end if
		    
		  case Functions.CFB, Functions.OFB
		    if zSaveVector is nil then
		      zSaveVector = new MemoryBlock( zBlockSize )
		    end if
		    
		    if PaddingMethod <> Padding.None then
		      if isFinalBlock then
		        RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorDecryptionBlockSize )
		      else
		        RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		      end if
		    end if
		    
		    RaiseEvent Decrypt( f, data, isFinalBlock )
		    
		    if isFinalBlock then
		      DepadIfNeeded( data )
		      zCurrentVector = nil
		    end if
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decrypt(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Decrypt( UseFunction, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Decrypt( Functions.CBC, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptCFB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Decrypt( Functions.CFB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptECB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Decrypt( Functions.ECB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptOFB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Decrypt( Functions.OFB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DepadIfNeeded(data As MemoryBlock)
		  // See PadIfNeeded for a description of how padding works.
		  
		  if data is nil or data.Size = 0 or PaddingMethod = Padding.None then
		    return
		  end if
		  
		  dim originalSize as integer = data.Size
		  dim dataPtr as ptr = data
		  
		  select case PaddingMethod
		  case Padding.PKCS
		    //
		    // A pad is expected so this will raise an exception if
		    // it's not present
		    //
		    
		    dim stripCount as integer = dataPtr.Byte( originalSize - 1 )
		    if stripCount = 0 or stripCount > BlockSize or stripCount > originalSize then
		      //
		      // These are impossible with PKCS
		      // (stripCount might equal original size if this was the last block in a chain)
		      // 
		      raise new M_Crypto.InvalidPaddingException
		    end if
		    
		    dim lastIndex as integer = originalSize - 2
		    dim firstIndex as integer = originalSize - stripCount
		    if firstIndex < 0 then
		      firstIndex = 0
		    end if
		    
		    for byteIndex as integer = firstIndex to lastIndex
		      if dataPtr.Byte( byteIndex ) <> stripCount then
		        //
		        // Something is wrong
		        //
		        raise new M_Crypto.InvalidPaddingException
		      end if
		    next
		    
		    data.Size = data.Size - stripCount
		    
		  case Padding.NullsWithCount
		    // Counterpart to padding. Will remove nulls followed by the number of nulls
		    // from the end of the MemoryBlock.
		    //
		    // The original implementation would never add one just one byte, but rather would
		    // add BlockSize + 1. I've since discovered that the standard calls for padding to be
		    // added in all cases so a single byte can be added to the end. However, to keep
		    // compatible with the previous implementation, this will attempt to strip
		    // BlockSize + 1 if specified and if possible.
		    //
		    
		    dim stripCount as integer = dataPtr.Byte( data.Size - 1 )
		    if stripCount = 0 or stripCount > ( BlockSize + 1 ) or stripCount > data.Size then
		      raise new M_Crypto.InvalidPaddingException
		    end if
		    
		    dim lastIndex as integer = originalSize - 2
		    dim firstIndex as integer = originalSize - stripCount
		    if firstIndex < 0 then
		      firstIndex = 0
		    end if
		    
		    for byteIndex as integer = firstIndex to lastIndex
		      if dataPtr.Byte( byteIndex ) <> 0 then
		        //
		        // Something is wrong
		        //
		        raise new M_Crypto.InvalidPaddingException
		      end if
		    next
		    
		    data.Size = data.Size - stripCount
		    
		  case Padding.NullsOnly
		    dim lastIndex as integer = originalSize - 1
		    dim firstIndex as integer = originalSize - BlockSize
		    if firstIndex < 0 then
		      firstIndex = 0
		    end if
		    for index as integer = lastIndex downto firstIndex
		      if dataPtr.Byte( index ) <> 0 then
		        dim newSize as integer = index + 1
		        if originalSize > newSize then
		          data.Size = newSize
		        end if
		        exit
		      end if
		    next
		    
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Encrypt(f As Functions, data As MemoryBlock, isFinalBlock As Boolean)
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data.Size = 0 and not isFinalBlock then
		    return
		  end if
		  
		  select case f
		  case Functions.Default, Functions.CBC, Functions.ECB
		    RaiseErrorIf( PaddingMethod = Padding.None, kErrorPaddingCannotBeNone )
		    
		    if isFinalBlock then
		      PadIfNeeded( data )
		    else
		      RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		    end if
		    
		    RaiseEvent Encrypt( f, data, isfinalBlock )
		    
		    if isFinalBlock then
		      zCurrentVector = nil
		    end if
		    
		    return
		    
		  case Functions.CFB, Functions.OFB
		    if isFinalBlock then
		      PadIfNeeded( data )
		    else
		      RaiseErrorIf( ( data.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		    end if
		    
		    RaiseEvent Encrypt( f, data, isfinalBlock )
		    
		    if isFinalBlock then
		      zCurrentVector = nil
		    end if
		    
		    return
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encrypt(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Encrypt( UseFunction, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Encrypt( Functions.CBC, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptCFB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Encrypt( Functions.CFB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptECB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Encrypt( Functions.ECB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptOFB(data As String, isFinalBlock As Boolean = True) As String
		  dim mb as MemoryBlock = data
		  self.Encrypt( Functions.OFB, mb, isFinalBlock )
		  dim result as string = mb
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetCurrentThreadId() As Integer
		  dim t as Thread = Thread.Current
		  if t is nil then
		    return 0
		  else
		    return t.ThreadID
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function InterpretVector(vector As String) As String
		  if vector = "" then 
		    return vector
		  end if
		  
		  if vector.LenB = BlockSize then
		    return vector
		  end if
		  
		  dim newVector as string = DecodeHex( vector )
		  if newVector.LenB = BlockSize then
		    return newVector
		  else
		    return vector
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PadIfNeeded(data As MemoryBlock)
		  if data is nil or PaddingMethod = Padding.None then
		    return
		  end if
		  
		  var blockSize as integer = self.BlockSize // Avoids repeated calls to the computed property
		  
		  dim originalSize as integer = data.Size
		  dim padToAdd as byte = blockSize - ( originalSize mod blockSize )
		  if padToAdd = blockSize then
		    padToAdd = 0
		  end if
		  
		  select case PaddingMethod
		  case Padding.PKCS
		    // https://en.wikipedia.org/wiki/Padding_%28cryptography%29#PKCS7
		    
		    if padToAdd = 0 then
		      padToAdd = blockSize
		    end if
		    
		    var firstIndex as integer = data.Size
		    data.Size = firstIndex + padToAdd
		    var lastIndex as integer = data.Size - 1
		    
		    var dataPtr as ptr = data
		    
		    for i as integer = firstIndex to lastIndex
		      dataPtr.Byte( i ) = padToAdd
		    next
		    
		  case Padding.NullsWithCount
		    //
		    // ANSI X.923 padding
		    //
		    // Pads the data to an exact multiple of blockSize bytes by
		    // adding nulls plus the number of bytes added. For example, when
		    // blockSize = 8 and the final block is 0x32 32 32 32, it will be padded
		    // to 0x32 32 32 32 00 00 00 04. A pad is always added even if the final
		    // block is already the right size.
		    //
		    
		    if padToAdd = 0 then
		      padToAdd = blockSize
		    end if
		    
		    data.Size = data.Size + padToAdd
		    data.Byte( data.Size - 1 ) = padToAdd
		    
		  case Padding.NullsOnly
		    //
		    // Adds nulls to the end
		    //
		    if padToAdd <> 0 then
		      data.Size = data.Size + padToAdd
		    end if
		    
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub RaiseErrorIf(test As Boolean, msg As String)
		  if test then
		    dim err as new CryptoException
		    err.Message = msg
		    raise err
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetInitialVector()
		  SetInitialVector ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub SelfTest()
		  dim errMsg as string
		  dim raiseError as boolean
		  
		  if RaiseEvent DoSelfTest( errMsg ) = false or errMsg <> "" then
		    raiseError = true
		  end if
		  
		  if raiseError then 
		    if errMsg = "" then
		      errMsg = "SelfTest has not been implemented or unknown error"
		    end if
		    dim err as new RuntimeException
		    err.Message = errMsg
		    raise err
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetBlockSize(size As Integer)
		  zBlockSize = size
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetInitialVector(vector As String)
		  if vector = "" then
		    InitialVector = nil
		    return
		  end if
		  
		  var blockSize as integer = self.BlockSize
		  
		  vector = InterpretVector( vector )
		  RaiseErrorIf vector.Bytes <> blockSize, kErrorVectorSize.ReplaceAll( "BLOCKSIZE", str( blockSize ) )
		  
		  InitialVector = vector
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetKey(value As String)
		  RaiseErrorIf value = "", kErrorKeyCannotBeEmpty
		  
		  RaiseEvent KeyChanged( value )
		  WasKeySet = true
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CloneFrom(e As M_Crypto.Encrypter)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Decrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 506572666F726D20612073656C662D74657374206F6E2074686520636C6173732E20496620636F646520697320696D706C656D656E7465642C206D7573742072657475726E20547275652E
		Event DoSelfTest(ByRef returnErrorMessage As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Encrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event KeyChanged(key As String)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return zBlockSize
			End Get
		#tag EndGetter
		BlockSize As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim code as string
			  if self isa Blowfish_MTC then
			    code = "bf"
			  elseif self isa AES_MTC then
			    code = "aes-" + AES_MTC( self ).Bits.ToString
			  else
			    code = "unknown"
			  end if
			  
			  select case UseFunction
			  case Functions.Default
			    //
			    // Do nothing
			    //
			  case Functions.CBC
			    code = code + "-cbc"
			  case Functions.CFB
			    code = code + "-cfb"
			  case Functions.ECB
			    code = code + "-ecb"
			  case Functions.OFB
			    code = code + "-ofb"
			  case else
			    code = code + "-unknown"
			  end select
			  
			  return code
			  
			End Get
		#tag EndGetter
		Code As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  var temp as MemoryBlock = zCurrentVector
			  if temp is nil then
			    return ""
			  else
			    return temp
			  end if
			  
			End Get
		#tag EndGetter
		CurrentVector As String
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected InitialVector As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h0
		PaddingMethod As Padding
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  select case PaddingMethod
			  case Padding.None
			    return "none"
			  case Padding.NullsOnly
			    return "nulls"
			  case Padding.NullsWithCount
			    return "nullswithcount"
			  case Padding.PKCS
			    return "pkcs"
			  case else
			    return "unknown"
			  end select
			End Get
		#tag EndGetter
		PaddingString As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5768656E207365742C20456E637279707420616E6420446563727970742077696C6C2075736520746865207370656369666965642066756E6374696F6E
		UseFunction As Functions
	#tag EndProperty

	#tag Property, Flags = &h21
		Private VectorDict As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WasKeySet As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zBlockSize As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  //
			  // If the same encrypter is used in different threads to
			  // process blocks, have to make sure one thread's vector doesn't clobber the other
			  //
			  
			  if VectorDict is nil then
			    VectorDict = new Dictionary
			    return nil // Can't be a vector yet
			  end if
			  
			  return VectorDict.Lookup( GetCurrentThreadId, nil )
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if VectorDict is nil then
			    VectorDict = new Dictionary
			  end if
			  
			  VectorDict.Value( GetCurrentThreadId ) = value
			End Set
		#tag EndSetter
		Protected zCurrentVector As MemoryBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected zSaveVector As MemoryBlock
	#tag EndProperty


	#tag Constant, Name = kErrorDecryptionBlockSize, Type = String, Dynamic = False, Default = \"Data blocks must be an exact multiple of BlockSize", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorIntermediateEncyptionBlockSize, Type = String, Dynamic = False, Default = \"Intermediate data blocks must be an exact multiple of BlockSize for encryption\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorKeyCannotBeEmpty, Type = String, Dynamic = False, Default = \"The key cannot be empty", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorNoKeySet, Type = String, Dynamic = False, Default = \"A key must be specified during construction or within ExpandState or Expand0State before encrypting or decrypting.", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorPaddingCannotBeNone, Type = String, Dynamic = False, Default = \"Padding cannot be None with this mode.", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorVectorSize, Type = String, Dynamic = False, Default = \"Vector must be empty (will default to nulls)\x2C or exactly BLOCKSIZE bytes or hexadecimal characters representing BLOCKSIZE bytes", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = Functions, Type = Integer, Flags = &h0
		Default
		  ECB
		  CBC
		  CFB
		OFB
	#tag EndEnum

	#tag Enum, Name = Padding, Type = Integer, Flags = &h0
		NullsOnly
		  NullsWithCount
		  PKCS
		None
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="BlockSize"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentVector"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="PaddingMethod"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Padding"
			EditorType="Enum"
			#tag EnumValues
				"0 - NullsOnly"
				"1 - NullsWithCount"
				"2 - PKCS"
				"3 - None"
			#tag EndEnumValues
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseFunction"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Functions"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - ECB"
				"2 - CBC"
				"3 - CFB"
				"4 - OFB"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Code"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PaddingString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
