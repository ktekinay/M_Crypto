#tag Module
Protected Module Scrypt_MTC
	#tag Method, Flags = &h21
		Private Sub BlockMix(ByRef mb As Xojo.Core.MutableMemoryBlock, ByRef mbPtr As Ptr, ByRef blockBuffer As Xojo.Core.MutableMemoryBlock, chunkBuffer As Xojo.Core.MutableMemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  //
		  // chunkBuffer.Size must be kBlockSize * 2
		  //
		  
		  dim mbSize as integer = mb.Size
		  dim mbMidpoint as integer = mbSize \ 2
		  dim x as Xojo.Core.MutableMemoryBlock = chunkBuffer
		  x.Left( kBlockSize ) = mb.Right( kBlockSize )
		  dim xPtr as ptr = x.Data
		  dim arrPtr as ptr = ptr( integer( xPtr ) + kBlockSize )
		  
		  dim result as Xojo.Core.MutableMemoryBlock = blockBuffer
		  dim resultEvenIndex as integer = 0
		  dim resultOddIndex as integer = mbMidpoint
		  dim resultIsEven as boolean = true
		  
		  dim lastByteIndex as integer = mbSize - 1
		  dim lastRawBlockIndex as integer = kBlockSize - 1
		  
		  for blockByteIndex as integer = 0 to lastByteIndex step kBlockSize
		    for rawByteIndex as integer = 0 to lastRawBlockIndex step 8
		      xPtr.UInt64( rawByteIndex ) = xPtr.UInt64( rawByteIndex ) xor mbPtr.UInt64( blockByteIndex + rawByteIndex )
		    next
		    
		    //
		    // Salsa is inlined here as an optimization
		    //
		    
		    x.Right( kBlockSize ) = x.Left( kBlockSize )
		    
		    for i as integer = 1 to 4
		      arrPtr.UInt32( 4 * 4 ) = arrPtr.UInt32( 4 * 4 ) xor ( ( ( arrPtr.UInt32( 4 * 0 ) + arrPtr.UInt32( 4 * 12 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 0 ) + arrPtr.UInt32( 4 * 12 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 8 ) = arrPtr.UInt32( 4 * 8 ) xor ( ( ( arrPtr.UInt32( 4 * 4 ) + arrPtr.UInt32( 4 * 0 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 4 ) + arrPtr.UInt32( 4 * 0 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 12 ) = arrPtr.UInt32( 4 * 12 ) xor ( ( ( arrPtr.UInt32( 4 * 8 ) + arrPtr.UInt32( 4 * 4 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 8 ) + arrPtr.UInt32( 4 * 4 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 0 ) = arrPtr.UInt32( 4 * 0 ) xor ( ( ( arrPtr.UInt32( 4 * 12 ) + arrPtr.UInt32( 4 * 8 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 12 ) + arrPtr.UInt32( 4 * 8 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 9 ) = arrPtr.UInt32( 4 * 9 ) xor ( ( ( arrPtr.UInt32( 4 * 5 ) + arrPtr.UInt32( 4 * 1 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 5 ) + arrPtr.UInt32( 4 * 1 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 13 ) = arrPtr.UInt32( 4 * 13 ) xor ( ( ( arrPtr.UInt32( 4 * 9 ) + arrPtr.UInt32( 4 * 5 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 9 ) + arrPtr.UInt32( 4 * 5 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 1 ) = arrPtr.UInt32( 4 * 1 ) xor ( ( ( arrPtr.UInt32( 4 * 13 ) + arrPtr.UInt32( 4 * 9 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 13 ) + arrPtr.UInt32( 4 * 9 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 5 ) = arrPtr.UInt32( 4 * 5 ) xor ( ( ( arrPtr.UInt32( 4 * 1 ) + arrPtr.UInt32( 4 * 13 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 1 ) + arrPtr.UInt32( 4 * 13 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 14 ) = arrPtr.UInt32( 4 * 14 ) xor ( ( ( arrPtr.UInt32( 4 * 10 ) + arrPtr.UInt32( 4 * 6 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 10 ) + arrPtr.UInt32( 4 * 6 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 2 ) = arrPtr.UInt32( 4 * 2 ) xor ( ( ( arrPtr.UInt32( 4 * 14 ) + arrPtr.UInt32( 4 * 10 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 14 ) + arrPtr.UInt32( 4 * 10 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 6 ) = arrPtr.UInt32( 4 * 6 ) xor ( ( ( arrPtr.UInt32( 4 * 2 ) + arrPtr.UInt32( 4 * 14 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 2 ) + arrPtr.UInt32( 4 * 14 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 10 ) = arrPtr.UInt32( 4 * 10 ) xor ( ( ( arrPtr.UInt32( 4 * 6 ) + arrPtr.UInt32( 4 * 2 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 6 ) + arrPtr.UInt32( 4 * 2 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 3 ) = arrPtr.UInt32( 4 * 3 ) xor ( ( ( arrPtr.UInt32( 4 * 15 ) + arrPtr.UInt32( 4 * 11 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 15 ) + arrPtr.UInt32( 4 * 11 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 7 ) = arrPtr.UInt32( 4 * 7 ) xor ( ( ( arrPtr.UInt32( 4 * 3 ) + arrPtr.UInt32( 4 * 15 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 3 ) + arrPtr.UInt32( 4 * 15 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 11 ) = arrPtr.UInt32( 4 * 11 ) xor ( ( ( arrPtr.UInt32( 4 * 7 ) + arrPtr.UInt32( 4 * 3 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 7 ) + arrPtr.UInt32( 4 * 3 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 15 ) = arrPtr.UInt32( 4 * 15 ) xor ( ( ( arrPtr.UInt32( 4 * 11 ) + arrPtr.UInt32( 4 * 7 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 11 ) + arrPtr.UInt32( 4 * 7 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 1 ) = arrPtr.UInt32( 4 * 1 ) xor ( ( ( arrPtr.UInt32( 4 * 0 ) + arrPtr.UInt32( 4 * 3 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 0 ) + arrPtr.UInt32( 4 * 3 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 2 ) = arrPtr.UInt32( 4 * 2 ) xor ( ( ( arrPtr.UInt32( 4 * 1 ) + arrPtr.UInt32( 4 * 0 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 1 ) + arrPtr.UInt32( 4 * 0 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 3 ) = arrPtr.UInt32( 4 * 3 ) xor ( ( ( arrPtr.UInt32( 4 * 2 ) + arrPtr.UInt32( 4 * 1 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 2 ) + arrPtr.UInt32( 4 * 1 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 0 ) = arrPtr.UInt32( 4 * 0 ) xor ( ( ( arrPtr.UInt32( 4 * 3 ) + arrPtr.UInt32( 4 * 2 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 3 ) + arrPtr.UInt32( 4 * 2 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 6 ) = arrPtr.UInt32( 4 * 6 ) xor ( ( ( arrPtr.UInt32( 4 * 5 ) + arrPtr.UInt32( 4 * 4 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 5 ) + arrPtr.UInt32( 4 * 4 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 7 ) = arrPtr.UInt32( 4 * 7 ) xor ( ( ( arrPtr.UInt32( 4 * 6 ) + arrPtr.UInt32( 4 * 5 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 6 ) + arrPtr.UInt32( 4 * 5 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 4 ) = arrPtr.UInt32( 4 * 4 ) xor ( ( ( arrPtr.UInt32( 4 * 7 ) + arrPtr.UInt32( 4 * 6 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 7 ) + arrPtr.UInt32( 4 * 6 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 5 ) = arrPtr.UInt32( 4 * 5 ) xor ( ( ( arrPtr.UInt32( 4 * 4 ) + arrPtr.UInt32( 4 * 7 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 4 ) + arrPtr.UInt32( 4 * 7 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 11 ) = arrPtr.UInt32( 4 * 11 ) xor ( ( ( arrPtr.UInt32( 4 * 10 ) + arrPtr.UInt32( 4 * 9 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 10 ) + arrPtr.UInt32( 4 * 9 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 8 ) = arrPtr.UInt32( 4 * 8 ) xor ( ( ( arrPtr.UInt32( 4 * 11 ) + arrPtr.UInt32( 4 * 10 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 11 ) + arrPtr.UInt32( 4 * 10 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 9 ) = arrPtr.UInt32( 4 * 9 ) xor ( ( ( arrPtr.UInt32( 4 * 8 ) + arrPtr.UInt32( 4 * 11 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 8 ) + arrPtr.UInt32( 4 * 11 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 10 ) = arrPtr.UInt32( 4 * 10 ) xor ( ( ( arrPtr.UInt32( 4 * 9 ) + arrPtr.UInt32( 4 * 8 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 9 ) + arrPtr.UInt32( 4 * 8 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 12 ) = arrPtr.UInt32( 4 * 12 ) xor ( ( ( arrPtr.UInt32( 4 * 15 ) + arrPtr.UInt32( 4 * 14 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 15 ) + arrPtr.UInt32( 4 * 14 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 13 ) = arrPtr.UInt32( 4 * 13 ) xor ( ( ( arrPtr.UInt32( 4 * 12 ) + arrPtr.UInt32( 4 * 15 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 12 ) + arrPtr.UInt32( 4 * 15 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 14 ) = arrPtr.UInt32( 4 * 14 ) xor ( ( ( arrPtr.UInt32( 4 * 13 ) + arrPtr.UInt32( 4 * 12 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 13 ) + arrPtr.UInt32( 4 * 12 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		      arrPtr.UInt32( 4 * 15 ) = arrPtr.UInt32( 4 * 15 ) xor ( ( ( arrPtr.UInt32( 4 * 14 ) + arrPtr.UInt32( 4 * 13 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arrPtr.UInt32( 4 * 14 ) + arrPtr.UInt32( 4 * 13 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    next
		    
		    dim byteIndex as integer = 0
		    for i as integer = 0 to 15
		      xPtr.UInt32( byteIndex ) = arrPtr.UInt32( byteIndex ) + xPtr.UInt32( byteIndex )
		      byteIndex = byteIndex + 4
		    next
		    
		    //
		    // End Salsa
		    //
		    
		    //
		    // The result must be written in this order
		    //
		    // 1, 2, 3, 4, 5, 6, ... will become 
		    // 1, 3, 5, ..., 2, 4, 6, ...
		    //
		    if resultIsEven then
		      result.Mid( resultEvenIndex, kBlockSize ) = x.Left( kBlockSize )
		      resultEvenIndex = resultEvenIndex + kBlockSize
		      resultIsEven = false
		    else
		      result.Mid( resultOddIndex, kBlockSize ) = x.Left( kBlockSize )
		      resultOddIndex = resultOddIndex + kBlockSize
		      resultIsEven = true
		    end if
		  next
		  
		  //
		  // Swap the blockBuffer (result) with the original mb
		  // which will become the new buffer. We can do this
		  // since they are the same size.
		  //
		  dim orig as Xojo.Core.MutableMemoryBlock = mb
		  mb = result
		  mbPtr = result.Data
		  blockBuffer = orig
		  
		  '1. X = B[2 * r - 1]
		  '
		  '2. for i = 0 to 2 * r - 1 do
		  'T = X xor B[i]
		  'X = Salsa (T)
		  'Y[i] = X
		  'end for
		  '
		  '3. B' = (Y[0], Y[2], ..., Y[2 * r - 2],
		  'Y[1], Y[3], ..., Y[2 * r - 1])
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Protected Function Hash(key As String, salt As MemoryBlock, cost As Integer = 4, outputLength As Integer = 64, blocks As Integer = 8, parallelization As Integer = 4) As String
		  if key.Encoding is nil then
		    if Encodings.UTF8.IsValidData( key ) then
		      key = key.DefineEncoding( Encodings.UTF8 )
		    else
		      key = key.DefineEncoding( Encodings.SystemDefault )
		    end if
		  end if
		  
		  dim mbSalt as new Xojo.Core.MemoryBlock( salt, salt.Size )
		  
		  dim result as Xojo.Core.MemoryBlock = Hash( key.ToText, mbSalt, cost, outputLength, blocks, parallelization )
		  
		  dim mb as MemoryBlock = result.Data
		  return mb.StringValue( 0, result.Size )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, CompatibilityFlags = (TargetIOS and (Target32Bit or Target64Bit))
		Protected Function Hash(key As Text, salt As Text, cost As Integer = 4, outputLength As Integer = 64, blocks As Integer = 8, parallelization As Integer = 4) As Xojo.Core.MemoryBlock
		  return Hash( key, Xojo.Core.TextEncoding.UTF8.ConvertTextToData( salt ), cost, outputLength, blocks, parallelization )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Hash(key As Text, salt As Xojo.Core.MemoryBlock, cost As Integer = 4, outputLength As Integer = 64, blocks As Integer = 8, parallelization As Integer = 4) As Xojo.Core.MemoryBlock
		  if key = "" then
		    return nil
		  end if
		  
		  if salt.Size = 0 then
		    dim err as new BadInputException
		    err.Message = "Salt must be specified"
		    raise err
		  end if
		  
		  dim n as UInt32 = 2 ^ cost
		  if n <= 1 or cost >= ( 128 * blocks / 8 ) then
		    dim err as new BadInputException
		    err.Message = "Cost must be greater than 1 and less than (data.Size/8)"
		    raise err
		  end if
		  
		  const kHLen = 32
		  dim mfLen as integer = 128 * blocks
		  dim p as integer = parallelization // Just easier
		  
		  if p > ( ( ( 2 ^ ( 32 - 1 ) ) * kHLen ) / mfLen ) then
		    dim err as new BadInputException
		    err.Message = "Parallelization value is too high"
		    raise err
		  end if
		  
		  if outputLength > ( ( 2 ^ ( 32 - 1 ) ) * kHLen ) then
		    dim err as new BadInputException
		    err.Message = "OutputLength value is too high"
		    raise err
		  end if
		  
		  dim mbKey as Xojo.Core.MemoryBlock = Xojo.Core.TextEncoding.UTF8.ConvertTextToData( key )
		  dim mainB as new Xojo.Core.MutableMemoryBlock( _
		  Xojo.Crypto.PBKDF2( salt, mbKey, 1, p * mfLen, Xojo.Crypto.HashAlgorithms.SHA256 ) )
		  
		  dim lastPIndex as integer = p - 1
		  dim block as new Xojo.Core.MutableMemoryBlock( mfLen )
		  dim blockBuffer as new Xojo.Core.MutableMemoryBlock( mfLen )
		  dim chunkBuffer as new Xojo.Core.MutableMemoryBlock( kBlockSize * 2 )
		  dim vBuffer as new Xojo.Core.MutableMemoryBlock( mfLen * n )
		  vBuffer.LittleEndian = true
		  chunkBuffer.LittleEndian = vBuffer.LittleEndian
		  blockBuffer.LittleEndian = vBuffer.LittleEndian
		  block.LittleEndian = vBuffer.LittleEndian
		  
		  for i as integer = 0 to lastPIndex
		    dim mainIndex as integer = i * mfLen
		    block.Left( mfLen ) = mainB.Mid( mainIndex, mfLen )
		    ROMix( block, n, blockBuffer, chunkBuffer, vBuffer )
		    mainB.Mid( mainIndex, mfLen ) = block
		  next
		  
		  dim outMB as Xojo.Core.MemoryBlock = Xojo.Crypto.PBKDF2( mainB, mbKey, 1, outputLength, Xojo.Crypto.HashAlgorithms.SHA256 )
		  return outMB
		  
		  'The PBKDF2-HMAC-SHA-256 function used below denotes the PBKDF2
		  'algorithm [RFC2898] used with HMAC-SHA-256 [RFC6234] as the
		  'Pseudorandom Function (PRF).  The HMAC-SHA-256 function generates
		  '32-octet outputs.
		  '
		  'Algorithm scrypt
		  '
		  'Input:
		  'P       Passphrase, an octet string.
		  'S       Salt, an octet string.
		  'N       CPU/Memory cost parameter, must be larger than 1,
		  'a power of 2, and less than 2^(128 * r / 8).
		  'r       Block size parameter.
		  'p       Parallelization parameter, a positive integer
		  'less than or equal to ((2^32-1) * hLen) / MFLen
		  'where hLen is 32 and MFlen is 128 * r.
		  'dkLen   Intended output length in octets of the derived
		  'key; a positive integer less than or equal to
		  '(2^32 - 1) * hLen where hLen is 32.
		  '
		  'Output:
		  'DK      Derived key, of length dkLen octets.
		  '
		  'Steps:
		  '
		  '1. Initialize an array B consisting of p blocks of 128 * r octets
		  'each:
		  'B[0] || B[1] || ... || B[p - 1] =
		  'PBKDF2-HMAC-SHA256 (P, S, 1, p * 128 * r)
		  '
		  '2. for i = 0 to p - 1 do
		  'B[i] = scryptROMix (r, B[i], N)
		  'end for
		  '
		  '3. DK = PBKDF2-HMAC-SHA256 (P, B[0] || B[1] || ... || B[p - 1],
		  '1, dkLen)
		  '
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ROMix(ByRef mb As Xojo.Core.MutableMemoryBlock, n As UInt32, ByRef blockBuffer As Xojo.Core.MutableMemoryBlock, chunkBuffer As Xojo.Core.MutableMemoryBlock, vBuffer As Xojo.Core.MutableMemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  dim mbSize as integer = mb.Size
		  dim mbPtr as ptr = mb.Data
		  
		  dim v as Xojo.Core.MutableMemoryBlock = vBuffer
		  dim vPtr as ptr = v.Data
		  
		  dim lastNIndex as integer = n - 1
		  for i as integer = 0 to lastNIndex
		    v.Mid( i * mbSize, mbSize ) = mb
		    BlockMix( mb, mbPtr, blockBuffer, chunkBuffer )
		  next
		  
		  dim lastWordIndex as integer = mbSize - 64
		  dim lastMBByteIndex as integer = mbSize - 1
		  dim lastWord as UInt32
		  for i as integer = 0 to lastNIndex
		    #if TargetLittleEndian then
		      lastWord = mbPtr.UInt32( lastWordIndex )
		    #else
		      // Must use the mb function to honor endiness
		      lastWord = mb.UInt32Value( lastWordIndex )
		    #endif
		    
		    dim j as integer = lastWord mod n
		    dim start as integer = j * mbSize
		    for byteIndex as integer = 0 to lastMBByteIndex step 8
		      mbPtr.UInt64( byteIndex ) = mbPtr.UInt64( byteIndex ) xor vPtr.UInt64( byteIndex + start )
		    next
		    BlockMix( mb, mbPtr, blockBuffer, chunkBuffer )
		  next
		  
		  'The scryptROMix algorithm is the same as the ROMix algorithm
		  'described in [SCRYPT] but with scryptBlockMix used as the hash
		  'function H and the Integerify function explained inline.
		  '
		  'Algorithm scryptROMix
		  '
		  'Input:
		  'r       Block size parameter.
		  'B       Input octet vector of length 128 * r octets.
		  'N       CPU/Memory cost parameter, must be larger than 1,
		  'a power of 2, and less than 2^(128 * r / 8).
		  '
		  'Output:
		  'B'      Output octet vector of length 128 * r octets.
		  '
		  'Steps:
		  '
		  '1. X = B
		  '
		  '2. for i = 0 to N - 1 do
		  'V[i] = X
		  'X = scryptBlockMix (X)
		  'end for
		  '
		  '3. for i = 0 to N - 1 do
		  'j = Integerify (X) mod N
		  'where Integerify (B[0] ... B[2 * r - 1]) is defined
		  'as the result of interpreting B[2 * r - 1] as a
		  'little-endian integer.
		  'T = X xor V[j]
		  'X = scryptBlockMix (T)
		  'end for
		  '
		  '4. B' = X
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Salsa(p As Ptr)
		  //
		  // This function has been inlined into BlockMix as an optimization.
		  // It remains here for testing purposes
		  //
		  
		  dim arr( 15 ) as UInt32
		  
		  for i as integer = 0 to 15
		    arr( i ) = p.UInt32( i * 4 )
		  next
		  
		  for i as integer = 1 to 4
		    arr( 4 ) = arr( 4 ) xor ( ( ( arr( 0 ) + arr( 12 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 0 ) + arr( 12 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 8 ) = arr( 8 ) xor ( ( ( arr( 4 ) + arr( 0 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 4 ) + arr( 0 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 12 ) = arr( 12 ) xor ( ( ( arr( 8 ) + arr( 4 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 8 ) + arr( 4 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 0 ) = arr( 0 ) xor ( ( ( arr( 12 ) + arr( 8 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 12 ) + arr( 8 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 9 ) = arr( 9 ) xor ( ( ( arr( 5 ) + arr( 1 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 5 ) + arr( 1 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 13 ) = arr( 13 ) xor ( ( ( arr( 9 ) + arr( 5 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 9 ) + arr( 5 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 1 ) = arr( 1 ) xor ( ( ( arr( 13 ) + arr( 9 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 13 ) + arr( 9 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 5 ) = arr( 5 ) xor ( ( ( arr( 1 ) + arr( 13 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 1 ) + arr( 13 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 14 ) = arr( 14 ) xor ( ( ( arr( 10 ) + arr( 6 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 10 ) + arr( 6 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 2 ) = arr( 2 ) xor ( ( ( arr( 14 ) + arr( 10 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 14 ) + arr( 10 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 6 ) = arr( 6 ) xor ( ( ( arr( 2 ) + arr( 14 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 2 ) + arr( 14 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 10 ) = arr( 10 ) xor ( ( ( arr( 6 ) + arr( 2 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 6 ) + arr( 2 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 3 ) = arr( 3 ) xor ( ( ( arr( 15 ) + arr( 11 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 15 ) + arr( 11 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 7 ) = arr( 7 ) xor ( ( ( arr( 3 ) + arr( 15 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 3 ) + arr( 15 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 11 ) = arr( 11 ) xor ( ( ( arr( 7 ) + arr( 3 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 7 ) + arr( 3 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 15 ) = arr( 15 ) xor ( ( ( arr( 11 ) + arr( 7 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 11 ) + arr( 7 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 1 ) = arr( 1 ) xor ( ( ( arr( 0 ) + arr( 3 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 0 ) + arr( 3 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 2 ) = arr( 2 ) xor ( ( ( arr( 1 ) + arr( 0 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 1 ) + arr( 0 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 3 ) = arr( 3 ) xor ( ( ( arr( 2 ) + arr( 1 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 2 ) + arr( 1 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 0 ) = arr( 0 ) xor ( ( ( arr( 3 ) + arr( 2 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 3 ) + arr( 2 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 6 ) = arr( 6 ) xor ( ( ( arr( 5 ) + arr( 4 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 5 ) + arr( 4 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 7 ) = arr( 7 ) xor ( ( ( arr( 6 ) + arr( 5 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 6 ) + arr( 5 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 4 ) = arr( 4 ) xor ( ( ( arr( 7 ) + arr( 6 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 7 ) + arr( 6 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 5 ) = arr( 5 ) xor ( ( ( arr( 4 ) + arr( 7 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 4 ) + arr( 7 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 11 ) = arr( 11 ) xor ( ( ( arr( 10 ) + arr( 9 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 10 ) + arr( 9 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 8 ) = arr( 8 ) xor ( ( ( arr( 11 ) + arr( 10 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 11 ) + arr( 10 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 9 ) = arr( 9 ) xor ( ( ( arr( 8 ) + arr( 11 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 8 ) + arr( 11 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 10 ) = arr( 10 ) xor ( ( ( arr( 9 ) + arr( 8 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 9 ) + arr( 8 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		    arr( 12 ) = arr( 12 ) xor ( ( ( arr( 15 ) + arr( 14 ) ) * CType( 2 ^ 7, UInt32 ) ) or ( ( arr( 15 ) + arr( 14 ) ) \ CType( 2 ^ ( 32 - 7 ), UInt32 ) ) )
		    arr( 13 ) = arr( 13 ) xor ( ( ( arr( 12 ) + arr( 15 ) ) * CType( 2 ^ 9, UInt32 ) ) or ( ( arr( 12 ) + arr( 15 ) ) \ CType( 2 ^ ( 32 - 9 ), UInt32 ) ) )
		    arr( 14 ) = arr( 14 ) xor ( ( ( arr( 13 ) + arr( 12 ) ) * CType( 2 ^ 13, UInt32 ) ) or ( ( arr( 13 ) + arr( 12 ) ) \ CType( 2 ^ ( 32 - 13 ), UInt32 ) ) )
		    arr( 15 ) = arr( 15 ) xor ( ( ( arr( 14 ) + arr( 13 ) ) * CType( 2 ^ 18, UInt32 ) ) or ( ( arr( 14 ) + arr( 13 ) ) \ CType( 2 ^ ( 32 - 18 ), UInt32 ) ) )
		  next
		  
		  dim byteIndex as integer
		  for i as integer = 0 to 15
		    p.UInt32( byteIndex ) = arr( i ) + p.UInt32( byteIndex )
		    byteIndex = byteIndex + 4
		  next
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = Scrypt Specs
		
		Specs can be found in RFC 7914:
		
		https://www.rfc-editor.org/rfc/rfc7914.txt
		
		Wikipedia article:
		
		https://en.wikipedia.org/wiki/Scrypt
	#tag EndNote


	#tag Constant, Name = kBlockSize, Type = Double, Dynamic = False, Default = \"64", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.5.3", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Module
#tag EndModule
