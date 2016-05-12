//
//  NSDictionary+TPSafeFieldExtracting.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/16/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "NSDictionary+TPSafeFieldExtracting.h"

@implementation NSDictionary (TPSafeFieldExtracting)
-(NSNumber *)numberField:(id<NSCopying>)field {
  if ( field ) {
    id fieldObject = self[field];
    if ( [fieldObject isKindOfClass:NSNumber.class] )
      return fieldObject;
    if ( [fieldObject isKindOfClass:NSString.class] )
      return [[NSNumberFormatter new] numberFromString:fieldObject];
  }
  return nil;
}
-(NSArray *)arrayField:(id<NSCopying>)field {
  if ( field ) {
    id arrayField = self[field];
    if ( [arrayField isKindOfClass:NSArray.class] )
      return arrayField;
  }
  return nil;
}
-(NSDictionary *)dictionaryField:(id<NSCopying>)field {
  if ( field ) {
    id dictField = self[field];
    if ( [dictField isKindOfClass:NSDictionary.class] )
      return dictField;
  }
  return nil;
}
-(NSString *)stringField:(id<NSCopying>)field {
  if ( field ) {
    id stringField = self[field];
    if ( [stringField isKindOfClass:NSString.class] )
      return stringField;
    if ( [stringField respondsToSelector:@selector(stringValue)] )
      return [stringField stringValue];
  }
  return nil;
}

-(NSInteger)integerField:(id<NSCopying>)field {
  return [self integerField:field withDefault:0];
}
-(NSInteger)integerField:(id<NSCopying>)field withDefault:(NSInteger)defaultValue {
  id numberObject = [self numberField:field];
  if ( numberObject ) return [numberObject integerValue];
  return defaultValue;
}
-(double)realField:(id<NSCopying>)field {
  return [self realField:field withDefault:0.0];
}
-(double)realField:(id<NSCopying>)field withDefault:(double)defaultValue {
  id numberObject = [self numberField:field];
  if ( numberObject ) return [numberObject doubleValue];
  return defaultValue;
}

-(nullable id)field:(id<NSCopying>)field withDefault:(id)defaultValue {
  if ( field ) {
    id fieldValue = self[field];
    if ( fieldValue ) return fieldValue;
  }
  return defaultValue;
}

@end
