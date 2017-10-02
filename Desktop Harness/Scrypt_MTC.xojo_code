#tag Module
Protected Module Scrypt_MTC
	#tag Method, Flags = &h21
		Private Function BlockMix(mbIn As MemoryBlock) As MemoryBlock
		  if ( mbIn.Size mod 128 ) <> 0 then
		    dim err as new BadInputException
		    err.Message = "Data must be a multiple of 128"
		    raise err
		  end if
		  
		  dim y as new MemoryBlock( mbIn.Size )
		  const kBlockSize as integer = 64
		  
		  dim x as MemoryBlock = mbIn.StringValue( mbIn.Size - kBlockSize, kBlockSize )
		  
		  dim lastByteIndex as integer = mbIn.Size - 1
		  dim lastRawBlockIndex as integer = kBlockSize - 1
		  
		  for blockByteIndex as integer = 0 to lastByteIndex step kBlockSize
		    for rawByteIndex as integer = 0 to lastRawBlockIndex step 8
		      x.UInt64Value( rawByteIndex ) = x.UInt64Value( rawByteIndex ) xor mbIn.UInt64Value( blockByteIndex + rawByteIndex )
		    next
		    x = Salsa( x )
		    y.StringValue( blockByteIndex, kBlockSize ) = x
		  next
		  
		  dim lastYBlockIndex as integer = y.Size - 1
		  dim stepper as integer = kBlockSize * 2
		  dim mbOut as new MemoryBlock( mbIn.Size )
		  dim mbOutByteIndex as integer
		  for blockByteIndex as integer = 0 to lastYBlockIndex step stepper
		    mbOut.StringValue( mbOutByteIndex, kBlockSize ) = y.StringValue( blockByteIndex, kBlockSize )
		    mbOutByteIndex = mbOutByteIndex + kBlockSize
		  next
		  
		  for blockByteIndex as integer = kBlockSize to lastYBlockIndex step stepper
		    mbOut.StringValue( mbOutByteIndex, kBlockSize ) = y.StringValue( blockByteIndex, kBlockSize )
		    mbOutByteIndex = mbOutByteIndex + kBlockSize
		  next
		  
		  return mbOut
		  
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
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Hash(key As MemoryBlock, salt As String, cost As Integer, outputLength As Integer = 64, blocks As Integer = 1, parallelization As Integer = 1) As String
		  if key.Size = 0 then
		    return ""
		  end if
		  
		  if salt = "" then
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
		  
		  dim mainB as MemoryBlock = Crypto.PBKDF2( salt, key, 1, p * mfLen, Crypto.Algorithm.SHA256 )
		  
		  dim combinedB as new MemoryBlock( mainB.Size )
		  dim lastPIndex as integer = p - 1
		  for i as integer = 0 to lastPIndex
		    dim b as MemoryBlock = mainB.StringValue( i * mfLen, mfLen )
		    b = ROMix( b, n )
		    combinedB.StringValue( i * b.Size, b.Size ) = b
		  next
		  
		  dim out as string = Crypto.PBKDF2( combinedB, key, 1, outputLength, Crypto.Algorithm.SHA256 )
		  return out
		  
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
		Private Function ROMix(mbIn As MemoryBlock, n As Integer) As MemoryBlock
		  if ( mbIn.Size mod 128 ) <> 0 then
		    dim err as new BadInputException
		    err.Message = "Data must be a multiple of 128"
		    raise err
		  end if
		  
		  dim isLittleEndian as boolean = true
		  
		  dim x as new MemoryBlock( mbIn.Size )
		  x.StringValue( 0, mbIn.Size ) = mbIn
		  
		  x.LittleEndian = isLittleEndian
		  dim xSize as integer = x.Size
		  
		  dim v() as MemoryBlock
		  dim lastNIndex as integer = n - 1
		  for i as integer = 0 to lastNIndex
		    v.Append x
		    x = BlockMix( x )
		    x.LittleEndian = isLittleEndian
		  next
		  
		  dim lastXByteIndex as integer = xSize - 1
		  for i as integer = 0 to lastNIndex
		    dim lastWord as Int64 = x.UInt32Value( xSize - 64 )
		    dim j as integer = lastWord mod CType( n, Int64 )
		    dim thisV as MemoryBlock = v( j )
		    for byteIndex as integer = 0 to lastXByteIndex step 8
		      x.UInt64Value( byteIndex ) = x.UInt64Value( byteIndex ) xor thisV.UInt64Value( byteIndex )
		    next
		    x = BlockMix( x )
		    x.LittleEndian = isLittleEndian
		  next
		  
		  return x
		  
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
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Salsa(mbIn As MemoryBlock) As MemoryBlock
		  dim x( 15 ) as UInt32
		  
		  dim pIn as Ptr = mbIn
		  
		  for i as integer = 0 to 15
		    x( i ) = pIn.UInt32( i * 4 )
		  next
		  
		  for i as integer = 1 to 4
		    x( 4 ) = x( 4 ) xor ( Bitwise.ShiftLeft( x( 0 ) + x( 12 ), 7, 32 ) or Bitwise.ShiftRight( x( 0 ) + x( 12 ), 32 - 7, 32 ) )
		    x( 8 ) = x( 8 ) xor ( Bitwise.ShiftLeft( x( 4 ) + x( 0 ), 9, 32 ) or Bitwise.ShiftRight( x( 4 ) + x( 0 ), 32 - 9, 32 ) )
		    x( 12 ) = x( 12 ) xor ( Bitwise.ShiftLeft( x( 8 ) + x( 4 ), 13, 32 ) or Bitwise.ShiftRight( x( 8 ) + x( 4 ), 32 - 13, 32 ) )
		    x( 0 ) = x( 0 ) xor ( Bitwise.ShiftLeft( x( 12 ) + x( 8 ), 18, 32 ) or Bitwise.ShiftRight( x( 12 ) + x( 8 ), 32 - 18, 32 ) )
		    x( 9 ) = x( 9 ) xor ( Bitwise.ShiftLeft( x( 5 ) + x( 1 ), 7, 32 ) or Bitwise.ShiftRight( x( 5 ) + x( 1 ), 32 - 7, 32 ) )
		    x( 13 ) = x( 13 ) xor ( Bitwise.ShiftLeft( x( 9 ) + x( 5 ), 9, 32 ) or Bitwise.ShiftRight( x( 9 ) + x( 5 ), 32 - 9, 32 ) )
		    x( 1 ) = x( 1 ) xor ( Bitwise.ShiftLeft( x( 13 ) + x( 9 ), 13, 32 ) or Bitwise.ShiftRight( x( 13 ) + x( 9 ), 32 - 13, 32 ) )
		    x( 5 ) = x( 5 ) xor ( Bitwise.ShiftLeft( x( 1 ) + x( 13 ), 18, 32 ) or Bitwise.ShiftRight( x( 1 ) + x( 13 ), 32 - 18, 32 ) )
		    x( 14 ) = x( 14 ) xor ( Bitwise.ShiftLeft( x( 10 ) + x( 6 ), 7, 32 ) or Bitwise.ShiftRight( x( 10 ) + x( 6 ), 32 - 7, 32 ) )
		    x( 2 ) = x( 2 ) xor ( Bitwise.ShiftLeft( x( 14 ) + x( 10 ), 9, 32 ) or Bitwise.ShiftRight( x( 14 ) + x( 10 ), 32 - 9, 32 ) )
		    x( 6 ) = x( 6 ) xor ( Bitwise.ShiftLeft( x( 2 ) + x( 14 ), 13, 32 ) or Bitwise.ShiftRight( x( 2 ) + x( 14 ), 32 - 13, 32 ) )
		    x( 10 ) = x( 10 ) xor ( Bitwise.ShiftLeft( x( 6 ) + x( 2 ), 18, 32 ) or Bitwise.ShiftRight( x( 6 ) + x( 2 ), 32 - 18, 32 ) )
		    x( 3 ) = x( 3 ) xor ( Bitwise.ShiftLeft( x( 15 ) + x( 11 ), 7, 32 ) or Bitwise.ShiftRight( x( 15 ) + x( 11 ), 32 - 7, 32 ) )
		    x( 7 ) = x( 7 ) xor ( Bitwise.ShiftLeft( x( 3 ) + x( 15 ), 9, 32 ) or Bitwise.ShiftRight( x( 3 ) + x( 15 ), 32 - 9, 32 ) )
		    x( 11 ) = x( 11 ) xor ( Bitwise.ShiftLeft( x( 7 ) + x( 3 ), 13, 32 ) or Bitwise.ShiftRight( x( 7 ) + x( 3 ), 32 - 13, 32 ) )
		    x( 15 ) = x( 15 ) xor ( Bitwise.ShiftLeft( x( 11 ) + x( 7 ), 18, 32 ) or Bitwise.ShiftRight( x( 11 ) + x( 7 ), 32 - 18, 32 ) )
		    x( 1 ) = x( 1 ) xor ( Bitwise.ShiftLeft( x( 0 ) + x( 3 ), 7, 32 ) or Bitwise.ShiftRight( x( 0 ) + x( 3 ), 32 - 7, 32 ) )
		    x( 2 ) = x( 2 ) xor ( Bitwise.ShiftLeft( x( 1 ) + x( 0 ), 9, 32 ) or Bitwise.ShiftRight( x( 1 ) + x( 0 ), 32 - 9, 32 ) )
		    x( 3 ) = x( 3 ) xor ( Bitwise.ShiftLeft( x( 2 ) + x( 1 ), 13, 32 ) or Bitwise.ShiftRight( x( 2 ) + x( 1 ), 32 - 13, 32 ) )
		    x( 0 ) = x( 0 ) xor ( Bitwise.ShiftLeft( x( 3 ) + x( 2 ), 18, 32 ) or Bitwise.ShiftRight( x( 3 ) + x( 2 ), 32 - 18, 32 ) )
		    x( 6 ) = x( 6 ) xor ( Bitwise.ShiftLeft( x( 5 ) + x( 4 ), 7, 32 ) or Bitwise.ShiftRight( x( 5 ) + x( 4 ), 32 - 7, 32 ) )
		    x( 7 ) = x( 7 ) xor ( Bitwise.ShiftLeft( x( 6 ) + x( 5 ), 9, 32 ) or Bitwise.ShiftRight( x( 6 ) + x( 5 ), 32 - 9, 32 ) )
		    x( 4 ) = x( 4 ) xor ( Bitwise.ShiftLeft( x( 7 ) + x( 6 ), 13, 32 ) or Bitwise.ShiftRight( x( 7 ) + x( 6 ), 32 - 13, 32 ) )
		    x( 5 ) = x( 5 ) xor ( Bitwise.ShiftLeft( x( 4 ) + x( 7 ), 18, 32 ) or Bitwise.ShiftRight( x( 4 ) + x( 7 ), 32 - 18, 32 ) )
		    x( 11 ) = x( 11 ) xor ( Bitwise.ShiftLeft( x( 10 ) + x( 9 ), 7, 32 ) or Bitwise.ShiftRight( x( 10 ) + x( 9 ), 32 - 7, 32 ) )
		    x( 8 ) = x( 8 ) xor ( Bitwise.ShiftLeft( x( 11 ) + x( 10 ), 9, 32 ) or Bitwise.ShiftRight( x( 11 ) + x( 10 ), 32 - 9, 32 ) )
		    x( 9 ) = x( 9 ) xor ( Bitwise.ShiftLeft( x( 8 ) + x( 11 ), 13, 32 ) or Bitwise.ShiftRight( x( 8 ) + x( 11 ), 32 - 13, 32 ) )
		    x( 10 ) = x( 10 ) xor ( Bitwise.ShiftLeft( x( 9 ) + x( 8 ), 18, 32 ) or Bitwise.ShiftRight( x( 9 ) + x( 8 ), 32 - 18, 32 ) )
		    x( 12 ) = x( 12 ) xor ( Bitwise.ShiftLeft( x( 15 ) + x( 14 ), 7, 32 ) or Bitwise.ShiftRight( x( 15 ) + x( 14 ), 32 - 7, 32 ) )
		    x( 13 ) = x( 13 ) xor ( Bitwise.ShiftLeft( x( 12 ) + x( 15 ), 9, 32 ) or Bitwise.ShiftRight( x( 12 ) + x( 15 ), 32 - 9, 32 ) )
		    x( 14 ) = x( 14 ) xor ( Bitwise.ShiftLeft( x( 13 ) + x( 12 ), 13, 32 ) or Bitwise.ShiftRight( x( 13 ) + x( 12 ), 32 - 13, 32 ) )
		    x( 15 ) = x( 15 ) xor ( Bitwise.ShiftLeft( x( 14 ) + x( 13 ), 18, 32 ) or Bitwise.ShiftRight( x( 14 ) + x( 13 ), 32 - 18, 32 ) )
		  next
		  
		  dim mbOut as new MemoryBlock( mbIn.Size )
		  dim pOut as Ptr = mbOut
		  
		  for i as integer = 0 to 15
		    dim byteIndex as integer = i * 4
		    pOut.UInt32( byteIndex ) = x( i ) + pIn.UInt32( byteIndex )
		  next
		  
		  return mbOut
		  
		End Function
	#tag EndMethod


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
