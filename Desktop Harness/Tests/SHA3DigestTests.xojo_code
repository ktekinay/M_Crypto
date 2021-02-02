#tag Class
Protected Class SHA3DigestTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Bits256Test()
		  const kBits as M_SHA3.Bits = M_SHA3.Bits.Bits256
		  
		  var dataSet() as pair = array( _
		  "abc" : "3a985da74fe225b2 045c172d6bd390bd 855f086e3e9d525b 46bfe24511431532", _
		  "" : "a7ffc6f8bf1ed766 51c14756a061d662 f580ff4de43b49fa 82d80a4b80f8434a", _
		  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" : "41c0dba2a9d62408 49100376a8235e2c 82e1b9998a999e21 db32dd97496d3376", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu" : "916f6061fe879741 ca6469b43971dfdb 28b1a32dc36cb325 4e812be27aad1d18", _
		  "a*1000000" : "5c8875ae474a3634 ba4fd55ec85bffd6 61f32aca75c6d699 d0cdcb6c115891c1" _
		  )
		  
		  for each p as pair in dataSet
		    var data as string = p.Left.StringValue
		    var expectedHex as string = p.Right.StringValue.ReplaceAll( " ", "" ).Uppercase
		    
		    var starPos as integer = data.IndexOf( "*" )
		    if starPos <> -1 then
		      var count as integer = data.Middle( starPos + 1 ).ToInteger
		      data = data.Left( starPos )
		      
		      var currentSize as integer = data.Length
		      var expectedSize as integer = currentSize * count 
		      var halfSize as integer = ( expectedSize + 1 ) \ 2
		      
		      while currentSize <= halfSize
		        data = data + data
		        currentSize = currentSize + currentSize
		      wend
		      
		      if currentSize < expectedSize then
		        data = data + data.Left( expectedSize - currentSize )
		      end if
		      
		      data = data // A place to break
		    end if
		    
		    #if DebugBuild 
		      if data.LenB > 10000 then
		        Assert.Message "Skipping long data"
		        continue
		      end if
		    #endif
		    
		    var digest as new SHA3Digest_MTC( kBits )
		    digest.Process( data )
		    var actual as string = digest.Value
		    var actualHex as string = EncodeHex( actual ).Uppercase
		    Assert.AreEqual expectedHex, actualHex, data.Left( 10 ) + if( data.Length > 10, "...", "" ) + " (" + data.Length.ToString + ")"
		    
		    var ein as new SHA3( 256 )
		    ein.Update data
		    actualHex = ein.FinalAsHex
		    
		    Assert.AreEqual expectedHex, actualHex, "Ein: " + data.Left( 10 ) + if( data.Length > 10, "...", "" ) + " (" + data.Length.ToString + ")"
		    
		  next
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
