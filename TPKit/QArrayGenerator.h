//
//  QArrayGenerator.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//NSArray
// Add #each  with boolean return of NO when wanting to end

@class QHashGenerator;

#define MAP_BLOCK id(^)(ObjectType element)

#define FILTER_BLOCK BOOL(^)(ObjectType element)
#define REDUCE_BLOCK id(^)(id reduced, ObjectType element)
#define CATEGORIZE_BLOCK id<NSCopying>(^)(ObjectType element)
#define NEXT_BLOCK id(^)()

#define INDEX_MAP_BLOCK id(^)(NSUInteger index, ObjectType element)
#define INDEX_FILTER_BLOCK BOOL(^)(NSUInteger index, ObjectType element)
#define INDEX_EACH_BLOCK void(^)(NSUInteger index, ObjectType element)
#define INDEX_FIND_BLOCK BOOL(^)(NSUInteger index, ObjectType element)

@interface QArrayGenerator<__covariant ObjectType> : NSObject
-(QArrayGenerator *)map:(MAP_BLOCK)mapBlock;
-(QArrayGenerator *)mapUsingSelector:(SEL)selector;
-(QArrayGenerator *)filter:(FILTER_BLOCK)filterBlock;
-(QArrayGenerator *)keep:(FILTER_BLOCK)keepBlock;
-(id)findWithIndex:(INDEX_FIND_BLOCK)findBlock;

-(QArrayGenerator *)mapWithIndex:(INDEX_MAP_BLOCK)mapBlock;
-(QArrayGenerator *)filterWithIndex:(INDEX_FILTER_BLOCK)filterBlock;
-(QArrayGenerator *)filterNulls;
-(QArrayGenerator *)keepWithIndex:(INDEX_FILTER_BLOCK)keepBlock;
-(QArrayGenerator *)flatten;
-(QArrayGenerator *)dropNulls;

-(void)eachWithIndex:(INDEX_EACH_BLOCK)eachBlock;

-(id)reduceWithInitial:(id)initial block:(REDUCE_BLOCK)reduceBlock;
-(id)reduce:(REDUCE_BLOCK)reduceBlock;

-(QArrayGenerator *)drop:(NSUInteger)elementsCount;
-(QArrayGenerator *)take:(NSUInteger)elementsCount;

-(NSArray *)array;
-(NSMutableArray *)mutableArray;

-(QHashGenerator *)categorize:(CATEGORIZE_BLOCK)categorizeBlock;

-(id)next;
@end

@interface QBlockArrayGenerator : QArrayGenerator
+(instancetype)withBlock:(NEXT_BLOCK)block;
-(instancetype)initWithBlock:(NEXT_BLOCK)block;
@end
