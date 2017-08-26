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

	#tag Method, Flags = &h0
		Sub Decrypt(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #pragma unused data
		  #pragma unused isFinalBlock
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Decrypt(data As String, isFinalBlock As Boolean = True) As String
		  dim d as MemoryBlock = data
		  Decrypt( d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DecryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True, vector As String = "")
		  #pragma unused data
		  #pragma unused isFinalBlock
		  #pragma unused vector
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptCBC(data As String, isFinalBlock As Boolean = True, vector As String = "") As String
		  dim d as MemoryBlock = data
		  DecryptCBC( d, isfinalBlock, vector )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DecryptECB(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #pragma unused data
		  #pragma unused isFinalBlock
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DecryptECB(data As String, isFinalBlock As Boolean = True) As String
		  dim d as MemoryBlock = data
		  DecryptECB( d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DepadIfNeeded(data As MemoryBlock)
		  // See PadIfNeeded for a description of how padding works.
		  select case PaddingMethod
		  case Padding.PKCS5
		    static paddingStrings() as string
		    if paddingStrings.Ubound = -1 then
		      redim paddingStrings( 8 )
		      for index as integer = 1 to 8
		        dim pad as string = ChrB( index )
		        while pad.LenB < index
		          pad = pad + pad
		        wend
		        pad = pad.LeftB( index )
		        paddingStrings( index ) = pad
		      next
		    end if
		    
		    if data is nil then
		      return
		    end if
		    
		    dim originalSize as integer = data.Size
		    if originalSize = 0 then
		      return
		    end if
		    
		    dim stripCount as byte = data.Byte( originalSize - 1 )
		    if stripCount > 0 and stripCount <= 8 and stripCount <= originalSize then
		      dim testPad as string = data.StringValue( originalSize - stripCount, stripCount ) 
		      if testPad = paddingStrings( stripCount ) then
		        data.Size = originalSize - stripCount
		      end if
		    end if
		    
		  case Padding.NullPadding
		    // Counterpart to padding. Will remove nulls followed by the number of nulls
		    // from the end of the MemoryBlock.
		    
		    if data is nil or data.Size = 0 then return
		    
		    dim paddedSize as integer = data.Size
		    if ( paddedSize mod 8 ) <> 0 and paddedSize <> 9 then return // If it's not a multiple of 8, it's not properly padded anyway (9 bytes is a special case and has to be checked)
		    dim lastByte as integer = data.Byte( paddedSize - 1 )
		    if lastByte > paddedSize or lastByte < 2 or lastByte > 9 then return // Can't be a valid pad
		    
		    dim compareMB as new MemoryBlock( lastByte )
		    compareMB.Byte( lastByte - 1 ) = lastByte
		    if StrComp( data.StringValue( paddedSize - lastByte, lastByte ), compareMB, 0 ) = 0 then
		      data.Size = paddedSize - lastByte
		    end if
		  end select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Encrypt(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #pragma unused data
		  #pragma unused isFinalBlock
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Encrypt(data As String, isFinalBlock As Boolean = True) As String
		  dim d as MemoryBlock = data
		  Encrypt( d, isfinalBlock )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EncryptCBC(data As MemoryBlock, isFinalBlock As Boolean = True, vector As String = "")
		  #pragma unused data
		  #pragma unused isFinalBlock
		  #pragma unused vector
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptCBC(data As String, isFinalBlock As Boolean = True, vector As String = "") As String
		  dim d as MemoryBlock = data
		  EncryptCBC( d, isfinalBlock, vector )
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub EncryptECB(data As MemoryBlock, isFinalBlock As Boolean = True)
		  #pragma unused data
		  #pragma unused isFinalBlock
		  
		  RaiseNotOverriddenException CurrentMethodName
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EncryptECB(data As String, isFinalBlock As Boolean = True) As String
		  dim d As MemoryBlock = data
		  EncryptECB( d, isFinalBlock )
		  return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function InterpretVector(vector As String) As String
		  if vector = "" then 
		    return vector
		  end if
		  
		  if vector.LenB = 8 then
		    return vector
		  end if
		  
		  dim newVector as string = DecodeHex( vector )
		  if newVector.LenB = 8 then
		    return newVector
		  else
		    return vector
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub PadIfNeeded(data As MemoryBlock)
		  select case PaddingMethod
		  case Padding.PKCS5
		    // https://en.wikipedia.org/wiki/Padding_%28cryptography%29#PKCS7
		    
		    if data is nil then
		      return
		    end if
		    
		    dim originalSize as integer = data.Size
		    if originalSize = 0 then
		      return
		    end if
		    
		    dim padToAdd as byte = 8 - ( originalSize mod 8 )
		    if padToAdd = 0 then
		      padToAdd = 8
		    end if
		    
		    dim newSize as integer = originalSize + padToAdd
		    data.Size = newSize
		    dim firstIndex as integer = originalSize
		    dim lastIndex as integer = newSize - 1
		    dim p as Ptr = data
		    for i as integer = firstIndex to lastIndex
		      p.Byte( i ) = padToAdd
		    next
		    
		  case Padding.NullPadding
		    // Pads the data to an exact multiple of 8 bytes.
		    // It does this by adding nulls followed by the number of padding bytes.
		    // Example: If data is &h31 32 33, it will turn it into
		    // &h31 32 33 00 00 00 00 05. If only one byte needs to be added, it will
		    // add 9 to avoid confusion.
		    //
		    // If data is already a multiple of 8, it will only add a padding if the trailing bytes
		    // match the pattern of X nulls followed by &hX. The exception is if the
		    // last 8 bytes matches the pattern &h00 00 00 00 00 00 00 09.
		    // To be on the safe side, it will add padding then too.
		    
		    if data is nil or data.Size = 0 then return
		    
		    dim originalSize as integer = data.Size
		    dim padToAdd as integer = 8 - ( originalSize mod 8 )
		    dim lastByte as integer = data.Byte( originalSize - 1 )
		    
		    if padToAdd = 1 then
		      padToAdd = 9 // Will never add a single byte pad, so have to add 9
		    end if
		    
		    if padToAdd = 8 then // Already a multiple, so see if we need to do anything
		      padToAdd = 0 // Assume we have nothing to add
		      
		      if lastByte = 9 then // Special case
		        // See if the rest of the bytes are all eros
		        dim compareMB as new MemoryBlock( 8 )
		        compareMB.Byte( 7 ) = 9
		        if StrComp( data.StringValue( originalSize - 8, 8 ), compareMB, 0 ) = 0 then
		          padToAdd = 8 // This means that the last 8 bytes are all nulls followed by a 9, so add an 8-byte padding
		        end if
		        
		      elseif lastByte >= 2 and lastByte < 9 then // It's in the valid trigger range
		        dim compareMB as new MemoryBlock( lastByte )
		        compareMB.Byte( lastByte - 1 ) = lastByte
		        if StrComp( data.StringValue( originalSize - lastByte, lastByte ), compareMB, 0 ) = 0 then // The end of the data looks like a pad
		          padToAdd = 8 // Add a real pad
		        end if
		      end if
		    end if
		    
		    if padToAdd <> 0 then
		      dim newSize as integer = originalSize + padToAdd
		      data.Size = newSize
		      data.Byte( newSize - 1 ) = padToAdd
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

	#tag Method, Flags = &h21
		Private Sub RaiseNotOverriddenException(method As String)
		  dim err as new M_Crypto.NotOverriddenException
		  err.Message = "The method " + method + " must be overridden"
		  raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetVector()
		  zCurrentVector = ""
		  InitialVector = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetVector(vector As String)
		  if vector <> "" then
		    vector = InterpretVector( vector )
		    RaiseErrorIf( vector.LenB <> 8, kErrorVectorSize )
		  end if
		  
		  InitialVector = vector
		  
		End Sub
	#tag EndMethod


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

	#tag Property, Flags = &h1
		Protected WasKeySet As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected zCurrentVector As String
	#tag EndProperty


	#tag Constant, Name = kErrorKeyCannotBeEmpty, Type = String, Dynamic = False, Default = \"The key cannot be empty.", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kErrorVectorSize, Type = String, Dynamic = False, Default = \"Vector must be empty (will default to 8 nulls)\x2C or exactly 8 bytes or hexadecimal characters representing 8 bytes.", Scope = Public
	#tag EndConstant


	#tag Enum, Name = Padding, Type = Integer, Flags = &h0
		NullPadding
		PKCS5
	#tag EndEnum


	#tag ViewBehavior
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
				"0 - NullPadding"
				"1 - PKCS5"
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
	#tag EndViewBehavior
End Class
#tag EndClass
