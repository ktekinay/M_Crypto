#tag Class
Protected Class SHA256DigestTest
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BasicTest()
		  dim testString as string = "Hello World"
		  dim expected as string = EncodeHex( Crypto.SHA256( testString ) ).Lowercase
		  
		  dim d as new SHA256Digest_MTC
		  d.Process testString
		  dim actual as string = EncodeHex( d.Value ).Lowercase
		  
		  Assert.AreEqual( expected, actual, "Hello World" )
		  
		  dim expectedBlank as string = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
		  Assert.AreEqual( expectedBlank, EncodeHex( Crypto.SHA256( "" ) ).Lowercase, "Blank does not match Crypto" )
		  
		  d = new SHA256Digest_MTC
		  d.Process( "" )
		  dim actualBlank as string = EncodeHex( d.Value ).Lowercase
		  
		  Assert.AreEqual( expectedBlank, actualBlank, "Blank" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DigestLargeTest()
		  dim s as string = "hello "
		  while s.LenB <= 10000
		    s = s + s
		  wend
		  
		  dim expected as string = EncodeHex( Crypto.SHA256( s ) ).Lowercase
		  
		  dim d as new SHA256Digest_MTC
		  
		  for i as integer = 1 to s.LenB step 999
		    d.Process s.MidB( i, 999 )
		  next
		  
		  dim actual as string = EncodeHex( d.Value ).Lowercase
		  Assert.AreEqual expected, actual
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DigestSmallTest()
		  dim d as new SHA256Digest_MTC
		  
		  dim t as string = "h"
		  
		  for i as integer = 1 to 256
		    dim expected as string = EncodeHex( Crypto.SHA256( t ) ).Lowercase
		    
		    if i = 64 then
		      i = i // A place to break
		    end if
		    
		    d.Process "h"
		    dim actual as string = EncodeHex( d.Value ).Lowercase
		    Assert.AreEqual expected, actual, i.ToString
		    
		    t = t + "h"
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DigestSuperLargeTest()
		  dim s as string = "Hello "
		  while s.LenB <= 10000000
		    s = s + s
		  wend
		  
		  dim chunkSize as integer = 128 * 8 * 1000
		  
		  Assert.Message "Data length is " + format( s.LenB, "#,0" ) + " bytes"
		  Assert.Message "ChunkSize is " + format( chunkSize, "#,0" ) + " bytes"
		  
		  
		  StartTestTimer "native"
		  dim expected as string = Crypto.SHA256( s )
		  LogTestTimer "native"
		  
		  
		  StartTestTimer "mine"
		  
		  dim d as new SHA256Digest_MTC
		  
		  for i as integer = 1 to s.LenB step chunkSize
		    d.Process s.MidB( i, chunkSize )
		  next
		  dim actual as string = d.Value
		  
		  LogTestTimer "mine"
		  
		  Assert.AreEqual EncodeHex( expected ), EncodeHex( actual )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetTest()
		  dim d as new SHA256Digest_MTC
		  
		  dim strings() as string = array( "123", "456", "abc", "ab123" )
		  
		  for each s as string in strings
		    d.Reset
		    d.Process( s )
		    Assert.AreEqual EncodeHex( Crypto.SHA256( s ) ).Lowercase, EncodeHex( d.Value ).Lowercase, s
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SpeedTest()
		  dim s as string = "Hello "
		  while s.LenB <= 100000
		    s = s + s
		  wend
		  
		  dim expected as string
		  StartTestTimer "native"
		  expected = Crypto.SHA256( s )
		  LogTestTimer "native"
		  
		  dim actual as string
		  StartTestTimer "mine"
		  StartProfiling
		  dim d as new SHA256Digest_MTC
		  d.Process s
		  actual = d.Value
		  StopProfiling
		  LogTestTimer "mine"
		  
		  Assert.AreEqual EncodeHex( expected ), EncodeHex( actual )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SuperLargeTest()
		  dim s as string = "Hello "
		  while s.LenB <= 10000000
		    s = s + s
		  wend
		  
		  StartTestTimer "native"
		  dim expected as string = Crypto.SHA256( s )
		  LogTestTimer "native"
		  
		  
		  dim d as new SHA256Digest_MTC
		  
		  //
		  // Not including the creation of the object here
		  // to time the processing only
		  //
		  
		  StartTestTimer "mine"
		  d.Process s
		  dim actual as string = d.Value
		  LogTestTimer "mine"
		  
		  Assert.AreEqual EncodeHex( expected ), EncodeHex( actual )
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
End Class
#tag EndClass
