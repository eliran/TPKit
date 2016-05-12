//
//  NSString+Extensions.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)
+(NSString *)stringWithHexOfBytes:(const void *)bytes count:(NSUInteger)count;
-(NSRange)range;
@end
