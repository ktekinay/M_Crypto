#tag Class
Protected Class SHA3DigestTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Bits224Test()
		  const kBits as M_SHA3.Bits = M_SHA3.Bits.Bits224
		  
		  var dataSet() as pair = array( _
		  "abc" : "e642824c3f8cf24a d09234ee7d3c766f c9a3a5168d0c94ad 73b46fdf", _
		  "" : "6b4e03423667dbb7 3b6e15454f0eb1ab d4597f9a1b078e3f 5b5a6bc7", _
		  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" : "8a24108b154ada21 c9fd5574494479ba 5c7e7ab76ef264ea d0fcce33", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu" : "543e6868e1666c1a 643630df77367ae5 a62a85070a51c14c bf665cbc", _
		  "a*1000000" : "d69335b93325192e 516a912e6d19a15c b51c6ed5c15243e7 a7fd653c", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmno*16777216" : "c6d66e77ae289566 afb2ce39277752d6 da2a3c46010f1e0a 0970ff60" _
		  )
		  
		  TestDigest kBits, dataSet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bits256Test()
		  const kBits as M_SHA3.Bits = M_SHA3.Bits.Bits256
		  
		  var dataSet() as pair = array( _
		  "abc" : "3a985da74fe225b2 045c172d6bd390bd 855f086e3e9d525b 46bfe24511431532", _
		  "" : "a7ffc6f8bf1ed766 51c14756a061d662 f580ff4de43b49fa 82d80a4b80f8434a", _
		  "a*135" : "8094bb53c44cfb1e67b7c30447f9a1c33696d2463ecc1d9c92538913392843c9", _
		  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" : "41c0dba2a9d62408 49100376a8235e2c 82e1b9998a999e21 db32dd97496d3376", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu" : "916f6061fe879741 ca6469b43971dfdb 28b1a32dc36cb325 4e812be27aad1d18", _
		  "a*1000000" : "5c8875ae474a3634 ba4fd55ec85bffd6 61f32aca75c6d699 d0cdcb6c115891c1", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmno*16777216" : "ecbbc42cbf296603 acb2c6bc0410ef43 78bafb24b710357f 12df607758b33e2b" _
		  )
		  
		  TestDigest kBits, dataSet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bits384Test()
		  const kBits as M_SHA3.Bits = M_SHA3.Bits.Bits384
		  
		  var dataSet() as pair = array( _
		  "abc" : "ec01498288516fc9 26459f58e2c6ad8d f9b473cb0fc08c25 96da7cf0e49be4b2 98d88cea927ac7f5 39f1edf228376d25", _
		  "" : "0c63a75b845e4f7d 01107d852e4c2485 c51a50aaaa94fc61 995e71bbee983a2a c3713831264adb47 fb6bd1e058d5f004", _
		  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" : "991c665755eb3a4b 6bbdfb75c78a492e 8c56a22c5c4d7e42 9bfdbc32b9d4ad5a a04a1f076e62fea1 9eef51acd0657c22", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu" : "79407d3b5916b59c 3e30b09822974791 c313fb9ecc849e40 6f23592d04f625dc 8c709b98b43b3852 b337216179aa7fc7", _
		  "a*1000000" : "eee9e24d78c18553 37983451df97c8ad 9eedf256c6334f8e 948d252d5e0e7684 7aa0774ddb90a842 190d2c558b4b8340", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmno*16777216" : "a04296f4fcaae148 71bb5ad33e28dcf6 9238b04204d9941b 8782e816d014bcb7 540e4af54f30d578 f1a1ca2930847a12" _
		  )
		  
		  TestDigest kBits, dataSet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bits512Test()
		  const kBits as M_SHA3.Bits = M_SHA3.Bits.Bits512
		  
		  var dataSet() as pair = array( _
		  "abc" : "b751850b1a57168a 5693cd924b6b096e 08f621827444f70d 884f5d0240d2712e 10e116e9192af3c9 1a7ec57647e39340 57340b4cf408d5a5 6592f8274eec53f0", _
		  "" : "a69f73cca23a9ac5 c8b567dc185a756e 97c982164fe25859 e0d1dcc1475c80a6 15b2123af1f5f94c 11e3e9402c3ac558 f500199d95b6d3e3 01758586281dcd26", _
		  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq" : "04a371e84ecfb5b8 b77cb48610fca818 2dd457ce6f326a0f d3d7ec2f1e91636d ee691fbe0c985302 ba1b0d8dc78c0863 46b533b49c030d99 a27daf1139d6e75e", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu" : "afebb2ef542e6579 c50cad06d2e578f9 f8dd6881d7dc824d 26360feebf18a4fa 73e3261122948efc fd492e74e82e2189 ed0fb440d187f382 270cb455f21dd185", _
		  "a*1000000" : "3c3a876da14034ab 60627c077bb98f7e 120a2a5370212dff b3385a18d4f38859 ed311d0a9d5141ce 9cc5c66ee689b266 a8aa18ace8282a0e 0db596c90b0a7b87", _
		  "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmno*16777216" : "235ffd53504ef836 a1342b488f483b39 6eabbfe642cf78ee 0d31feec788b23d0 d18d5c339550dd59 58a500d4b95363da 1b5fa18affc1bab2 292dc63b7d85097c" _
		  )
		  
		  TestDigest kBits, dataSet
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CompareToOpenSSLTest()
		  var openssl as string = OpenSSLPath
		  if openssl = kUnknown then
		    Assert.Message "Could not locate a suitable version of openssl"
		    return
		  end if
		  
		  var rx as new RegEx
		  rx.SearchPattern = "\b[[:xdigit:]]{32,}\b"
		  
		  var sh as new Shell
		  
		  for each bits as integer in array( 224, 256, 384, 512 )
		    
		    var data as string
		    for i as integer = 0 to 289 // Will cover all block sizes * 2 + 1
		      var cmd as string = "echo -n '" + data + "' | " + openssl + " sha3-" + bits.ToString + " -hex"
		      sh.Execute cmd
		      Assert.AreEqual 0, sh.ErrorCode, cmd
		      if Assert.Failed then
		        return
		      end if
		      
		      var expected as string = sh.Result.DefineEncoding( Encodings.UTF8 ).Trim
		      var match as RegExMatch = rx.Search( expected )
		      expected = match.SubExpressionString( 0 )
		      
		      var d as new SHA3Digest_MTC( M_SHA3.Bits( bits ) )
		      d.Process data
		      var actual as string = EncodeHex( d.Value )
		      
		      Assert.AreEqual expected, actual, "Bits: " + bits.ToString + ", Data Length: " + data.Bytes.ToString
		      
		      data = data + "a"
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestDigest(bits As M_SHA3.Bits, dataSet() As Pair)
		  for each p as pair in dataSet
		    var data as string = p.Left.StringValue
		    var expectedHex as string = p.Right.StringValue.ReplaceAll( " ", "" ).Uppercase
		    
		    if expectedHex.IsEmpty then
		      continue
		    end if
		    
		    var starPos as integer = data.IndexOf( "*" )
		    if starPos <> -1 then
		      var count as integer = data.Middle( starPos + 1 ).ToInteger
		      
		      if count > 2000000 or ( DebugBuild and count > 10000 ) then
		        Assert.Message "Skipping long data"
		        continue
		      end if
		      
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
		    
		    const kChunk as integer = 100000
		    var digest as new SHA3Digest_MTC( bits )
		    
		    for i as integer = 0 to data.Bytes - 1 step kChunk
		      digest.Process( data.MiddleBytes( i, kChunk ) )
		    next
		    
		    var actual as string = digest.Value
		    var actualHex as string = EncodeHex( actual ).Uppercase
		    Assert.AreEqual expectedHex, actualHex, data.Left( 10 ) + if( data.Length > 10, "...", "" ) + " (" + data.Length.ToString + ")"
		  next
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared mOpenSSLPath As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  if mOpenSSLPath = "" then
			    mOpenSSLPath = kUnknown // Default
			    
			    var cmd as string = "bash -lc 'which -a openssl'"
			    var sh as new Shell
			    sh.Execute cmd
			    var possibilities() as string = _
			    sh.Result _
			    .DefineEncoding( Encodings.UTF8 ) _
			    .Trim _
			    .ReplaceLineEndings( &uA ) _
			    .Split( &uA )
			    
			    for each openssl as string in possibilities
			      if openssl.IndexOf( "/openssl" ) <> -1 then
			        cmd = openssl + " sha3-256 --help"
			        sh.Execute cmd
			        if sh.ErrorCode = 0 then
			          mOpenSSLPath = openssl
			          exit
			        end if
			      end if
			    next
			  end if
			  
			  return mOpenSSLPath
			End Get
		#tag EndGetter
		Private Shared OpenSSLPath As String
	#tag EndComputedProperty


	#tag Constant, Name = kUnknown, Type = String, Dynamic = False, Default = \"unknown", Scope = Private
	#tag EndConstant


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
