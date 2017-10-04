#tag Module
Protected Module Scrypt_MTC
	#tag Method, Flags = &h21
		Private Sub BlockMix(ByRef mb As Xojo.Core.MutableMemoryBlock)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  const kBlockSize as integer = 64
		  
		  dim mbSize as integer = mb.Size
		  dim mbMidpoint as integer = mbSize \ 2
		  
		  dim x as new Xojo.Core.MutableMemoryBlock( mb.Right( kBlockSize ) )
		  dim xPtr as ptr = x.Data
		  
		  dim mbPtr as Ptr = mb.Data
		  
		  dim result as new Xojo.Core.MutableMemoryBlock( mb.Size )
		  dim resultEvenIndex as integer = 0
		  dim resultOddIndex as integer = mbMidpoint
		  dim resultIsEven as boolean = true
		  
		  dim lastByteIndex as integer = mbSize - 1
		  dim lastRawBlockIndex as integer = kBlockSize - 1
		  dim arr( 15 ) as UInt32
		  
		  for blockByteIndex as integer = 0 to lastByteIndex step kBlockSize
		    for rawByteIndex as integer = 0 to lastRawBlockIndex step 8
		      xPtr.UInt64( rawByteIndex ) = xPtr.UInt64( rawByteIndex ) xor mbPtr.UInt64( blockByteIndex + rawByteIndex )
		    next
		    
		    //
		    // Salsa is unrolled here as an optimization
		    //
		    
		    for i as integer = 0 to 15
		      arr( i ) = xPtr.UInt32( i * 4 )
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
		      xPtr.UInt32( byteIndex ) = arr( i ) + xPtr.UInt32( byteIndex )
		      byteIndex = byteIndex + 4
		    next
		    
		    //
		    // End Salsa
		    //
		    
		    if resultIsEven then
		      result.Mid( resultEvenIndex, kBlockSize ) = x
		      resultEvenIndex = resultEvenIndex + kBlockSize
		      resultIsEven = false
		    else
		      result.Mid( resultOddIndex, kBlockSize ) = x
		      resultOddIndex = resultOddIndex + kBlockSize
		      resultIsEven = true
		    end if
		  next
		  
		  mb = result
		  
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

	#tag Method, Flags = &h1
		Protected Function Hash(key As String, salt As MemoryBlock, cost As Integer = 4, outputLength As Integer = 64, blocks As Integer = 8, parallelization As Integer = 4) As String
		  dim temp as new Xojo.Core.MemoryBlock( salt )
		  dim mbSalt as Xojo.Core.MemoryBlock = temp.Left( salt.Size )
		  
		  dim result as Xojo.Core.MemoryBlock = Hash( key.ToText, mbSalt, cost, outputLength, blocks, parallelization )
		  dim mb as MemoryBlock = result.Data
		  return mb.StringValue( 0, result.Size )
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
		  
		  dim n as integer = 2 ^ cost
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
		  dim b as new Xojo.Core.MutableMemoryBlock( mfLen )
		  for i as integer = 0 to lastPIndex
		    b.Left( mfLen ) = mainB.Mid( i * mfLen, mfLen )
		    ROMix( b, n )
		    mainB.Mid( i * b.Size, b.Size ) = b
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
		Private Sub ROMix(ByRef mb As Xojo.Core.MutableMemoryBlock, n As Integer)
		  #if not DebugBuild
		    #pragma BackgroundTasks False
		    #pragma BoundsChecking False
		    #pragma NilObjectChecking False
		    #pragma StackOverflowChecking False
		  #endif
		  
		  const kIsLittleEndian as boolean = true
		  
		  dim mbSize as integer = mb.Size
		  mb.LittleEndian = kIsLittleEndian
		  dim mbPtr as ptr = mb.Data
		  
		  dim v as new Xojo.Core.MutableMemoryBlock( mbSize * n )
		  v.LittleEndian = kIsLittleEndian
		  
		  dim lastNIndex as integer = n - 1
		  for i as integer = 0 to lastNIndex
		    v.Mid( i * mbSize, mbSize ) = mb
		    BlockMix( mb )
		  next
		  
		  dim vPtr as ptr = v.Data
		  
		  dim lastWordIndex as integer = mbSize - 64
		  dim lastMBByteIndex as integer = mbSize - 1
		  for i as integer = 0 to lastNIndex
		    mbPtr = mb.Data
		    dim lastWord as Int64 = mbPtr.UInt32( lastWordIndex )
		    dim j as integer = lastWord mod CType( n, Int64 )
		    dim start as integer = j * mbSize
		    for byteIndex as integer = 0 to lastMBByteIndex step 8
		      mbPtr.UInt64( byteIndex ) = mbPtr.UInt64( byteIndex ) xor vPtr.UInt64( byteIndex + start )
		    next
		    BlockMix( mb )
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
		  // This function has been unrolled into BlockMix as an optimization.
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


	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.0", Scope = Protected
	#tag EndConstant


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
