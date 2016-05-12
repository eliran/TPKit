//
//  NSData+AES256.h
//  NineBingo2D
//
//  Created by Eliran Ben Ezra on 10/18/12.
//  Copyright (c) 2012 Eliran Ben Ezra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
+(NSData *)AES256GenerateKeyWithPassword:(char *)password salt:(NSData *)salt;
+(NSData *)AES256EncryptData:(void *)data length:(NSUInteger)dataLength withKey:(void *)key length:(NSUInteger)keyLength withPadding:(BOOL)padding;
+(NSData *)AES256DecryptData:(void *)data length:(NSUInteger)dataLength withKey:(void *)key length:(NSUInteger)keyLength withPadding:(BOOL)padding;
-(NSData *)AES256DecryptWithKey:(NSData *)key;
-(NSData *)AES256EncryptWithKey:(NSData *)key;
@end
