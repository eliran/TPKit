//
//  NSString+Extensions.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)
+(NSString *)stringWithHexOfBytes:(const void *)bytes count:(NSUInteger)count {
  NSMutableString *hexString = [NSMutableString new];
  while ( count-- > 0 ) {
    [hexString appendFormat:@"%02x", *((unsigned char *)bytes)];
    bytes += 1;
  }
  return hexString.copy;
}

-(NSRange)range {
  return (NSRange){
    .location= 0,
    .length= self.length
  };
}
@end
