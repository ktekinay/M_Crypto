#tag Class
Protected Class Encrypter
	#tag Method, Flags = &h1
		Protected Sub AddBackNullIfNeeded(data As MemoryBlock)
		  // See if the previous block had a null that could have been part of the padding and
		  // add it back to this decrypted block
		  if LastBlockHadNull then
		    dim oldSize as integer = data.Size
		    dim newSize as integer = oldSize + 1
		    data.Size = newSize
		    data.StringValue( 1, oldSize ) = data.StringValue( 0, oldSize ) // Shift the data over by one byte
		    data.Byte( 0 ) = 0
		    LastBlockHadNull = false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  //
		  // Subclasses should implement their own Constructors
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decrypt(data As String, isFinalBlock As Boolean = True) As String
		  select case UseFunction
		  case Functions.Default
		    RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		    
		    if data = "" then
		      return data
		    end if
		    
		    dim d as MemoryBlock = data
		    RaiseEvent Decrypt( Functions.Default, d, isfinalBlock )
		    return d
		    
		  case Functions.CBC
		    return DecryptCBC( data, isFinalBlock )
		    
		  case Functions.ECB
		    return DecryptECB( data, isFinalBlock )
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  dim d as MemoryBlock = data
		  RaiseEvent Decrypt( Functions.CBC, d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptECB(data As String, isFinalBlock As Boolean = True) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  dim d as MemoryBlock = data
		  RaiseEvent Decrypt( Functions.ECB, d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DepadIfNeeded(data As MemoryBlock)
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
		    
		    dim paddedSize as integer = data.Size
		    if ( paddedSize mod BlockSize ) <> 0 and paddedSize <> ( BlockSize + 1 ) then return // If it's not a multiple of BlockSize, it's not properly padded anyway (9 bytes is a special case and has to be checked)
		    dim lastByte as integer = data.Byte( paddedSize - 1 )
		    if lastByte > paddedSize or lastByte < 2 or lastByte > ( BlockSize + 1 ) then return // Can't be a valid pad
		    
		    dim compareMB as new MemoryBlock( lastByte )
		    compareMB.Byte( lastByte - 1 ) = lastByte
		    if StrComp( data.StringValue( paddedSize - lastByte, lastByte ), compareMB, 0 ) = 0 then
		      data.Size = paddedSize - lastByte
		    end if
		    
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

	#tag Method, Flags = &h0
		Function Encrypt(data As String, isFinalBlock As Boolean = True) As String
		  select case UseFunction
		  case Functions.Default
		    RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		    
		    if data = "" then
		      return data
		    end if
		    
		    dim d as MemoryBlock = data
		    RaiseEvent Encrypt( Functions.Default, d, isfinalBlock )
		    return d
		    
		  case Functions.CBC
		    return EncryptCBC( data, isFinalBlock )
		    
		  case Functions.ECB
		    return EncryptECB( data, isFinalBlock )
		    
		  case else
		    raise new M_Crypto.UnimplementedEnumException
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptCBC(data As String, isFinalBlock As Boolean = True) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  dim d as MemoryBlock = data
		  RaiseEvent Encrypt( Functions.CBC, d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptECB(data As String, isFinalBlock As Boolean = True) As String
		  RaiseErrorIf( not WasKeySet, kErrorNoKeySet )
		  
		  if data = "" then
		    return data
		  end if
		  
		  dim d As MemoryBlock = data
		  RaiseEvent Encrypt( Functions.ECB, d, isFinalBlock )
		  return d
		  
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

	#tag Method, Flags = &h1
		Protected Sub PadIfNeeded(data As MemoryBlock)
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
		    // Pads the data to an exact multiple of BlockSize bytes.
		    // It does this by adding nulls followed by the number of padding bytes.
		    // Example: If data is &h31 32 33, it will turn it into
		    // &h31 32 33 00 00 00 00 05. If only one byte needs to be added, it will
		    // add BlockSize + 1 to avoid confusion.
		    //
		    // If data is already a multiple of BlockSize, it will only add a padding if the trailing bytes
		    // match the pattern of X nulls followed by &hX. The exception is if the
		    // last BlockSize bytes matches the pattern &h00 X (BlockSize - 1) + BlockSize.
		    // To be on the safe side, it will add padding then too.
		    
		    dim lastByte as integer = data.Byte( originalSize - 1 )
		    
		    if padToAdd = 1 then
		      padToAdd = BlockSize + 1 // Will never add a single byte pad
		    end if
		    
		    if padToAdd = BlockSize then // Already a multiple, so see if we need to do anything
		      padToAdd = 0 // Assume we have nothing to add
		      
		      if lastByte = ( BlockSize + 1 ) then // Special case
		        // See if the rest of the bytes are all zeros
		        dim compareMB as new MemoryBlock( BlockSize )
		        compareMB.Byte( BlockSize - 1 ) = BlockSize + 1
		        if StrComp( data.StringValue( originalSize - BlockSize, BlockSize ), compareMB, 0 ) = 0 then
		          padToAdd = BlockSize // This means that the last are all nulls followed by BlockSize + 1, so add padding
		        end if
		        
		      elseif lastByte >= 2 and lastByte < ( BlockSize + 1 ) then // It's in the valid trigger range
		        dim compareMB as new MemoryBlock( lastByte )
		        compareMB.Byte( lastByte - 1 ) = lastByte
		        if StrComp( data.StringValue( originalSize - lastByte, lastByte ), compareMB, 0 ) = 0 then // The end of the data looks like a pad
		          padToAdd = BlockSize // Add a real pad
		        end if
		      end if
		    end if
		    
		    if padToAdd <> 0 then
		      dim newSize as integer = originalSize + padToAdd
		      data.Size = newSize
		      data.Byte( newSize - 1 ) = padToAdd
		    end if
		    
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
		  if vector <> "" then
		    vector = InterpretVector( vector )
		    RaiseErrorIf vector.LenB <> BlockSize, kErrorVectorSize.ReplaceAll( "BLOCKSIZE", str( BlockSize ) )
		  end if
		  
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
			  return zCurrentVector
			End Get
		#tag EndGetter
		CurrentVector As String
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected InitialVector As String
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
		Protected zCurrentVector As String
	#tag EndProperty


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
