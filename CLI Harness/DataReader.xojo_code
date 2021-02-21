#tag Class
Protected Class DataReader
	#tag Method, Flags = &h0
		Sub Constructor(data As Variant)
		  if data.Type = Variant.TypeString then
		    StringData = data.StringValue
		    Type = Types.String
		    DataLenB = StringData.LenB
		    StringPositionB = 1
		    
		  elseif data isa FolderItem then
		    FileData = BinaryStream.Open( data )
		    Type = Types.File
		    DataLenB = FileData.Length
		    FileData.Position = 0
		    
		  elseif data isa StandardInputStream then
		    StdInData = StandardInputStream( data )
		    Type = Types.StdIn
		    DataLenB = 1 * 1024 ^ 2
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if FileData isa object then
		    FileData.Close
		    FileData = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean
		  select case Type
		  case Types.String
		    return StringPositionB > DataLenB
		    
		  case Types.File
		    return FileData.EOF
		    
		  case Types.StdIn
		    return StdInData.EOF
		    
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Read(count As Integer) As String
		  dim result as string
		  
		  if not EOF then
		    select case Type
		    case Types.String
		      result = StringData.MidB( StringPositionB, count )
		      StringPositionB = StringPositionB + count
		      
		    case Types.File
		      result = FileData.Read( count )
		      
		    case Types.StdIn
		      result = StdInData.Read( count )
		      
		    end select
		  end if
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadAll() As String
		  dim result as string
		  
		  while not EOF
		    result = result + Read( DataLenB )
		  wend
		  
		  return result
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private DataLenB As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private FileData As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StdInData As StandardInputStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StringData As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StringPositionB As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Type As Types
	#tag EndProperty


	#tag Enum, Name = Types, Type = Integer, Flags = &h21
		Unknown
		  String
		  File
		StdIn
	#tag EndEnum


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
End Class
#tag EndClass
