#tag Class
Protected Class Blake2bDigestTest
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub EmptyTest()
		  TestIt "", "786A02F742015903C6C6FD852552D272912F4740E15847618A86E217F71F5419D25E1031AFEE585313896444934EB04B903A685B1448B755D56F701AFE9BE2CE"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Exact128Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF", _
		  "7fdc929ec9743915de5f12ab3fa5b4901a23ad78e3f6606a4bb4edcd55c9d15cdaf7a96f3cc11938fefb31f2b9c2ea2c3b02bfa67cfa03f403ff899dca19fe5f"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HashLengthTest()
		  var data as string = _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEFx"
		  
		  var lengths() as integer = array( 1, 2, 3, 8, 32 )
		  var expected() as string = array ( _
		  "88", _
		  "4516", _
		  "df0a13", _
		  "bc38466e4e13a374", _
		  "659bf8faa81252fee9201422daedca00c1e7aaf0ea7f0b3ec711c6e0f9a46471" _
		  )
		  
		  var b as Blake2bDigest_MTC
		  
		  for i as integer = 0 to lengths.LastIndex
		    var len as integer = lengths( i )
		    var e as string = expected( i )
		    
		    b = new Blake2bDigest_MTC( len )
		    b.Process data
		    var actual as string = EncodeHex( b.Value )
		    Assert.AreEqual e, actual, len.ToString
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InitTest()
		  var b as new Blake2bDigest_MTC
		  Assert.IsNotNil b
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LargeFileTest()
		  var file as FolderItem = SpecialFolder.Resources.Child( "Testing Resources" ).Child( "Res_ipsa.html" )
		  var tis as TextInputStream = TextInputStream.Open( file )
		  var contents as string = tis.ReadAll( Encodings.UTF8 )
		  tis.Close
		  
		  StartTestTimer "mine"
		  TestIt contents, _
		  "e03b0e727add73d2ea1a0e852b170fa04fdaca3473ae24c1a3f3f6897a76112f292a06bb85466a85a2a405c7a756fb53ef18890dbdf59a364f4197e010c719cd"
		  LogTestTimer "mine"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoreThan128Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEFx", _
		  "e5291e6b6010615ae681d20a96f14c5d22bbb84ac3a504c3b296121431093d9f7a821a5f913038b6711aa22f3f917eb7eb257c92f2ac35dcfec296ecbd42581a"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoreThan256Test()
		  TestIt _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF" + _
		  "0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEFx", _
		  "37a70d386a6a3ccd943d6041d6a3436032898bb08109cad33bf0335776af7bf981b242e57b7ce39bedb0a21a5044813869291d253c659cd0addc6be82a7f7aa3"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RFCSelfTestTest()
		  //
		  // Adapted from the RFC's self-test code
		  //
		  
		  // grand hash of hash results
		  var finalHash as string = _
		  "C2 3A 78 00 D9 81 23 BD" + _
		  "10 F5 06 C6 1E 29 DA 56" + _
		  "03 D7 63 B8 BB AD 2E 73" + _
		  "7F 5E 76 5A 7B CC D4 75"
		  
		  var master as new Blake2bDigest_MTC( 32 )
		  
		  // parameter sets
		  var outLengths() as integer = array( 20, 32, 48, 64 )
		  var inLengths() as integer = array( 0, 3, 128, 129, 255, 1024 )
		  
		  for each outLen as integer in outLengths
		    var key as string = SelfTestSeq( outLen, outLen )
		    'Assert.Message outLen.ToString + ": " + EncodeHex( key, true )
		    
		    for each inLen as integer in inLengths
		      var inData as string = SelfTestSeq( inLen, inLen )
		      var inb as new Blake2bDigest_MTC( outLen )
		      inb.Process inData
		      var md as string = inb.Value
		      Assert.AreEqual outLen, md.Bytes
		      master.Process md
		      
		      inb = new Blake2bDigest_MTC( outLen, key )
		      inb.Process inData
		      md = inb.Value
		      Assert.AreEqual outLen, md.Bytes
		      master.Process md
		    next
		  next
		  
		  var result as string = EncodeHex( master.Value )
		  Assert.AreEqual finalHash.ReplaceAll( " ", "" ), result
		  
		  
		  '// grand hash of hash results
		  'const uint8_t blake2b_res[32] = {
		  '  0xC2, 0x3A, 0x78, 0x00, 0xD9, 0x81, 0x23, 0xBD,
		  '  0x10, 0xF5, 0x06, 0xC6, 0x1E, 0x29, 0xDA, 0x56,
		  '  0x03, 0xD7, 0x63, 0xB8, 0xBB, 0xAD, 0x2E, 0x73,
		  '  0x7F, 0x5E, 0x76, 0x5A, 0x7B, 0xCC, 0xD4, 0x75
		  '};
		  '// parameter sets
		  'const size_t b2b_md_len[4] = { 20, 32, 48, 64 };
		  'const size_t b2b_in_len[6] = { 0, 3, 128, 129, 255, 1024 };
		  '
		  'size_t i, j, outlen, inlen;
		  'uint8_t in[1024], md[64], key[64];
		  'blake2b_ctx ctx;
		  '
		  '// 256-bit hash for testing
		  'if (blake2b_init(&ctx, 32, NULL, 0))
		  '  return -1;
		  '
		  'for (i = 0; i < 4; i++) {
		  '  outlen = b2b_md_len[i];
		  '  for (j = 0; j < 6; j++) {
		  '    inlen = b2b_in_len[j];
		  '
		  '    selftest_seq(in, inlen, inlen);     // unkeyed hash
		  '    blake2b(md, outlen, NULL, 0, in, inlen);
		  '    blake2b_update(&ctx, md, outlen);   // hash the hash
		  '
		  '    selftest_seq(key, outlen, outlen);  // keyed hash
		  '    blake2b(md, outlen, key, outlen, in, inlen);
		  '    blake2b_update(&ctx, md, outlen);   // hash the hash
		  '  }
		  '}
		  '
		  '// compute and compare the hash of hashes
		  'blake2b_final(&ctx, md);
		  'for (i = 0; i < 32; i++) {
		  '  if (md[i] != blake2b_res[i])
		  '    return -1;
		  '}
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RFCTest()
		  TestIt "abc", _
		  "BA 80 A5 3F 98 1C 4D 0D 6A 27 97 B6 9F 12 F6 E9" + _
		  "4C 21 2F 14 68 5A C4 B7 4B 12 BB 6F DB FF A2 D1" + _
		  "7D 87 C5 39 2A AB 79 2D C2 52 D5 DE 45 33 CC 95" + _
		  "18 D3 8A A8 DB F1 92 5A B9 23 86 ED D4 00 99 23"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SelfTestSeq(len As Integer, seed As Integer) As String
		  var a as UInt32 = &hDEAD4BAD * seed              // prime
		  var b as UInt32 = 1
		  
		  var mb as new MemoryBlock( len )
		  
		  for i as integer = 0 to len - 1
		    var t as UInt32 = a + b
		    a = b
		    b = t
		    mb.Byte( i ) = Bitwise.ShiftRight( t, 24 ) and &hFF
		  next
		  
		  return mb
		  return mb
		  
		  'static void selftest_seq(uint8_t *out, size_t len, uint32_t seed)
		  '{
		  '  size_t i;
		  '  uint32_t t, a , b;
		  '
		  '  a = 0xDEAD4BAD * seed;              // prime
		  '  b = 1;
		  '
		  '  for (i = 0; i < len; i++) {         // fill the buf
		  '    t = a + b;
		  '    a = b;
		  '    b = t;
		  '    out[i] = (t >> 24) & 0xFF;
		  '  }
		  '}
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TestIt(data As String, expected As String)
		  var b as new Blake2bDigest_MTC
		  
		  b.Process data
		  var actual as string = EncodeHex( b.Value )
		  Assert.AreEqual expected.ReplaceAll( " ", "" ).Lowercase, actual.Lowercase, data.Left( 50 )
		  
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
