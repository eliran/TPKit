//
//  NSData+AES256.m
//  NineBingo2D
//
//  Created by Eliran Ben Ezra on 10/18/12.
//  Copyright (c) 2012 Eliran Ben Ezra. All rights reserved.
//

// NOTE: I've tried to use the IV value of the CCCrypt function. It seems, however,
//         that the something is going wrong. (Every save cycle I get a different first
//          block, which mean that the XOR mask must be applied only once in some stage)
//          until I can solve this, I prefer not working with the IV and just passing
//          NULL.
// NOTE: Problem may have been found. Try working with IV again

#import "NSData+AES256.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (AES256)
+(NSData *)AES256GenerateKeyWithPassword:(char *)password salt:(NSData *)salt{
  char key[kCCKeySizeAES256+kCCBlockSizeAES128];
  bzero(key,sizeof(key));
  if ( password ) {
    CCKeyDerivationPBKDF(kCCPBKDF2, password, strlen(password), (void *)[salt bytes], [salt length], kCCPRFHmacAlgSHA512, 500, (void *)key, sizeof(key));
  }
  NSData *retKey = [NSData dataWithBytes:key length:sizeof(key)];
  bzero(key, sizeof(key));
  return retKey;
}
+(NSData *)AES256EncryptData:(void *)data length:(NSUInteger)dataLength withKey:(void *)key length:(NSUInteger)keyLength withPadding:(BOOL)padding {
  if ( data && dataLength>0 && (padding||(dataLength%kCCBlockSizeAES128)==0)  ) {
    char keyPtr[kCCKeySizeAES256+kCCBlockSizeAES128]; // Room for key & iv
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    memcpy(keyPtr, key, MIN(sizeof(keyPtr), keyLength));
    size_t bufferSize = dataLength + (padding?kCCBlockSizeAES128:0);
    void *buffer = malloc(bufferSize);
	
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, padding?kCCOptionPKCS7Padding:0,
                                          &keyPtr[0], kCCKeySizeAES256,
                                          NULL,//&keyPtr[kCCKeySizeAES256] /* initialization vector */,
                                          data, dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    bzero(keyPtr, sizeof(keyPtr)); // Clear copy of key
    if (cryptStatus == kCCSuccess) {
      //the returned NSData takes ownership of the buffer and will free it on deallocation
      return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer); //free the buffer;
  }
  return nil;
}
+(NSData *)AES256DecryptData:(void *)data length:(NSUInteger)dataLength withKey:(void *)key length:(NSUInteger)keyLength withPadding:(BOOL)padding {
  if ( data && dataLength>0 && (padding||(dataLength%kCCBlockSizeAES128)==0) ) {
    char keyPtr[kCCKeySizeAES256+kCCBlockSizeAES128]; // Room for key & iv
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    memcpy(keyPtr, key, MIN(sizeof(keyPtr), keyLength));
    void *buffer = malloc(dataLength);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, padding?kCCOptionPKCS7Padding:0,
                                          &keyPtr[0], kCCKeySizeAES256,
                                          NULL,//&keyPtr[kCCKeySizeAES256] /* initialization vector */,
                                          data, dataLength, /* input */
                                          buffer, dataLength, /* output */
                                          &numBytesDecrypted);
    bzero(keyPtr, sizeof(keyPtr));
    if (cryptStatus == kCCSuccess) {
      //the returned NSData takes ownership of the buffer and will free it on deallocation
      return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer); //free the buffer;
  }
  return nil;
}
-(NSData *)AES256EncryptWithKey:(NSData *)key {
  return [NSData AES256EncryptData:(void *)[self bytes] length:[self length] withKey:(void *)[key bytes] length:[key length] withPadding:YES];
}

-(NSData *)AES256DecryptWithKey:(NSData *)key {
  return [NSData AES256DecryptData:(void *)[self bytes] length:[self length] withKey:(void *)[key bytes] length:[key length] withPadding:YES];
}
@end
