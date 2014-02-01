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
    u_int8_t astring[] = "sometext123" ;

    Blowfish_initstate( &c ) ;
    Blowfish_expand0state( &c, &key, 8 ) ;
//Blowfish_expandstate( &c, &astring, 8, &key, 8 ) ;
    blf_enc( &c, &astring, 1 ) ;
    blf_dec( &c, &astring, 1 ) ;
    
    return 0;
}

