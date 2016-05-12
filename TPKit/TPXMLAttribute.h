//
//  TPXMLAttribute.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPXMLName.h"
@interface TPXMLAttribute : NSObject
@property (readonly)TPXMLName *name;
@property (readonly)NSString *value;

+(NSSet<TPXMLAttribute *> *)attributesFromDictionary:(NSDictionary<NSString *, id> *)dictionary;
+(instancetype)attributeWithName:(NSString *)name value:(NSString *)value;

-(NSString *)toString;
@end
