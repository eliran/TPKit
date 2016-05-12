//
//  QArrayGenerator.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//


#import "QArrayGenerator.h"
#import "NSDictionary+LazyGenerator.h"
#import "NSArray+LazyGenerator.h"

#define ObjectType id

@implementation QArrayGenerator

-(QArrayGenerator *)mapWithIndex:(INDEX_MAP_BLOCK)mapBlock {
  __block NSUInteger index = 0;
  return [QBlockArrayGenerator withBlock:^id{
    id value = [self next];
    if ( value != nil ) {
      value = mapBlock(index++, value);
      if ( value == nil ) value = [NSNull null];
    }
    return value;
  }];
}
-(QArrayGenerator *)filterWithIndex:(INDEX_FILTER_BLOCK)filterBlock {
  __block NSUInteger index = 0;
  return [QBlockArrayGenerator withBlock:^id{
    do {
      id value = [self next];
      if ( value == nil ) return nil;
      if ( filterBlock(index++, value) ) continue;
      return value;
    } while (1);
  }];
}
-(QArrayGenerator *)filterNulls {
  NSNull *null = [NSNull null];
  return [self filterWithIndex:^BOOL(NSUInteger index, id element) {
    return element == null;
  }];
}
-(QArrayGenerator *)keepWithIndex:(INDEX_FILTER_BLOCK)keepBlock {
  __block NSUInteger index = 0;
  return [QBlockArrayGenerator withBlock:^id{
    do {
      id value = [self next];
      if ( value == nil ) return nil;
      if ( !keepBlock(index++, value) ) continue;
      return value;
    } while (1);
  }];
}
-(QArrayGenerator *)flatten {
  __block QArrayGenerator *currentGenerator = nil;
  return [QBlockArrayGenerator withBlock:^id{
    do {
      if ( currentGenerator ) {
        id value = [currentGenerator next];
        if ( value ) return value;
        currentGenerator = nil;
        continue;
      }
      id value = self.next;
      if ( [value isKindOfClass:NSArray.class] ) {
        currentGenerator = [NSArrayGenerator.alloc initWithArray:value].flatten;
        continue;
      }
      return value;
    } while (1);
  }];
}

-(id)findWithIndex:(INDEX_FIND_BLOCK)findBlock {
  NSUInteger index = 0;
  do {
    id value = [self next];
    if ( value == nil ) return nil;
    if ( findBlock(index++, value) )
      return value;
  } while (1);
}
-(QArrayGenerator *)dropNulls {
  NSNull *null = [NSNull null];
  return [QBlockArrayGenerator withBlock:^id{
    do {
      id value = [self next];
      if ( value == nil ) return nil;
      if ( value != null ) return value;
    } while (1);
  }];
}
-(QArrayGenerator *)map:(MAP_BLOCK)mapBlock {
  return [self mapWithIndex:^id(NSUInteger index, id element) {
    return mapBlock(element);
  }];
}
-(QArrayGenerator *)mapUsingSelector:(SEL)selector {
  return [self mapWithIndex:^id(NSUInteger index, id element) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [element performSelector:selector];
#pragma clang diagnostic pop
  }];
}
-(QArrayGenerator *)filter:(FILTER_BLOCK)filterBlock {
  return [self filterWithIndex:^BOOL(NSUInteger index, id element) {
    return filterBlock(element);
  }];
}
-(QArrayGenerator *)keep:(FILTER_BLOCK)keepBlock {
  return [self keepWithIndex:^BOOL(NSUInteger index, id element) {
    return keepBlock(element);
  }];
}
-(id)reduceWithInitial:(id)initial block:(REDUCE_BLOCK)reduceBlock {
  if ( initial == nil ) {
    initial = [self next];
    if ( initial == nil ) return nil;
  }
  do {
    id next = [self next];
    if ( next == nil ) return initial;
    initial = reduceBlock(initial, next);
  } while (1);
}
-(id)reduce:(REDUCE_BLOCK)reduceBlock {
  return [self reduceWithInitial:nil block:reduceBlock];
}
-(void)eachWithIndex:(INDEX_EACH_BLOCK)eachBlock {
  NSUInteger index = 0;
  do {
    id value = [self next];
    if ( value == nil ) break;
    eachBlock(index++, value);
  } while(1);
}
-(QArrayGenerator *)drop:(NSUInteger)elementsCount {
  __block NSUInteger count = elementsCount;
  return [QBlockArrayGenerator withBlock:^id{
    while ( count > 0 ) {
      [self next];
      --count;
    }
    return [self next];
  }];
}
-(QArrayGenerator *)take:(NSUInteger)elementsCount {
  __block NSUInteger count = elementsCount;
  return [QBlockArrayGenerator withBlock:^id{
    if ( count == 0 ) return nil;
    --count;
    return [self next];
  }];
}

-(QHashGenerator *)categorize:(CATEGORIZE_BLOCK)categorizeBlock {
  NSMutableDictionary *categorizedDictionary = [NSMutableDictionary new];
  do {
    id value = [self next];
    if ( value == nil ) break;
    id<NSCopying> key = categorizeBlock(value);
    if ( key ) {
      NSMutableArray *categoryArray = categorizedDictionary[key];
      if ( categoryArray == nil ) {
        categorizedDictionary[key] = categoryArray = [NSMutableArray new];
      }
      [categoryArray addObject:value];
    }
  }while(1);
  return categorizedDictionary.lazy;
}
-(NSArray *)array {
  return [[self mutableArray] copy];
}
-(NSMutableArray *)mutableArray {
  NSMutableArray *mutableArray = [NSMutableArray new];
  do {
    id nextValue = [self next];
    if ( nextValue == nil ) break;
    [mutableArray addObject:nextValue];
  } while (1);
  return mutableArray;
}

-(id)next {
  return nil;
}
@end

@implementation QBlockArrayGenerator {
  id(^nextBlock)();
}
+(instancetype)withBlock:(id (^)())block {
  return [[self alloc] initWithBlock:block];
}
-(instancetype)initWithBlock:(id (^)())block {
  if((self=[super init])){
    nextBlock = block;
  }
  return self;
}
-(id)next {
  return nextBlock();
}
@end
