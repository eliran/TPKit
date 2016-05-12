//
//  TPArrayStream.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/17/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPArrayStream<ObjectType> : NSObject
@property (readonly)NSUInteger currentIndex;
@property (readonly, getter=isEndOfStream)BOOL endOfStream;
@property (readonly)ObjectType lastReturned;

+(instancetype)streamWithArray:(NSArray<ObjectType> *)array;
-(instancetype)initWithArray:(NSArray<ObjectType> *)array;

-(ObjectType)next;
-(ObjectType)peek;

-(void)skip:(NSUInteger)skipCount;
-(void)seekOffset:(NSUInteger)offsetIndex;

@end
