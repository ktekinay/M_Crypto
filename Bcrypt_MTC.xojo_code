#tag Module
Protected Module Bcrypt_MTC
	#tag Method, Flags = &h1
		Protected Function Bcrypt(key As String, salt As String) As String
		  if salt = "" or key = "" then return ""
		  
		  dim r as string
		  
		  dim state as Blowfish_MTC.Blowfish_Context
		  dim rounds as Integer
		  dim j as UInt16
		  dim logr, minor as UInt8
		  dim ciphertext as MemoryBlock = "OrpheanBeholderScryDoubt"
		  dim csalt as new MemoryBlock( BCRYPT_MAXSALT )
		  dim cdata as new MemoryBlock( BCRYPT_BLOCKS * 4 )
		  dim n as Integer
		  
		  dim saltFields() as string = salt.Split( "$" )
		  
		  if saltFields.Ubound <> 3 then
		    return ""
		  end if
		  
		  dim saltVersionString as string = saltFields( 1 )
		  dim saltVersion as integer = Val( saltVersionString )
		  dim saltRounds as string = saltFields( 2 )
		  dim saltText as string = saltFields( 3 )
		  
		  if saltVersionString = "" or saltVersion > Val( BCRYPT_VERSION ) then
		    return ""
		  end if
		  
		  saltVersionString = NthFieldB( saltVersionString, str( saltVersion ), 2 )
		  if saltVersionString <> "" then
		    if saltVersionString = "a" then
		      minor = AscB( "a" )
		    else
		      return ""
		    end if
		  end if
		  
		  n = Val( saltRounds )
		  if n < 0 or n > 31 then
		    return ""
		  end if
		  
		  logr = n
		  rounds = Bitwise.ShiftLeft( 1, logr )
		  if rounds < BCRYPT_MINROUNDS then
		    return ""
		  end if
		  
		  if ( ( saltText.LenB *3 ) / 4 ) < BCRYPT_MAXSALT then
		    return ""
		  end if
		  
		  // Get the raw data behind the salt
		  decode_base64( csalt, saltText )
		  if minor >= AscB( "a" ) then
		    key = key + ChrB( 0 ) // Set it up as CString
		  end if
		  
		  // Set up S-Boxes and Subkeys
		  state = new Blowfish_MTC.Blowfish_Context
		  Blowfish_MTC.ExpandState( state, csalt, key )
		  dim lastRound as UInt32= rounds - 1
		  '#pragma warning "REMOVE THIS!!"
		  'lastRound = 10
		  for k as Integer = 0 to lastRound
		    Blowfish_MTC.Expand0State( state, key )
		    Blowfish_MTC.Expand0State( state, csalt )
		  next k
		  
		  j = 0
		  dim lastBlock as UInt32 = BCRYPT_BLOCKS - 1
		  dim byteIndex as integer
		  for i as Integer= 0 to lastBlock
		    cdata.UInt32Value( byteIndex ) = Blowfish_MTC.Stream2Word( ciphertext, j )
		    byteIndex = byteIndex + 4
		  next i
		  
		  // Now to encrypt
		  for k as Integer = 0 to 63
		    Blowfish_MTC.Encrypt( state, cdata )
		  next k
		  
		  for i as Integer = 0 to lastBlock
		    dim dataIndex as Integer = i * 4
		    ciphertext.Byte( dataIndex + 3 ) = cdata.UInt32Value( dataIndex ) and &hFF
		    cdata.UInt32Value( dataIndex ) = Bitwise.ShiftRight( cdata.UInt32Value( dataIndex ), 8 )
		    ciphertext.Byte( dataIndex + 2 ) = cdata.UInt32Value( dataIndex ) and &hFF
		    cdata.UInt32Value( dataIndex ) = Bitwise.ShiftRight( cdata.UInt32Value( dataIndex ), 8 )
		    ciphertext.Byte( dataIndex + 1 ) = cdata.UInt32Value( dataIndex ) and &hFF
		    cdata.UInt32Value( dataIndex ) = Bitwise.ShiftRight( cdata.UInt32Value( dataIndex ), 8 )
		    ciphertext.Byte( dataIndex ) = cdata.UInt32Value( dataIndex ) and &hFF
		  next i
		  
		  r = "$" + BCRYPT_VERSION + ChrB( minor ) + "$" + format( logr, "00" ) + "$"
		  
		  dim buffer as new MemoryBlock( 128 )
		  encode_base64( buffer, csalt )
		  r = r + buffer.CString( 0 )
		  
		  ciphertext.Size = ciphertext.Size - 1 // Lop off last character
		  encode_base64( buffer, ciphertext )
		  r = r + buffer.CString( 0 )
		  
		  return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Char64(c As Byte) As Integer
		  if c > 127 then
		    return 255
		  else
		    return index_64( c )
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub decode_base64(buffer As MemoryBlock, data As MemoryBlock)
		  Init()
		  
		  dim bp, p as integer
		  dim c1, c2, c3, c4 as byte
		  dim lastByteIndex as integer = buffer.Size - 1
		  
		  while bp <= lastByteIndex
		    c1 = Char64( data.Byte( p ) )
		    c2 = Char64( data.Byte( p + 1 ) )
		    
		    if c1 = 255 or c2 = 255 then
		      exit while
		    end if
		    
		    buffer.Byte( bp ) = Bitwise.ShiftLeft( c1, 2 ) or Bitwise.ShiftRight( c2 and &h30, 4 )
		    bp = bp + 1
		    if bp > lastByteIndex then
		      exit while
		    end if
		    
		    c3 = Char64( data.Byte( p + 2 ) )
		    if c3 = 255 then
		      exit while
		    end if
		    
		    buffer.Byte( bp ) = Bitwise.ShiftLeft( c2 and &h0F, 4 ) or Bitwise.ShiftRight( c3 and &h3C, 2 )
		    bp = bp + 1
		    if bp > lastByteIndex then
		      exit while
		    end if
		    
		    c4 = Char64( data.Byte( p + 3 ) )
		    if c4 = 255 then
		      exit while
		    end if
		    buffer.Byte( bp ) = Bitwise.ShiftLeft( c3 and &h03, 6 ) or c4
		    bp = bp + 1
		    
		    p = p + 4
		  wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub encode_base64(buffer As MemoryBlock, data As MemoryBlock)
		  Init()
		  
		  dim lastByteIndex as integer = data.Size - 1
		  dim bp, p as integer
		  
		  dim c1, c2 as byte
		  while ( p <= lastByteIndex )
		    c1 = data.Byte( p )
		    p = p + 1
		    
		    buffer.Byte( bp ) = Base64Code.Byte( Bitwise.ShiftRight( c1, 2 ) )
		    bp = bp + 1
		    
		    c1 = Bitwise.ShiftLeft( c1 and &h03, 4 )
		    if p > lastByteIndex then
		      buffer.Byte( bp ) = Base64Code.Byte( c1 )
		      bp = bp + 1
		      exit while
		    end if
		    
		    c2 = data.Byte( p )
		    p = p + 1
		    
		    c1 = c1 or ( Bitwise.ShiftRight( c2, 4 ) and &h0F )
		    buffer.Byte( bp ) = Base64Code.Byte( c1 )
		    bp = bp + 1
		    
		    c1 = Bitwise.ShiftLeft( c2 and &h0F, 2 )
		    if p > lastByteIndex then
		      buffer.Byte( bp ) = Base64Code.Byte( c1 )
		      bp = bp + 1
		      exit while
		    end if
		    
		    c2 = data.Byte( p )
		    p = p + 1
		    
		    c1 = c1 or ( Bitwise.ShiftRight( c2, 6 ) and &h03 )
		    buffer.Byte( bp ) = Base64Code.Byte( c1 )
		    bp = bp + 1
		    buffer.Byte( bp ) = Base64Code.Byte( c2 and &h3F )
		    bp = bp + 1
		  wend
		  
		  buffer.Byte( bp ) = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function encode_salt(csalt As MemoryBlock, clen As Integer, logr As UInt8) As String
		  dim salt as string = "$" + BCRYPT_VERSION + "a$"
		  salt = salt + format( logr, "00" ) + "$"
		  
		  dim buffer as new MemoryBlock( clen * 2 )
		  encode_base64( buffer, csalt )
		  
		  salt = salt + buffer.CString( 0 )
		  return salt
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GenerateSalt(rounds As UInt8) As String
		  dim csalt as MemoryBlock = Crypto.GenerateRandomBytes( BCRYPT_MAXSALT )
		  
		  if rounds < 4 then
		    rounds = 4
		  elseif rounds > 31 then
		    rounds = 31
		  end if
		  
		  return encode_salt( csalt, BCRYPT_MAXSALT, rounds )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Init()
		  if zInited then return
		  
		  index_64 = Array( _
		  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, _
		  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, _
		  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, _
		  255, 255, 255, 255, 255, 255, 255, 255, 255, 255, _
		  255, 255, 255, 255, 255, 255, 0, 1, 54, 55, _
		  56, 57, 58, 59, 60, 61, 62, 63, 255, 255, _
		  255, 255, 255, 255, 255, 2, 3, 4, 5, 6, _
		  7, 8, 9, 10, 11, 12, 13, 14, 15, 16, _
		  17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, _
		  255, 255, 255, 255, 255, 255, 28, 29, 30, _
		  31, 32, 33, 34, 35, 36, 37, 38, 39, 40, _
		  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, _
		  51, 52, 53, 255, 255, 255, 255, 255 _
		  )
		  
		  zInited = true
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = BCrypt Notes
		C code for bcrypt here:
		
		http://ftp3.usa.openbsd.org/pub/OpenBSD/src/lib/libc/crypt/bcrypt.c
		
		
		/*    $OpenBSD: bcrypt.c,v 1.26 2013/12/19 14:31:07 deraadt Exp $    */
		
		/*
		* Copyright 1997 Niels Provos <provos@physnet.uni-hamburg.de>
		* All rights reserved.
		*
		* Redistribution and use in source and binary forms, with or without
		* modification, are permitted provided that the following conditions
		* are met:
		* 1. Redistributions of source code must retain the above copyright
		*    notice, this list of conditions and the following disclaimer.
		* 2. Redistributions in binary form must reproduce the above copyright
		*    notice, this list of conditions and the following disclaimer in the
		*    documentation and/or other materials provided with the distribution.
		* 3. All advertising materials mentioning features or use of this software
		*    must display the following acknowledgement:
		*      This product includes software developed by Niels Provos.
		* 4. The name of the author may not be used to endorse or promote products
		*    derived from this software without specific prior written permission.
		*
		* THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
		* IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
		* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
		* IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
		* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
		* NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
		* DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
		* THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
		* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
		* THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
		*/
		
		/* This password hashing algorithm was designed by David Mazieres
		* <dm@lcs.mit.edu> and works as follows:
		*
		* 1. state := InitState ()
		* 2. state := ExpandKey (state, salt, password)
		* 3. REPEAT rounds:
		*      state := ExpandKey (state, 0, password)
		*    state := ExpandKey (state, 0, salt)
		* 4. ctext := "OrpheanBeholderScryDoubt"
		* 5. REPEAT 64:
		*     ctext := Encrypt_ECB (state, ctext);
		* 6. RETURN Concatenate (salt, ctext);
		*
		*/
		
		#include <stdio.h>
		#include <stdlib.h>
		#include <sys/types.h>
		#include <string.h>
		#include <pwd.h>
		#include <blf.h>
		
		/* This implementation is adaptable to current computing power.
		* You can have up to 2^31 rounds which should be enough for some
		* time to come.
		*/
		
		#define BCRYPT_VERSION '2'
		#define BCRYPT_MAXSALT 16    /* Precomputation is just so nice */
		#define BCRYPT_BLOCKS 6        /* Ciphertext blocks */
		#define BCRYPT_MINROUNDS 16    /* we have log2(rounds) in salt */
		
		char   *bcrypt_gensalt(u_int8_t);
		
		static void encode_salt(char *, u_int8_t *, u_int16_t, u_int8_t);
		static void encode_base64(u_int8_t *, u_int8_t *, u_int16_t);
		static void decode_base64(u_int8_t *, u_int16_t, u_int8_t *);
		
		static char    encrypted[_PASSWORD_LEN];
		static char    gsalt[7 + (BCRYPT_MAXSALT * 4 + 2) / 3 + 1];
		static char    error[] = ":";
		
		const static u_int8_t Base64Code[] =
		"./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		
		const static u_int8_t index_64[128] = {
		255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
		255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
		255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
		255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
		255, 255, 255, 255, 255, 255, 0, 1, 54, 55,
		56, 57, 58, 59, 60, 61, 62, 63, 255, 255,
		255, 255, 255, 255, 255, 2, 3, 4, 5, 6,
		7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
		17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
		255, 255, 255, 255, 255, 255, 28, 29, 30,
		31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
		41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
		51, 52, 53, 255, 255, 255, 255, 255
		};
		#define CHAR64(c)  ( (c) > 127 ? 255 : index_64[(c)])
		
		static void
		decode_base64(u_int8_t *buffer, u_int16_t len, u_int8_t *data)
		{
		u_int8_t *bp = buffer;
		u_int8_t *p = data;
		u_int8_t c1, c2, c3, c4;
		while (bp < buffer + len) {
		c1 = CHAR64(*p);
		c2 = CHAR64(*(p + 1));
		
		/* Invalid data */
		if (c1 == 255 || c2 == 255)
		break;
		
		*bp++ = (c1 << 2) | ((c2 & 0x30) >> 4);
		if (bp >= buffer + len)
		break;
		
		c3 = CHAR64(*(p + 2));
		if (c3 == 255)
		break;
		
		*bp++ = ((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2);
		if (bp >= buffer + len)
		break;
		
		c4 = CHAR64(*(p + 3));
		if (c4 == 255)
		break;
		*bp++ = ((c3 & 0x03) << 6) | c4;
		
		p += 4;
		}
		}
		
		static void
		encode_salt(char *salt, u_int8_t *csalt, u_int16_t clen, u_int8_t logr)
		{
		salt[0] = '$';
		salt[1] = BCRYPT_VERSION;
		salt[2] = 'a';
		salt[3] = '$';
		
		snprintf(salt + 4, 4, "%2.2u$", logr);
		
		encode_base64((u_int8_t *) salt + 7, csalt, clen);
		}
		/* Generates a salt for this version of crypt.
		Since versions may change. Keeping this here
		seems sensible.
		*/
		
		char *
		bcrypt_gensalt(u_int8_t log_rounds)
		{
		u_int8_t csalt[BCRYPT_MAXSALT];
		
		arc4random_buf(csalt, sizeof(csalt));
		
		if (log_rounds < 4)
		log_rounds = 4;
		else if (log_rounds > 31)
		log_rounds = 31;
		
		encode_salt(gsalt, csalt, BCRYPT_MAXSALT, log_rounds);
		return gsalt;
		}
		/* We handle $Vers$log2(NumRounds)$salt+passwd$
		i.e. $2$04$iwouldntknowwhattosayetKdJ6iFtacBqJdKe6aW7ou */
		
		char   *
		bcrypt(const char *key, const char *salt)
		{
		Blowfish_Context state;
		u_int32_t rounds, i, k;
		u_int16_t j;
		u_int8_t key_len, salt_len, logr, minor;
		u_int8_t ciphertext[4 * BCRYPT_BLOCKS] = "OrpheanBeholderScryDoubt";
		u_int8_t csalt[BCRYPT_MAXSALT];
		u_int32_t cdata[BCRYPT_BLOCKS];
		int n;
		
		/* Discard "$" identifier */
		salt++;
		
		if (*salt > BCRYPT_VERSION) {
		/* How do I handle errors ? Return ':' */
		return error;
		}
		
		/* Check for minor versions */
		if (salt[1] != '$') {
		switch (salt[1]) {
		case 'a':
		/* 'ab' should not yield the same as 'abab' */
		minor = salt[1];
		salt++;
		break;
		default:
		return error;
		}
		} else
		minor = 0;
		
		/* Discard version + "$" identifier */
		salt += 2;
		
		if (salt[2] != '$')
		/* Out of sync with passwd entry */
		return error;
		
		/* Computer power doesn't increase linear, 2^x should be fine */
		n = atoi(salt);
		if (n > 31 || n < 0)
		return error;
		logr = (u_int8_t)n;
		if ((rounds = (u_int32_t) 1 << logr) < BCRYPT_MINROUNDS)
		return error;
		
		/* Discard num rounds + "$" identifier */
		salt += 3;
		
		if (strlen(salt) * 3 / 4 < BCRYPT_MAXSALT)
		return error;
		
		/* We dont want the base64 salt but the raw data */
		decode_base64(csalt, BCRYPT_MAXSALT, (u_int8_t *) salt);
		salt_len = BCRYPT_MAXSALT;
		key_len = strlen(key) + (minor >= 'a' ? 1 : 0);
		
		/* Setting up S-Boxes and Subkeys */
		Blowfish_initstate(&state);
		Blowfish_expandstate(&state, csalt, salt_len,
		(u_int8_t *) key, key_len);
		for (k = 0; k < rounds; k++) {
		Blowfish_expand0state(&state, (u_int8_t *) key, key_len);
		Blowfish_expand0state(&state, csalt, salt_len);
		}
		
		/* This can be precomputed later */
		j = 0;
		for (i = 0; i < BCRYPT_BLOCKS; i++)
		cdata[i] = Blowfish_stream2word(ciphertext, 4 * BCRYPT_BLOCKS, &j);
		
		/* Now do the encryption */
		for (k = 0; k < 64; k++)
		blf_enc(&state, cdata, BCRYPT_BLOCKS / 2);
		
		for (i = 0; i < BCRYPT_BLOCKS; i++) {
		ciphertext[4 * i + 3] = cdata[i] & 0xff;
		cdata[i] = cdata[i] >> 8;
		ciphertext[4 * i + 2] = cdata[i] & 0xff;
		cdata[i] = cdata[i] >> 8;
		ciphertext[4 * i + 1] = cdata[i] & 0xff;
		cdata[i] = cdata[i] >> 8;
		ciphertext[4 * i + 0] = cdata[i] & 0xff;
		}
		
		
		i = 0;
		encrypted[i++] = '$';
		encrypted[i++] = BCRYPT_VERSION;
		if (minor)
		encrypted[i++] = minor;
		encrypted[i++] = '$';
		
		snprintf(encrypted + i, 4, "%2.2u$", logr);
		
		encode_base64((u_int8_t *) encrypted + i + 3, csalt, BCRYPT_MAXSALT);
		encode_base64((u_int8_t *) encrypted + strlen(encrypted), ciphertext,
		4 * BCRYPT_BLOCKS - 1);
		memset(&state, 0, sizeof(state));
		memset(ciphertext, 0, sizeof(ciphertext));
		memset(csalt, 0, sizeof(csalt));
		memset(cdata, 0, sizeof(cdata));
		return encrypted;
		}
		
		static void
		encode_base64(u_int8_t *buffer, u_int8_t *data, u_int16_t len)
		{
		u_int8_t *bp = buffer;
		u_int8_t *p = data;
		u_int8_t c1, c2;
		while (p < data + len) {
		c1 = *p++;
		*bp++ = Base64Code[(c1 >> 2)];
		c1 = (c1 & 0x03) << 4;
		if (p >= data + len) {
		*bp++ = Base64Code[c1];
		break;
		}
		
		c2 = *p++;
		
		c1 |= (c2 >> 4) & 0x0f;
		*bp++ = Base64Code[c1];
		
		c1 = (c2 & 0x0f) << 2;
		if (p >= data + len) {
		*bp++ = Base64Code[c1];
		break;
		}
		
		c2 = *p++;
		
		c1 |= (c2 >> 6) & 0x03;
		*bp++ = Base64Code[c1];
		*bp++ = Base64Code[c2 & 0x3f];
		}
		*bp = '\0';
		}
		#if 0
		void
		main()
		{
		char    blubber[73];
		char    salt[100];
		char   *p;
		salt[0] = '$';
		salt[1] = BCRYPT_VERSION;
		salt[2] = '$';
		
		snprintf(salt + 3, 4, "%2.2u$", 5);
		
		printf("24 bytes of salt: ");
		fgets(salt + 6, sizeof(salt) - 6, stdin);
		salt[99] = 0;
		printf("72 bytes of password: ");
		fpurge(stdin);
		fgets(blubber, sizeof(blubber), stdin);
		blubber[72] = 0;
		
		p = crypt(blubber, salt);
		printf("Passwd entry: %s\n\n", p);
		
		p = bcrypt_gensalt(5);
		printf("Generated salt: %s\n", p);
		p = crypt(blubber, p);
		printf("Passwd entry: %s\n", p);
		}
		#endif
	#tag EndNote


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static mb as MemoryBlock = "./ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
			  return mb
			End Get
		#tag EndGetter
		Private Base64Code As MemoryBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private index_64() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zInited As Boolean
	#tag EndProperty


	#tag Constant, Name = BCRYPT_BLOCKS, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BCRYPT_MAXSALT, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BCRYPT_MINROUNDS, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BCRYPT_VERSION, Type = String, Dynamic = False, Default = \"2", Scope = Protected
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
