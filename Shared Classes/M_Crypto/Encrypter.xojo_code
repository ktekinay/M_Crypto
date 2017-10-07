#tag Class
Protected Class Encrypter
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  //
		  // Subclasses should implement their own Constructors
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Decrypt(f As Functions, data As String, isFinalBlock As Boolean) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  select case f
		  case Functions.Default, Functions.CBC, Functions.ECB
		    dim d as MemoryBlock = data
		    
		    if isFinalBlock then
		      RaiseErrorIf( ( d.Size mod BlockSize ) <> 0, kErrorDecryptionBlockSize )
		    else
		      RaiseErrorIf( ( d.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		    end if
		    
		    RaiseEvent Decrypt( f, d, isFinalBlock )
		    
		    if isFinalBlock then
		      DepadIfNeeded( d )
		      zCurrentVector = nil
		    end if
		    
		    return d
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decrypt(data As String, isFinalBlock As Boolean = True) As String
		  return Decrypt( UseFunction, data, isFinalBlock )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  return Decrypt( Functions.CBC, data, isFinalBlock )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptECB(data As String, isFinalBlock As Boolean = True) As String
		  return Decrypt( Functions.ECB, data, isFinalBlock )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DepadIfNeeded(data As MemoryBlock)
		  // See PadIfNeeded for a description of how padding works.
		  
		  if data is nil or data.Size = 0 then
		    return
		  end if
		  
		  dim originalSize as integer = data.Size
		  
		  select case PaddingMethod
		  case Padding.PKCS
		    //
		    // A pad is expected so this is the only method that will raise an exception if
		    // it's not present
		    //
		    static paddingStrings() as string
		    if paddingStrings.Ubound < BlockSize then
		      dim firstIndex as integer = paddingStrings.Ubound + 1
		      if firstIndex = 0 then
		        //
		        // Can never be a pad of zero
		        //
		        firstIndex = 1
		      end if
		      
		      redim paddingStrings( BlockSize )
		      for index as integer = firstIndex to BlockSize
		        dim pad as string = ChrB( index )
		        while pad.LenB < index
		          pad = pad + pad
		        wend
		        pad = pad.LeftB( index )
		        paddingStrings( index ) = pad
		      next
		    end if
		    
		    dim stripCount as integer = data.Byte( originalSize - 1 )
		    if stripCount = 0 or stripCount > BlockSize or stripCount > originalSize then
		      //
		      // These are impossible with PKCS
		      // (stripCount might equal original size if this was the last block in a chain)
		      // 
		      raise new M_Crypto.InvalidPaddingException
		    end if
		    
		    dim testPad as string = data.StringValue( originalSize - stripCount, stripCount ) 
		    if testPad = paddingStrings( stripCount ) then
		      data.Size = originalSize - stripCount
		    else
		      //
		      // Something is wrong
		      //
		      raise new M_Crypto.InvalidPaddingException
		    end if
		    
		  case Padding.NullsWithCount
		    // Counterpart to padding. Will remove nulls followed by the number of nulls
		    // from the end of the MemoryBlock.
		    
		    //
		    // the original implementation would never add one just one byte, but rather would
		    // add BlockSize + 1. I've since discovered that the standard calls for padding to be
		    // added in all cases so a single byte can be added to the end. However, to keep
		    // compatible with the previous implementation, this will attempt to string
		    // BlockSize + 1 if specified and if possible.
		    //
		    
		    dim lastByte as integer = data.Byte( data.Size - 1 )
		    if lastByte = 0 or lastByte > ( BlockSize + 1 ) or lastByte > data.Size then
		      raise new M_Crypto.InvalidPaddingException
		    end if
		    
		    data.Size = data.Size - lastByte
		    
		  case Padding.NullsOnly
		    dim lastIndex as integer = originalSize - 1
		    dim firstIndex as integer = originalSize - BlockSize
		    for index as integer = lastIndex downto firstIndex
		      if data.Byte( index ) <> 0 then
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
		Private Function Encrypt(f As Functions, data As String, isFinalBlock As Boolean) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  select case f
		  case Functions.Default, Functions.CBC, Functions.ECB
		    dim d as MemoryBlock = data
		    
		    if isFinalBlock then
		      PadIfNeeded( d )
		    else
		      RaiseErrorIf( ( d.Size mod BlockSize ) <> 0, kErrorIntermediateEncyptionBlockSize )
		    end if
		    
		    RaiseEvent Encrypt( f, d, isfinalBlock )
		    
		    if isFinalBlock then
		      zCurrentVector = nil
		    end if
		    
		    return d
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encrypt(data As String, isFinalBlock As Boolean = True) As String
		  return Encrypt( UseFunction, data, isFinalBlock )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  return Encrypt( Functions.CBC, data, isFinalBlock )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptECB(data As String, isFinalBlock As Boolean = True) As String
		  return Encrypt( Functions.ECB, data, isFinalBlock )
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
		  if data is nil or data.Size = 0 then
		    return
		  end if
		  
		  dim originalSize as integer = data.Size
		  dim padToAdd as byte = BlockSize - ( originalSize mod BlockSize )
		  if padToAdd = BlockSize then
		    padToAdd = 0
		  end if
		  
		  select case PaddingMethod
		  case Padding.PKCS
		    // https://en.wikipedia.org/wiki/Padding_%28cryptography%29#PKCS7
		    
		    if padToAdd = 0 then
		      padToAdd = BlockSize
		    end if
		    
		    dim newSize as integer = originalSize + padToAdd
		    data.Size = newSize
		    dim firstIndex as integer = originalSize
		    dim lastIndex as integer = newSize - 1
		    dim p as Ptr = data
		    for i as integer = firstIndex to lastIndex
		      p.Byte( i ) = padToAdd
		    next
		    
		  case Padding.NullsWithCount
		    //
		    // ANSI X.923 padding
		    //
		    // Pads the data to an exact multiple of BlockSize bytes by
		    // adding nulls plus the number of bytes added. For example, when
		    // BlockSize = 8 and the final block is 0x32 32 32 32, it will be padded
		    // to 0x32 32 32 32 00 00 00 04. A pad is always added even if the final
		    // block is already the right size.
		    //
		    
		    if padToAdd = 0 then
		      padToAdd = BlockSize
		    end if
		    data.Size = data.Size + padToAdd
		    data.Byte( data.Size - 1 ) = padToAdd
		    
		  case Padding.NullsOnly
		    //
		    // Adds nulls to the end
		    //
		    if padToAdd <> 0 then
		      data.Size = originalSize + padToAdd
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
		  
		  vector = InterpretVector( vector )
		  RaiseErrorIf vector.LenB <> BlockSize, kErrorVectorSize.ReplaceAll( "BLOCKSIZE", str( BlockSize ) )
		  
		  InitialVector = StringToMutableMemoryBlock( vector )
		  
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
		Event Decrypt(type As Functions, data As MemoryBlock, isFinalBlock As Boolean)
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
			  return MemoryBlockToString( zCurrentVector )
			  
			End Get
		#tag EndGetter
		CurrentVector As String
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected InitialVector As Xojo.Core.MutableMemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastBlockHadNull As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		PaddingMethod As Padding
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5768656E207365742C20456E637279707420616E6420446563727970742077696C6C2075736520746865207370656369666965642066756E6374696F6E
		UseFunction As Functions
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WasKeySet As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zBlockSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zCurrentVector As Xojo.Core.MutableMemoryBlock
	#tag EndProperty


	#tag Constant, Name = kErrorDecryptionBlockSize, Type = String, Dynamic = False, Default = \"Data blocks must be an exact multiple of BlockSize", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorIntermediateEncyptionBlockSize, Type = String, Dynamic = False, Default = \"Intermediate data blocks must be an exact multiple of BlockSize for encryption\n  ", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kErrorKeyCannotBeEmpty, Type = String, Dynamic = False, Default = \"The key cannot be empty", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorNoKeySet, Type = String, Dynamic = False, Default = \"A key must be specified during construction or within ExpandState or Expand0State before encrypting or decrypting.", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kErrorVectorSize, Type = String, Dynamic = False, Default = \"Vector must be empty (will default to nulls)\x2C or exactly BLOCKSIZE bytes or hexadecimal characters representing BLOCKSIZE bytes", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = Functions, Type = Integer, Flags = &h0
		Default
		  ECB
		CBC
	#tag EndEnum

	#tag Enum, Name = Padding, Type = Integer, Flags = &h0
		NullsOnly
		  NullsWithCount
		PKCS
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="BlockSize"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentVector"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
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
			Name="PaddingMethod"
			Group="Behavior"
			Type="Padding"
			EditorType="Enum"
			#tag EnumValues
				"0 - NullsOnly"
				"1 - NullsWithCount"
				"2 - PKCS"
			#tag EndEnumValues
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
		#tag ViewProperty
			Name="UseFunction"
			Group="Behavior"
			Type="Functions"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - ECB"
				"2 - CBC"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
