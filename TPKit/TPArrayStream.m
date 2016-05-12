//
//  TPArrayStream.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/17/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPArrayStream.h"

@implementation TPArrayStream {
  NSArray *_source;
}
+(instancetype)streamWithArray:(NSArray *)array {
  return [self.alloc initWithArray:array];
}
-(instancetype)init {
  return [self initWithArray:nil];
}
-(instancetype)initWithArray:(NSArray *)array {
  if((self=[super init])){
    _source = array;
  }
  return self;
}

-(id)next {
  if ( _currentIndex < _source.count )
    return _lastReturned = _source[_currentIndex++];
  return nil;
}
-(id)peek {
  if ( _currentIndex < _source.count )
    return _source[_currentIndex];
  return nil;
}
-(void)skip:(NSUInteger)skipCount {
  [self seekOffset:_currentIndex + skipCount];
}
-(void)seekOffset:(NSUInteger)offsetIndex {
  _currentIndex = offsetIndex;
  if ( _currentIndex > _source.count )
    _currentIndex = _source.count;
}
-(BOOL)isEndOfStream {
  return _currentIndex >= _source.count;
}
@end
