#tag Class
Protected Class M_CryptoTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub UUIDTest()
		  
		  dim uuid as string 
		  try
		    uuid = M_Crypto.GenerateUUID
		  catch err as RuntimeException
		    Assert.Fail "UUID generated err of type " + Xojo.Introspection.GetType( err ).Name + ": " + err.Reason
		    return
		  end try
		  
		  dim rx as new RegEx
		  rx.SearchPattern = "(?mi-Us)^[[:xdigit:]]{8}-[[:xdigit:]]{4}-4[[:xdigit:]]{3}-[89AB][[:xdigit:]]{3}-[[:xdigit:]]{12}$"
		  
		  dim arr() as string
		  for i as integer = 1 to 1000
		    uuid = M_Crypto.GenerateUUID
		    Assert.IsNotNil rx.Search( uuid ), uuid + " doesn't match pattern"
		    if arr.IndexOf( uuid ) <> -1 then
		      Assert.Fail uuid + " is a duplicate"
		    else
		      arr.Append uuid
		    end if
		  next
		  
		  // Generate 16 random bytes (=128 bits)
		  // Adjust certain bits according to RFC 4122 section 4.4 as follows:
		  // set the four most significant bits of the 7th byte to 0100'B, so the high nibble is '4'
		  // set the two most significant bits of the 9th byte to 10'B, so the high nibble will be one of '8', '9', 'A', or 'B'.
		  // Convert the adjusted bytes to 32 hexadecimal digits
		  // Add four hyphen '-' characters to obtain blocks of 8, 4, 4, 4 and 12 hex digits
		  // Output the resulting 36-character string "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
