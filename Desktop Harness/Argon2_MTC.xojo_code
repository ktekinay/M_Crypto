#tag Module
Protected Module Argon2_MTC
	#tag Method, Flags = &h21
		Private Sub Blake2bHash(outMB As MemoryBlock, data As MemoryBlock)
		  var outSize as integer = outMB.Size
		  
		  var blakeSize as integer = min( Blake2bDigest_MTC.kMaxLength, outSize )
		  var blake as new Blake2bDigest_MTC( blakeSize )
		  
		  var buffer as new MemoryBlock( Blake2bDigest_MTC.kMaxLength )
		  buffer.LittleEndian = true
		  
		  buffer.UInt32Value( 0 ) = outMB.Size
		  blake.Process buffer.StringValue( 0, 4 )
		  blake.Process data
		  
		  if outSize <= Blake2bDigest_MTC.kMaxLength then
		    blake.CopyTo outMB
		    return
		  end if
		  
		  blake.CopyTo buffer
		  blake.Reset
		  
		  outMB.CopyBytes buffer, 0, 32
		  
		  var lastByteIndex as integer = outSize - Blake2bDigest_MTC.kMaxLength - 1
		  
		  var startByteIndex as integer = 32
		  var byteIndex as integer 
		  for byteIndex = startByteIndex to lastByteIndex step 32
		    blake.Process buffer
		    blake.CopyTo buffer
		    blake.Reset
		    
		    outMB.CopyBytes buffer, 0, 32, byteIndex
		  next
		  
		  if ( outSize mod Blake2bDigest_MTC.kMaxLength ) <> 0 then
		    var r as integer = ( ( outSize + 31 ) / 32 ) - 2
		    blake = new Blake2bDigest_MTC( outSize - 32 * r )
		  end if
		  
		  blake.Process buffer
		  blake.CopyTo outMB, byteIndex
		  
		  ' func blake2bHash(out []byte, in []byte) {
		  '     var b2 hash.Hash
		  '     if n := len(out); n < blake2b.Size {
		  '         b2, _ = blake2b.New(n, nil)
		  '     } else {
		  '         b2, _ = blake2b.New512(nil)
		  '     }
		  ' 
		  '     var buffer [blake2b.Size]byte
		  '     binary.LittleEndian.PutUint32(buffer[:4], uint32(len(out)))
		  '     b2.Write(buffer[:4])
		  '     b2.Write(in)
		  ' 
		  '     if len(out) <= blake2b.Size {
		  '         b2.Sum(out[:0])
		  '         return
		  '     }
		  ' 
		  '     outLen := len(out)
		  '     b2.Sum(buffer[:0])
		  '     b2.Reset()
		  '     copy(out, buffer[:32]) // dest, src
		  '     out = out[32:]
		  '     for len(out) > blake2b.Size {
		  '         b2.Write(buffer[:])
		  '         b2.Sum(buffer[:0])
		  '         copy(out, buffer[:32])
		  '         out = out[32:]
		  '         b2.Reset()
		  '     }
		  ' 
		  '     if outLen%blake2b.Size > 0 { // outLen > 64
		  '         r := ((outLen + 31) / 32) - 2 // ⌈τ /32⌉-2
		  '         b2, _ = blake2b.New(outLen-32*r, nil)
		  '     }
		  '     b2.Write(buffer[:])
		  '     b2.Sum(out[:0])
		  ' }
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Hash(type As Argon2_MTC.Types, password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String, associatedData As String) As String
		  //
		  // Test parameters
		  //
		  TestValues password, salt, hashLength, parallelism, memoryKB, iterations, secret, associatedData
		  
		  //
		  // Get the data to hash
		  //
		  var buffer as MemoryBlock = ToBuffer( type, password, salt, hashLength, parallelism, memoryKB, iterations, secret, associatedData )
		  
		  var blake as new Blake2bDigest_MTC( Blake2bDigest_MTC.kMaxLength )
		  blake.Process buffer
		  var h0 as new MemoryBlock( Blake2bDigest_MTC.KMaxLength + 8 )
		  h0.StringValue( 0, Blake2bDigest_MTC.kMaxLength ) = blake.Value
		  
		  var memory as double = memoryKB / ( kSyncPoints * parallelism ) * ( kSyncPoints * parallelism ) // Make sure it's a multiple
		  memory = max( memory, 2 * kSyncPoints * parallelism )
		  
		  var blocks() as MemoryBlock = InitBlocks( h0, memory, parallelism )
		  
		  return ""
		  return ""
		  
		  ' memory = memory / (syncPoints * uint32(threads)) * (syncPoints * uint32(threads))
		  ' if memory < 2*syncPoints*uint32(threads) {
		  '   memory = 2 * syncPoints * uint32(threads)
		  ' } 
		  ' B := initBlocks(&h0, memory, uint32(threads))
		  ' processBlocks(B, time, memory, uint32(threads), mode)
		  ' return extractKey(B, memory, uint32(threads), keyLen)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Hash2d(password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String = "", associatedData As String = "") As String
		  return Hash( Argon2_MTC.Types.D, _
		  password, _
		  salt, _
		  hashLength, _
		  parallelism, _
		  memoryKB, _
		  iterations, _
		  secret, _
		  associatedData _
		  )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Hash2i(password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String = "", associatedData As String = "") As String
		  return Hash( Argon2_MTC.Types.D, _
		  password, _
		  salt, _
		  hashLength, _
		  parallelism, _
		  memoryKB, _
		  iterations, _
		  secret, _
		  associatedData _
		  )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Hash2id(password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String = "", associatedData As String = "") As String
		  return Hash( Argon2_MTC.Types.D, _
		  password, _
		  salt, _
		  hashLength, _
		  parallelism, _
		  memoryKB, _
		  iterations, _
		  secret, _
		  associatedData _
		  )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function InitBlocks(h0 As MemoryBlock, memory As Integer, parallelism As Integer) As MemoryBlock()
		  const kBlockSize as integer = 128 * 8
		  const kLastBlockIndex as integer = kBlockSize - 1
		  
		  var blake as new Blake2bDigest_MTC
		  
		  var block0 as new MemoryBlock( kBlockSize )
		  block0.LittleEndian = true
		  
		  var laneMult as integer = memory / parallelism
		  
		  var blocks() as MemoryBlock
		  blocks.ResizeTo memory
		  
		  for i as integer = 0 to blocks.LastIndex
		    var thisBlock as new MemoryBlock( kBlockSize )
		    thisBlock.LittleEndian = true
		    blocks( i ) = thisBlock
		  next
		  
		  var lastLaneIndex as integer = parallelism - 1
		  for lane as integer = 0 to lastLaneIndex
		    var j as integer = lane * laneMult
		    
		    h0.UInt32Value( Blake2bDigest_MTC.kMaxLength + 4 ) = lane
		    
		    h0.UInt32Value( Blake2bDigest_MTC.kMaxLength ) = 0
		    Blake2bHash block0, h0
		    
		    var thisBlock as MemoryBlock = blocks( j )
		    thisBlock.CopyBytes block0, 0, kBlockSize
		    
		    h0.UInt32Value( Blake2bDigest_MTC.kMaxLength ) = 1
		    Blake2bHash block0, h0
		    
		    thisBlock = blocks( j + 1 )
		    thisBlock.CopyBytes block0, 0, kBlockSize
		  next
		  
		  return blocks
		  
		  
		  ' func initBlocks(h0 *[blake2b.Size + 8]byte, memory, threads uint32) []block {
		  '     var block0 [1024]byte
		  '     B := make([]block, memory)
		  '     for lane := uint32(0); lane < threads; lane++ {
		  '         j := lane * (memory / threads)
		  '         binary.LittleEndian.PutUint32(h0[blake2b.Size+4:], lane)
		  
		  '         binary.LittleEndian.PutUint32(h0[blake2b.Size:], 0)
		  '         blake2bHash(block0[:], h0[:])
		  '         for i := range B[j+0] {
		  '             B[j+0][i] = binary.LittleEndian.Uint64(block0[i*8:])
		  '         }
		  
		  '         binary.LittleEndian.PutUint32(h0[blake2b.Size:], 1)
		  '         blake2bHash(block0[:], h0[:])
		  '         for i := range B[j+1] {
		  '             B[j+1][i] = binary.LittleEndian.Uint64(block0[i*8:])
		  '         }
		  '     }
		  '     return B
		  ' }
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RaiseInvalidArgumentException(msg As String)
		  var err as new InvalidArgumentException( msg )
		  raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestValue(label As String, value As Integer, minValue As Integer, maxValue As Integer)
		  var msg as string
		  
		  if value < minValue then
		    msg = "less than " + minValue.ToString
		  elseif value > maxValue then
		    msg = "greater than " + maxValue.ToString
		  end if
		  
		  if msg = "" then
		    return
		  end if
		  
		  RaiseInvalidArgumentException label + " may not be " + msg
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestValues(password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String, associatedData As String)
		  TestValue "Length of password", password.Bytes, 0, ( 2^32 ) - 1
		  TestValue "Length of salt", salt.Bytes, 8, ( 2^32 ) - 1
		  TestValue "HashLength", hashLength, 4, ( 2^32 ) - 1
		  TestValue "Parallelism", parallelism, 1, ( 2^24 ) - 1
		  TestValue "MemoryKB depends on parallelism, and must be", memoryKB, 8 * parallelism, ( 2^32 ) - 1
		  TestValue "Iterations", iterations, 1, ( 2^32 ) - 1
		  if secret <> "" then
		    TestValue "Length of secret", secret.Bytes, 0, ( 2^32 ) - 1
		  end if
		  if associatedData <> "" then
		    TestValue "Length of associatedData", associatedData.Bytes, 0, ( 2^32 ) - 1
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToBuffer(type As Argon2_MTC.Types, password As String, salt As String, hashLength As Integer, parallelism As Integer, memoryKB As Integer, iterations As Integer, secret As String, associatedData As String) As MemoryBlock
		  var mbSize as integer = 40 + password.Bytes + salt.Bytes + secret.Bytes + associatedData.Bytes
		  
		  var mb as new MemoryBlock( mbSize )
		  mb.LittleEndian = true
		  
		  mb.UInt32Value( 0 ) = parallelism
		  mb.UInt32Value( 4 ) = hashLength
		  mb.UInt32Value( 8 ) = memoryKB
		  mb.UInt32Value( 12 ) = iterations
		  mb.UInt32Value( 16 ) = kArgon2Version
		  mb.UInt32Value( 20 ) = integer( type )
		  
		  var byteIndex as integer = 24
		  for each item as string in array( password, salt, secret, associatedData )
		    var len as integer = item.Bytes
		    
		    mb.UInt32Value( byteIndex ) = len
		    byteIndex = byteIndex + 4
		    
		    if len <> 0 then
		      mb.StringValue( byteIndex, len ) = item
		      byteIndex = byteIndex + len
		    end if
		  next
		  
		  return mb
		  
		  
		  'buffer ← parallelism ∥ tagLength ∥ memorySizeKB ∥ iterations ∥ version ∥ hashType
		  '∥ Length(password)       ∥ Password
		  '∥ Length(salt)           ∥ salt
		  '∥ Length(key)            ∥ key
		  '∥ Length(associatedData) ∥ associatedData
		End Function
	#tag EndMethod


	#tag Constant, Name = kArgon2Version, Type = Double, Dynamic = False, Default = \"&h13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kKibiBytes, Type = Double, Dynamic = False, Default = \"1024", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kSyncPoints, Type = Double, Dynamic = False, Default = \"4.0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"2.8", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = Types, Type = Integer, Flags = &h21
		D
		  I
		ID
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
