#tag Class
Protected Class ScryptUnitTester
	#tag Method, Flags = &h0
		Function BlockMix(mb As MemoryBlock) As MemoryBlock
		  return Scrypt_MTC.BlockMix( mb )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ROMix(mb As MemoryBlock, n As Integer) As MemoryBlock
		  return Scrypt_MTC.ROMix( mb, n )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Salsa(mb As MemoryBlock) As MemoryBlock
		  return Scrypt_MTC.Salsa( mb )
		End Function
	#tag EndMethod


End Class
#tag EndClass
