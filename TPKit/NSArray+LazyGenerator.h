//
//  NSArray+LazyGenerator.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QArrayGenerator.h"


@interface NSArrayGenerator<ObjectType> : QArrayGenerator<ObjectType>
-(instancetype)initWithArray:(NSArray *)array;
@end

@interface NSArray<ObjectType> (LazyGenerator)
-(NSArrayGenerator<ObjectType>*)lazy;

-(NSArray *)map:(MAP_BLOCK)block;
-(NSArray *)filter:(FILTER_BLOCK)block;
-(NSArray *)filterNulls;
-(NSArray *)keep:(FILTER_BLOCK)block;
-(NSArray *)mapWithIndex:(INDEX_MAP_BLOCK)block;
-(NSArray *)filterWithIndex:(INDEX_FILTER_BLOCK)block;
-(NSArray *)mapUsingSelector:(SEL)selector;

-(void)eachWithIndex:(INDEX_EACH_BLOCK)block;
-(id)reduceWithInitial:(id)initial block:(REDUCE_BLOCK)reduceBlock;
-(id)reduce:(REDUCE_BLOCK)reduceBlock;
-(NSDictionary *)categorize:(CATEGORIZE_BLOCK)categorizeBlock;

@end

