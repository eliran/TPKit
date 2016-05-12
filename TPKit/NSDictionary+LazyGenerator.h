//
//  NSDictionary+LazyGenerator.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QHashGenerator.h"

@interface NSDictionaryGenerator : QHashGenerator
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface NSDictionary<KeyType, ObjectType> (LazyGenerator)
-(NSDictionaryGenerator *)lazy;

-(NSDictionary *)map:(MAP_KEYVALUE_BLOCK)mapBlock;
-(NSDictionary *)mapKeys:(MAP_KEYS_KEYVALUE_BLOCK)mapBlock;
-(NSDictionary *)filter:(BOOL_KEYVALUE_BLOCK)filterBlock;
-(NSDictionary *)keep:(BOOL_KEYVALUE_BLOCK)keepBlock;
-(NSArray *)toArray:(TO_ARRAY_BLOCK)toArrayBlock;

@end
