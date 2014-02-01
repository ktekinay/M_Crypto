#tag Module
Protected Module Blowfish_MTC
	#tag Method, Flags = &h1
		Protected Sub Decrypt(data As MemoryBlock, key As String)
		  dim state As Blowfish_MTC.Blowfish_Context = StateWithKey( key )
		  state.Decrypt( data )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Encrypt(data As MemoryBlock, key As String)
		  dim state as Blowfish_MTC.Blowfish_Context = StateWithKey( key )
		  state.Encrypt( data )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function InitState() As Blowfish_Context
		  return new Blowfish_Context
		  
		  // Really just need to create a new Blowfish_Context directly, but this is here
		  // to help make conversions of code easier.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function StateWithKey(key As String) As Blowfish_Context
		  // Initalize S-boxes and subkeys with Pi */
		  dim state as new Blowfish_Context
		  
		  // Transform S-boxes and subkeys with key */
		  state.Expand0State( key )
		  
		  return state
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Stream2Word(data As MemoryBlock, ByRef current As UInt16) As UInt32
		  #pragma BackgroundTasks False
		  #pragma BoundsChecking False
		  
		  dim r as Uint32
		  
		  dim dataBytes as Integer = data.Size
		  dim j as Integer = current
		  
		  if j <= ( dataBytes - 4 ) then
		    
		    dim savedLE as boolean = data.LittleEndian
		    data.LittleEndian = false
		    r = data.UInt32Value( j )
		    data.LittleEndian = savedLE
		    j = j + 4
		    
		  else
		    
		    dim p as Ptr = data
		    
		    for i as Integer = 0 to 3
		      if j >= databytes then
		        j = 0
		      end if
		      r = Bitwise.ShiftLeft( r, 8, 32 ) or p.Byte( j )
		      j = j + 1
		    next i
		    
		  end if
		  
		  current = j
		  return r
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Blowfish Notes
		Code found at:
		
		http://stuff.mit.edu/afs/sipb/project/postgres-8.2/src/postgresql-8.2.5/contrib/pgcrypto/blf.c
		
		For alternate, see here:
		
		http://www.di-mgt.com.au/src/blowfish.txt
		
		For header:
		
		http://stuff.mit.edu/afs/sipb/project/postgres-8.2/src/postgresql-8.2.5/contrib/pgcrypto/blf.h
	#tag EndNote


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  static r as Integer = ( BLF_N - 2 ) * 4
			  return r
			  
			End Get
		#tag EndGetter
		Protected BLF_MAXKEYLEN As Integer
	#tag EndComputedProperty


	#tag Constant, Name = BLF_N, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
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
