//
//  main.c
//  Base64
//
//  Created by Kem Tekinay on 1/26/14.
//  Copyright (c) 2014 Kem Tekinay. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <pwd.h>
#include "./blf.h"

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
    blf_ctx state;
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

int main(int argc, const char * argv[])
{

    // insert code here...
    char *salt = "$2a$10$1234567890123456789012" ;
    char *data = "that" ;
    
    char *result = bcrypt(data, salt) ;
    printf( result ) ;
    printf("\n");
    
    return 0;
}

