#tag Class
Class SHA3_256Digest_MTC
Inherits M_SHA3.SHA3Digest_MTC
	#tag Method, Flags = &h0
		Sub Constructor()
		  super.Constructor( M_SHA3.Bits.Bits256 )
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
