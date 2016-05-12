//
//  QRange.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QRange.h"

@implementation QRange {
  NSInteger _from;
  NSInteger _to;
  NSInteger _step;
}
+(instancetype)naturalNumbers {
  return [[self alloc] initWithIntegerRangeFrom:1 to:NSIntegerMax];
}
+(instancetype)naturalsWithZero {
  return [[self alloc] initWithIntegerRangeFrom:0 to:NSIntegerMax];
}

+(instancetype)integerRangeFrom:(NSInteger)from to:(NSInteger)to {
  return [[self alloc] initWithIntegerRangeFrom:from to:to];
}
-(instancetype)initWithIntegerRangeFrom:(NSInteger)from to:(NSInteger)to {
  if((self=[super init])){
    _from = from;
    _to = to;
    _step = from < to ? 1 : -1;
  }
  return self;
}
-(QArrayGenerator *)lazy {
  __block NSInteger current = _from;
  __block NSInteger count = 1 + ((_to - _from) / _step);
  return [QBlockArrayGenerator withBlock:^id{
    if ( count == 0 ) return nil;
    NSInteger next = current;
    current += _step;
    count -= 1;
    return @(next);
  }];
}
@end

