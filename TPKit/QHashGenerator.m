//
//  QHashGenerator.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QHashGenerator.h"

#define ObjectType id
#define KeyType id

@implementation QHashGenerator
-(QHashGenerator *)map:(MAP_KEYVALUE_BLOCK)mapBlock {
  return [QBlockHashGenerator withKeyValueBlock:^(__autoreleasing id<NSCopying> *key, __autoreleasing id *value) {
    [self nextKey:key value:value];
    if ( *key )
      *value = mapBlock(*key, *value);
  }];
}
-(QHashGenerator *)mapKeys:(MAP_KEYS_KEYVALUE_BLOCK)mapBlock {
  return [QBlockHashGenerator withKeyValueBlock:^(__autoreleasing id<NSCopying> *key, __autoreleasing id *value) {
    [self nextKey:key value:value];
    if ( *key )
      *key = mapBlock(*key, *value);
  }];
}
-(QHashGenerator *)filter:(BOOL_KEYVALUE_BLOCK)filterBlock {
  return [QBlockHashGenerator withKeyValueBlock:^(__autoreleasing id<NSCopying> *key, __autoreleasing id *value) {
    do {
      [self nextKey:key value:value];
    } while( *key && filterBlock(*key, *value) );
  }];
}
-(QHashGenerator *)keep:(BOOL_KEYVALUE_BLOCK)keepBlock {
  return [QBlockHashGenerator withKeyValueBlock:^(__autoreleasing id<NSCopying> *key, __autoreleasing id *value) {
    do {
      [self nextKey:key value:value];
    } while( *key && !keepBlock(*key, *value) );
  }];
}
-(void)each:(EACH_KEYVALUE_BLOCK)eachBlock {
  do {
    id key, value;
    [self nextKey:&key value:&value];
    if ( key == nil ) break;
    eachBlock(key, value);
  } while(1);
}

-(id)findObject:(BOOL_KEYVALUE_BLOCK)findBlock {
  id key, value;
  do {
    [self nextKey:&key value:&value];
    if ( key == nil ) return nil;
    if ( findBlock(key, value) ) return value;
  } while(1);
}
-(id)findKey:(BOOL_KEYVALUE_BLOCK)findBlock {
  id key, value;
  do {
    [self nextKey:&key value:&value];
    if ( key == nil ) return nil;
    if ( findBlock(key, value) ) return key;
  } while(1);
}
-(id)returnObject:(OBJECT_KEYVALUE_BLOCK)findBlock {
  id key, value;
  do {
    [self nextKey:&key value:&value];
    if ( key == nil ) return nil;
    value = findBlock(key, value);
    if ( value != nil ) return value;
  } while(1);
}

-(QArrayGenerator *)toArray:(TO_ARRAY_BLOCK)toArrayBlock {
  return [QBlockArrayGenerator withBlock:^id{
    id<NSCopying> key;
    id value;
    [self nextKey:&key value:&value];
    if ( key == nil ) return nil;
    return toArrayBlock(key, value);
  }];
}
-(QArrayGenerator *)keys {
  return [self toArray:^id(id key, id value) {
    return key;
  }];
}
-(QArrayGenerator *)values {
  return [self toArray:^id(id key, id value) {
    return value;
  }];
}
-(NSDictionary *)dictionary {
  return [[self mutableDictionary] copy];
}
-(NSMutableDictionary *)mutableDictionary {
  NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
  do {
    id<NSCopying> key = nil;
    id value;
    [self nextKey:&key value:&value];
    if ( key == nil || value == nil ) break;
    mutableDictionary[key] = value;
  } while(1);
  return mutableDictionary;
}
-(void)nextKey:(__autoreleasing id<NSCopying> *)key value:(__autoreleasing id *)value {
  *key = nil;
  *value = nil;
}

@end

@implementation QBlockHashGenerator {
  void(^nextBlock)(id<NSCopying> *key, id *value);
}
+(instancetype)withKeyValueBlock:(NEXT_KEYVALUE_BLOCK)block {
  return [[self alloc] initWithKeyValueBlock:block];
}
-(instancetype)initWithKeyValueBlock:(NEXT_KEYVALUE_BLOCK)block {
  if((self=[super init])){
    nextBlock = block;
  }
  return self;
}
-(void)nextKey:(__autoreleasing id<NSCopying> *)key value:(__autoreleasing id *)value {
  return nextBlock(key, value);
}
@end
