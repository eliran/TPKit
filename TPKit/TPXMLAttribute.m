//
//  TPXMLAttribute.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPXMLAttribute.h"

@implementation TPXMLAttribute
+(NSSet<TPXMLAttribute *> *)attributesFromDictionary:(NSDictionary<NSString *,id> *)dictionary {
  NSMutableSet *attributeSet = [NSMutableSet new];
  for (NSString *attributeName in dictionary) {
    [attributeSet addObject:[TPXMLAttribute attributeWithName:attributeName
                                                        value:[dictionary[attributeName] description]]];
  }
  return attributeSet.copy;
}
+(instancetype)attributeWithName:(NSString *)name value:(NSString *)value {
  return [self.alloc initWithName:name value:value];
}
-(instancetype)initWithName:(NSString *)name value:(NSString *)value {
  if((self=[super init])){
    _name = [TPXMLName.alloc initWithFullName:name];
    _value = value;
  }
  return self;
}
-(NSUInteger)hash {
  return _name.hash;
}
-(NSComparisonResult)compare:(TPXMLAttribute *)attribute {
  return [_name.full compare:attribute.name.full];
}
-(BOOL)isEqual:(TPXMLAttribute *)object {
  if ( [object isKindOfClass:TPXMLAttribute.class] )
    return [_name isEqual:object.name];
  return NO;
}
-(NSString *)toString {
  return [NSString stringWithFormat:@"%@=\"%@\"", _name.full, _value];
}
@end
