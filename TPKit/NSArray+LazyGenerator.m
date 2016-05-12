//
//  NSArray+LazyGenerator.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "NSArray+LazyGenerator.h"
#import "QHashGenerator.h"

#define ObjectType id

@implementation NSArray (LazyGenerator)
-(NSArrayGenerator *)lazy {
  return [[NSArrayGenerator alloc] initWithArray:self];
}
-(NSArray *)mapWithIndex:(INDEX_MAP_BLOCK)block {
  return [self.lazy mapWithIndex:block].array;
}
-(NSArray *)map:(MAP_BLOCK)block {
  return [self.lazy map:block].array;
}
-(NSArray *)mapUsingSelector:(SEL)selector {
  return [self.lazy mapUsingSelector:selector].array;
}
-(NSArray *)filterWithIndex:(INDEX_FILTER_BLOCK)block {
  return [self.lazy filterWithIndex:block].array;
}
-(NSArray *)filterNulls {
  return [self.lazy filterNulls].array;
}
-(NSArray *)filter:(FILTER_BLOCK)block {
  return [self.lazy filter:block].array;
}
-(NSArray *)keep:(FILTER_BLOCK)block {
  return [self.lazy keep:block].array;
}
-(id)reduce:(REDUCE_BLOCK)reduceBlock {
  return [self.lazy reduce:reduceBlock];
}
-(id)reduceWithInitial:(id)initial block:(REDUCE_BLOCK)reduceBlock {
  return [self.lazy reduceWithInitial:initial block:reduceBlock];
}
-(NSDictionary *)categorize:(CATEGORIZE_BLOCK)categorizeBlock {
  return [self.lazy categorize:categorizeBlock].dictionary;
}
-(void)eachWithIndex:(INDEX_EACH_BLOCK)block {
  [self.lazy eachWithIndex:block];
}
@end

@implementation NSArrayGenerator {
  NSArray *_array;
  NSEnumerator *enumerator;
}
-(instancetype)initWithArray:(NSArray *)array {
  if((self=[super init])){
    _array = array;
  }
  return self;
}

-(id)next {
  if ( enumerator == nil ) {
    enumerator = [_array objectEnumerator];
    if ( enumerator == nil ) return nil;
  }
  id nextObject = enumerator.nextObject;
  if ( nextObject == nil ) {
    enumerator = nil;
    return nil;
  }
  return nextObject;
}

@end