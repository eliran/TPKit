//
//  TPXMLName.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPXMLName.h"

@implementation TPXMLName
-(instancetype)initWithFullName:(NSString *)fullName {
  if((self=[super init])){
    _full = fullName;
  }
  return self;
}
-(NSArray *)components {
  return [_full componentsSeparatedByString:@":"];
}
-(NSString *)name {
  return self.components.lastObject;
}
-(NSString *)space {
  NSArray *components = self.components;
  NSUInteger count = components.count;
  if ( count <= 1 ) return nil;
  return [[components subarrayWithRange:(NSRange){.location=0, .length= count-1}] componentsJoinedByString:@":"];
}
-(NSUInteger)hash {
  return _full.hash;
}
-(BOOL)isEqual:(TPXMLName *)object {
  if ( [object isKindOfClass:TPXMLName.class] )
    return [_full isEqualToString:object.full];
  return NO;
}
@end
