//
//  NSData+Extensions.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "NSData+Extensions.h"
#import "NSString+Extensions.h"
@implementation NSData (Extensions)
-(NSString *)hexString {
  return [NSString stringWithHexOfBytes:self.bytes count:self.length];
}
@end
