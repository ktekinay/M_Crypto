# M_Crypto for Xojo

An encryption library for Xojo that implements Blowfish and AES and Bcrypt hash module, translated from C libraries (included as Xcode projects).

## How To Use It

### Encryption

The encryption objects are based on the superclass `M_Crypto.Encrypter` and offer the following common methods and properties:

```
SetKey( string )
PaddingMethod as M_Crypto.Encrypter.Padding
SetVector( string )
ResetVector()
CurrentVector as String (read-only)
BlockSize as Integer (read-only)

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

Each type of encryption defaults to a certain padding. With Blowfish, the default is NullsWithCount. For AES, it is PKCS5.

With Blowfish, padding defaults to NullsWithCount. Example:

```
dim bf as Blowfish_MTC

bf = new Blowfish_MTC( "my encryption key" )
bf = new Blowfish_MTC( Blowfish_MTC.Padding.PKCS5 )
bf = new Blowfish_MTC( "my encryption key", Blowfish_MTC.Padding.PKCS5 )
bf = new Blowfish_MTC // Set the key at least before using

```

AES defaults to PKCS5 padding. Examples:

```
dim aes as AES_MTC

aes = new AES_MTC( AES_MTC.EncryptionBits.Bits128 )
aes = new AES_MTC( 256 )
aes = new AES_MTC( _
    "my encryption key", _
    AES_MTC.EncryptionBits.Bits192, _
    AES_MTC.Padding.NullsOnly )
```

`AES.Encrypt/Decrypt` defaults to ECB if `UseFunction` is set to Default.

With either encryption, you must set the key before attempting to encrypt or decrypt.


### Bcrypt



##License

This is an open-source project.

This project is distributed AS-IS and no warranty of fitness for any particular purpose is expressed or implied. You may freely use or modify this project or any part of within as long as this notice or any other legal notice is left undisturbed.

You may distribute a modified version of this project as long as all modifications are clearly documented and accredited.

##Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

##Who Did This?!?

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).