//
//  TPXMLParser.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPXMLElement.h"

@interface TPXMLParser : NSObject
+(TPXMLElement *)parseWithData:(NSData *)xmlData;
+(TPXMLElement *)parseWithString:(NSString *)xmlString;

-(instancetype)initWithData:(NSData *)data;
@end
