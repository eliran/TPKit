//
//  QHashGenerator.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QArrayGenerator.h"

typedef struct KEYVALUE_TUPLE {
  __unsafe_unretained id<NSCopying> key;
  __unsafe_unretained id value;
} KEYVALUE_TUPLE;

#define MAP_KEYVALUE_BLOCK id(^)(KeyType key, ObjectType value)
#define TO_ARRAY_BLOCK id(^)(KeyType key, ObjectType value)
#define MAP_KEYS_KEYVALUE_BLOCK id<NSCopying>(^)(KeyType key, ObjectType value)
#define BOOL_KEYVALUE_BLOCK BOOL(^)(KeyType key, ObjectType value)
#define NEXT_KEYVALUE_BLOCK void(^)(id<NSCopying> *key, ObjectType *value)
#define OBJECT_KEYVALUE_BLOCK id(^)(KeyType key, ObjectType value)
#define EACH_KEYVALUE_BLOCK void(^)(KeyType key, ObjectType value)

//! @class QHashGenerator
@interface QHashGenerator<KeyType, ObjectType> : NSObject
//! Map the values of the dictionary. Block's return value will replace the value associated with a key
-(QHashGenerator *)map:(MAP_KEYVALUE_BLOCK)mapBlock;
//! Map the keys of the dictionary. Block's return value will create a new key/value pair with the returned key and original value
-(QHashGenerator *)mapKeys:(MAP_KEYS_KEYVALUE_BLOCK)mapBlock;
-(QHashGenerator *)filter:(BOOL_KEYVALUE_BLOCK)filterBlock;
-(QHashGenerator *)keep:(BOOL_KEYVALUE_BLOCK)keepBlock;

-(QArrayGenerator *)toArray:(TO_ARRAY_BLOCK)toArrayBlock;
-(void)each:(EACH_KEYVALUE_BLOCK)eachBlock;
-(QArrayGenerator *)keys;
-(QArrayGenerator *)values;
-(id)findObject:(BOOL_KEYVALUE_BLOCK)findBlock;
-(id)findKey:(BOOL_KEYVALUE_BLOCK)findBlock;
-(id)returnObject:(OBJECT_KEYVALUE_BLOCK)findBlock;

-(NSDictionary *)dictionary;
-(NSMutableDictionary *)mutableDictionary;

-(void)nextKey:(id<NSCopying> *)key value:(id *)value;
@end

@interface QBlockHashGenerator<KeyType, ObjectType> : QHashGenerator<KeyType, ObjectType>
+(instancetype)withKeyValueBlock:(NEXT_KEYVALUE_BLOCK)block;
-(instancetype)initWithKeyValueBlock:(NEXT_KEYVALUE_BLOCK)block;
@end


