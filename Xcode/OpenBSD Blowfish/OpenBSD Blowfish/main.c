//
//  main.c
//  OpenBSD Blowfish
//
//  Created by Kem Tekinay on 1/28/14.
//  Copyright (c) 2014 Kem Tekinay. All rights reserved.
//

#include <stdio.h>
#include "./blf.h"

int main(int argc, const char * argv[])
{

    // insert code here...
    
    blf_ctx c ;
    
    u_int8_t key[] = "password" ;
    u_int8_t astring[] = "sometext12345678" ;

    Blowfish_initstate( &c ) ;
    Blowfish_expand0state( &c, &key, 8 ) ;
   // Blowfish_expandstate( &c, &astring, 8, &key, 8 ) ;
    blf_ecb_encrypt( &c, &astring, 16 ) ;
    blf_ecb_decrypt( &c, &astring, 16 ) ;
    
    return 0;
}

