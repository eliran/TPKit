//
//  NSDictionary+LazyGenerator.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "NSDictionary+LazyGenerator.h"

#define KeyType id
#define ObjectType id

@implementation NSDictionaryGenerator {
  NSDictionary *_dictionary;
  NSEnumerator *keyEnumerator;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
  if((self=[super init])){
    _dictionary = dictionary;
  }
  return self;
}
-(void)nextKey:(__autoreleasing id<NSCopying> *)key value:(__autoreleasing id *)value {
  if ( keyEnumerator == nil )
    keyEnumerator = _dictionary.keyEnumerator;
  id<NSCopying> nextKey = keyEnumerator.nextObject;
  *key = nextKey; *value = _dictionary[nextKey];
  if ( nextKey == nil )
    keyEnumerator = nil;
}

@end

@implementation NSDictionary (LazyGenerator)
-(NSDictionaryGenerator *)lazy {
  return [[NSDictionaryGenerator alloc] initWithDictionary:self];
}

-(NSDictionary *)map:(MAP_KEYVALUE_BLOCK)mapBlock {
  return [self.lazy map:mapBlock].dictionary;
}
-(NSDictionary *)mapKeys:(MAP_KEYS_KEYVALUE_BLOCK)mapBlock {
  return [self.lazy mapKeys:mapBlock].dictionary;
}
-(NSDictionary *)filter:(BOOL_KEYVALUE_BLOCK)filterBlock {
  return [self.lazy filter:filterBlock].dictionary;
}
-(NSDictionary *)keep:(BOOL_KEYVALUE_BLOCK)keepBlock {
  return [self.lazy keep:keepBlock].dictionary;
}
-(NSArray *)toArray:(TO_ARRAY_BLOCK)toArrayBlock {
  return [self.lazy toArray:toArrayBlock].array;
}

@end
