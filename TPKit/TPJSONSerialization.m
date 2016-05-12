//
//  TPJSONSerialization.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPJSONSerialization.h"
#import "TPKit.h"
@implementation TPJSONSerialization

NSString *JSONSerializeString(NSString *string){
  string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
  string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
  string = [string stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
  string = [string stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
  string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
  string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
  return [NSString stringWithFormat:@"\"%@\"", string];
}
NSString *JSONSerializeNumber(NSNumber *number){
  const char *type = number.objCType;
  if ( type[0] == 'c')
    return number.boolValue ? @"true" : @"false";
  return [NSString stringWithFormat:@"%@", number];
}
NSString *JSONSerializeDictionary(NSDictionary *dict){
  NSArray *sortedKeys = [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
  return [NSString stringWithFormat:@"{%@}",[[sortedKeys map:^id(NSString *element) {
    return [NSString stringWithFormat:@"\"%@\":%@",
            element,
            [TPJSONSerialization stringWithJSONObject:dict[element] error:nil]];
  }] componentsJoinedByString:@","]];
}
NSString *JSONSerializeArray(NSArray *array){
  return [NSString stringWithFormat:@"[%@]",[[array map:^id(id element) {
    return [TPJSONSerialization stringWithJSONObject:element error:nil];
  }] componentsJoinedByString:@","]];
}
+(NSString *)stringWithJSONObject:(id)object error:(NSError **)error {
  if ( error ) *error = nil;
  if ( [object isKindOfClass:NSArray.class] )
    return JSONSerializeArray(object);
  if ( [object isKindOfClass:NSDictionary.class] )
    return JSONSerializeDictionary(object);
  if ( [object isKindOfClass:NSString.class] )
    return JSONSerializeString(object);
  if ( [object isKindOfClass:NSNumber.class] )
    return JSONSerializeNumber(object);
  if ( object == nil || object == [NSNull null] )
    return @"null";
  if ( error ) {
    NSString *className = NSStringFromClass([object class]);
    *error = [NSError errorWithDomain:@"JSONSerialize"
                                 code:1
                             userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"class '%@' serialization is not supported", className]}];
  }
  return nil;
}
@end
