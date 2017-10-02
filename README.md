# M_Crypto for Xojo

An encryption library for Xojo that implements Blowfish and AES encryption and Bcrypt hash module, translated from C libraries (included as Xcode projects).


## Table of Contents

- [Important Changes From Blowfish\_MTC Project](#important-changes)
- [How To Use It](#how-to-use-it)
	- [Examples](#examples)
		- [Blowfish](#blowfish-example)
		- [AES](#aes-example)
		- [Encrypter (super class)](#encrypter-example)
		- [Bcrypt](#bcrypt-example)
	- [Encryption](#encryption)
	- [Bcrypt](#bcrypt)
- [About ECB, CBC, and the Vector](#about-ecb-etc)
- [About Padding](#about-padding)
	- [NullsOnly](#nullsonly)
	- [NullsWithCount](#nullswithcount)
	- [PKCS](#pkcs)
- [Compatibility](#compatibility)
	- [Postgres](#postgres)
	- [JavaScript Crypto Module](#javascript-crypto-module)
- [Other](#other)
- [License](#license)
- [Comments and Contributions](#comments-and-contributions)
- [Who Did This?!?](#who-did-this)
- [Release Notes](#release-notes)

## <a name='important-changes'></a>Important Changes From Blowfish\_MTC Project

This project was originally released as Blowfish\_MTC and included the Blowfish\_MTC class and Bcrypt module. These have been rolled into M_Crypto with some important changes that may affect existing projects.

- Padding.PKSC5 has been renamed PKCS and is now the default for Blowfish\_MTC.
- Padding.NullPadding has been renamed NullsWithCount and is no longer the default for Blowfish\_MTC.
- `Encrypt` and `Decrypt` used to take an optional parameter for vector. Now you must use `SetInitialVector` or `ResetInitialVector`.
- Padding.NullsOnly has been added.
- `Bcrypt_MTC.Bcrypt` has been deprecated in favor of `Bcrypt_MTC.Hash`.

## <a name='how-to-use-it'></a>How To Use It

### Examples

Let's start with some examples. These are meant to give you an idea of the ways you can use these classes and modules, not how you _must_ use them. Code that demonstrates one Encrypter can usually be used with the other.

#### <a name='blowfish-example'></a>Blowfish

```
dim bf as new Blowfish_MTC( "password", Blowfish_MTC.Padding.PKCS )

dim data as string = EncodeHex( bf.Encrypt( "some data" ) )
// 774FB372E0636E70BA65D0BD35D78829

data = EncodeHex( bf.EncryptECB( "some data" ) )
// D9B0A79853F139603951BFF96C3D0DD5

bf.SetInitialVector "my vecto" // 8 bytes
data = EncodeHex( bf.EncryptCBC( "some data" ) )
// 9B0BA2B3716E777FD89048BC8738869A

bf.SetKey "another password"
data = EncodeHex( bf.Encrypt( "some data" ) )
// 00884CF6829D2CBA51989BB19AF84945

bf.PaddingMethod = Blowfish_MTC.Padding.NullsWithCount
data = EncodeHex( bf.Encrypt( "some data" ) )
// 00884CF6829D2CBACCE75A5012ED7631

```

#### <a name='aes-example'></a>AES

```
dim aes as new AES_MTC( AES_MTC.EncryptionBits.Bits128 )

aes.SetKey "password"
aes.PaddingMethod = AES_MTC.Padding.NullsOnly
dim data as string = EncodeHex( aes.Encrypt( "some data" ) )
// 9EAC7C8DC34E13B89B89F9F6D08E830F

aes = new AES_MTC( _
    "another password", AES_MTC.EncryptionBits.Bits256, AES_MTC.Padding.PKCS )
aes.SetInitialVector "1234567890ABCDEF1234567890ABCDEF" // 16 bytes as hex
data = EncodeHex( aes.EncryptCBC( "some data" ) )
// 6984F179E4F969A79CC8D6AD1F295244

```

#### <a name='encrypter-example'></a>Encrypter (super class)

```
dim e as M_Crypto.Encrypter

e = new AES_MTC( 128 )
e.SetKey "password"
e.SetInitialVector "I need 16 bytes!"
e.UseFunction = M_Crypto.Encrypter.Functions.CBC
dim data as string = EncodeHex( e.Encrypt( "some data" ) )
// DDF9F81FF318E5D0596BE0B24CE801DD

e = new Blowfish_MTC
e.SetKey "password"
e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
data = EncodeHex( e.EncryptECB( "some data" ) )
// D9B0A79853F139603951BFF96C3D0DD5

e = M_Crypto.GetEncrypter( "aes-256-cbc" )
e.SetKey "password"
e.PaddingMethod = M_Crypto.Encrypter.Padding.PKCS
e.SetInitialVector "I need 16 bytes!"
data = EncodeHex( e.Encrypt( "some data" ) )
// 90BD2689FC13EDD41063AE6DD18AD1D2
```

#### <a name='bcrypt-example'></a>Bcrypt

```
dim hash as string = Bcrypt_MTC.Hash( "somebody's password", 10 )
// $2y$10$ZPkkuUAmRjx7JBDylI6GL.Pe4p.8G5dUBhl9grZg/b08Gh.1G8Ez.

if Bcrypt_MTC.Verify( _
    "somebody's password", _
    "$2y$10$ZPkkuUAmRjx7JBDylI6GL.Pe4p.8G5dUBhl9grZg/b08Gh.1G8Ez." ) then
  MsgBox "That's right"
end if

dim salt as string = Bcrypt_MTC.GenerateSalt( 10 )
// $2y$10$7XjO9J5P1DJJPCy7xbHYHu , for example
hash = Bcrypt_MTC.Hash( "somebody's password", salt )
// $2y$10$7XjO9J5P1DJJPCy7xbHYHuCSdEEaV6gsxhZbogNGFlq5dwAiX2S8K
    
```

### Encryption

The encryption objects are based on the superclass `M_Crypto.Encrypter` and offer the following common methods and properties:

```
SetKey( string )
PaddingMethod as M_Crypto.Encrypter.Padding
SetInitialVector( string )
ResetInitialVector()
CurrentVector as String [read-only]
BlockSize as Integer [read-only]

UseFunction as M_Crypto.Encrypter.Functions

Encrypt( data As String, isFinalBlock As Boolean = True )
EncryptCBC( data As String, isFinalBlock As Boolean = True )
EncryptECB( data As String, isFinalBlock As Boolean = True )

Decrypt( data As String, isFinalBlock As Boolean = True )
DecryptCBC( data As String, isFinalBlock As Boolean = True )
DecryptECB( data As String, isFinalBlock As Boolean = True )

```

`UseFunction` will determine what happens when `Encrypt` or `Decrypt` are called. If left at Default, the default encryption is used, otherwise it will redirect to ECB or CBC as specified.

Create an object for the type of encryption you want and optionally specify the key and padding. Each can be set later if desired with `SetKey` and `PaddingMethod` respectively.

Each type of encryption defaults to PKCS padding.

Example:

```
dim bf as Blowfish_MTC

bf = new Blowfish_MTC( "my encryption key" )
bf = new Blowfish_MTC( Blowfish_MTC.Padding.NullsOnly )
bf = new Blowfish_MTC( "my encryption key", Blowfish_MTC.Padding.PKCS )
bf = new Blowfish_MTC // Set the key at least before using

```

AES requires its encryption bits in its Constructor. Examples:

```
dim aes as AES_MTC

aes = new AES_MTC( AES_MTC.EncryptionBits.Bits128 )
aes = new AES_MTC( 256 )
aes = new AES_MTC( "my encryption key", AES_MTC.EncryptionBits.Bits192 )
aes = new AES_MTC( _
    "my encryption key", _
    AES_MTC.EncryptionBits.Bits192, _
    AES_MTC.Padding.NullsOnly )
```

`AES.Encrypt` and `Decrypt` default to ECB if `UseFunction` is set to Default.

With either encryption, you must set the key before attempting to encrypt or decrypt.

You can use `M_Crypto.GetEncrypter` to get an Encrypter by code. For example, "bf" will return a Blowfish\_MTC, "aes-256" an AES\_MTC preset to 256-bit, and "aes-128-cbc" an AES\_MTC preset to 256-bit and the default functions set to use CBC. In each case you must set the key, the padding if needed, and the vector if applicable.

### Bcrypt

Bcrypt uses Blowfish to create a hash. The more rounds you specify, the longer it takes. You can either create your own salt according to the Bcrypt standard or let the module do it for you. See the example above in Examples.

## <a name='about-ecb-etc'></a>About ECB, CBC, and the Vector

ECB encryption treats each block of data individually. This means that repeating blocks will be encrypted in the same way. For example, using Blowfish to encrypt the repeating data "12345678ABCDEFGH12345678" will lead to this result as hex: "DA6003664651D153 805D00DD8BF2133B DA6003664651D153". Notice the first 8 bytes are identical the last 8 bytes.

CBC will chain encryption so the result of the each block will affect the next block. Using CBC and no vector in the above example will result in: "DA6003664651D153 2066457C3AE99820 5C937C55EE7EDEF0". Notice that the first block is identical to that produced by ECB but the subsequent blocks are different.

When using CBC, you can affect the result of the first block by specifying an initial vector, a number of bytes equal to the block size of the Encrypter (8 bytes for Blowfish, 16 bytes for AES). The vector is ignored when using ECB.

## <a name='about-padding'></a>About Padding

Encryption algorithms require that data be given in multiples of known block sizes (8 bytes for Blowfish, 16 bytes for AES), but because the real world is rarely that neat, data must be padded to the required bytes.

M_Crypto offers three methods for padding that come with their own rules.

### NullsOnly

This simply appends nulls to the end of the data to reach the required size. When decrypted, the trailing nulls are trimmed. Data that is already a multiple of the block size will not be padded.

This method should usually be avoided unless you are going to pad the data yourself.

### NullsWithCount

The data is padded with nulls followed by a count of the number of padding bytes. Data is that already a multiple of the block size will not be padded _unless_ the last bytes match the pattern of a pad. In other words, if the data ends with "00 00 00 04", a pad equal to the block size will be added.

### PKCS

A pad is always added to the data even if it's already a multiple of the block size. The bytes added are the number of padding bytes repeated. For example, if 5 pad bytes are needed, the pad will be "05 05 05 05 05".

Because a pad is always expected, the lack of this pad will raise an M_Crypto.InvalidPaddingException.

The is the default method for AES and Blowfish.

## Compatibility

The output of the CBC and ECB functions using PKCS padding will be identical to that of other platforms.

### Postgres

```
SELECT encrypt('some data', 'password', 'bf-cbc/pad:pkcs')::TEXT;
-- \xd9b0a79853f13960fcee3cae16e27884
SELECT encrypt_iv('some data', 'password', 'I need 16 bytes!', 'aes-cbc/pad:pkcs')::TEXT; -- AES-128
-- \xddf9f81ff318e5d0596be0b24ce801dd
SELECT encrypt_iv('some data', digest('password', 'SHA256'), 'I need 16 bytes!', 'aes-cbc/pad:pkcs')::TEXT; -- AES-256
-- \x7d0fd83942c4948081213c8526af8af3
```

__Note__: The key size will determine whether Postgres uses AES-128, AES-192, or AES-256, i.e., a 128-bit (or less) key will force AES-128 while a 129-bit key will force AES-192.  A key of 256 bits or more will force AES-256.

### <a name='javascript-crypto-module'></a>JavaScript Crypto Module

The Crypto module follows these rules as of this writing:

AES: Requires a key the size of the specified bits, i.e., AES-128 needs 16 bytes, AES-256 needs 32 bytes.

Blowfish ECB: Will take any key but it will apply an MD5 hash to it internally.

Blowfish CBC: Will take any key.

## Other

`M_Crypto.GeenrateUUID` will create a UUI using the OS tools, if possible, or native Xojo code if note. In any case, the output conforms to standards and is cryptographically safe.

## License

This is an open-source project.

This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied. You may freely use or modify this project or any part of within as long as this notice or any other legal notice is left undisturbed.

You may distribute a modified version of this project as long as all modifications are clearly documented and accredited.

## <a name='comments-and-contributions'></a>Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

## <a name='who-did-this'></a>Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay at mactechnologies dot com).

## <a name='release-notes'></a>Release Notes

__2.2__ (__)

- Added `M_Crypto.GenerateUUID`.
- Fixed Windows bug in M_ANSI.

__2.1__ (Sept. 27, 2017)

- Refactored to streamline code.
- Changed NullsWithCount padding to conform to standard. It will now add padding in all cases, even if the block is already the right size. This means the last padding byte can be 0x01, something that wasn't allowed in the previous version. Depadding will still work on something encrypted like that unless you decrypt in blocks and the last block is <= BlockSize.
- Added the CLI project and reorganized files in general.

__2.0__ (Sept. 19, 2017)

- Renamed M\_Crypto and other classes rolled into that module.
- Introduced AES.
- Renamed padding "PKCS5" to "PKCS".
- Renamed `SetVector` to `SetInitialVector` and took it out of the `Constructor`.
- Introduced the Encrypter superclass and the ability to get an Encrypter via code.
- Padding.NullPadding has been renamed NullsWithCount.
- The default padding for Blowfish\_MTC is now PKCS, not NullsWithCount.
- `Bcrypt_MTC.Bcrypt` has been deprecated in favor of `Bcrypt_MTC.Hash`.
- Refactored Harness to include an all-purpose encryption/decryption utility and unit tests.

__1.0__ (some time ago as Blowfish\_MTC)

- Initial release of Blowfish and Bcrypt.