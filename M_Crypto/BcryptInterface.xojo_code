#tag Interface
Protected Interface BcryptInterface
	#tag Method, Flags = &h0
		Sub Encrypt(data As MemoryBlock, isFinalBlock As Boolean = True)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Expand0State(key As MemoryBlock)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExpandState(data As MemoryBlock, key As MemoryBlock)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
