//
//  TPDataReader.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/23/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPDataReader.h"

@implementation TPDataReader {
  NSData *dataSource;
  NSUInteger currentOffset;
}
-(instancetype)init {
  [NSException raise:@"unavailable" format:@"DataStreamer must be initialized with data source"];
  return nil;
}
-(instancetype)initWithData:(NSData *)data {
  if((self=[super init])){
    dataSource = data;
    currentOffset = 0;
  }
  return self;
}
-(void)seekToOffset:(NSUInteger)offset {
  currentOffset = MIN(offset,dataSource.length);
}
-(NSUInteger)currentOffset {
  return currentOffset;
}
-(NSUInteger)nextBytes:(void *)bytes count:(NSUInteger)count {
  NSUInteger readBytesCount = [self maximumReadBytesWithCount:count];
  if ( readBytesCount > 0 ) {
    if ( bytes ) {
      NSRange copyRange = {.location = currentOffset, .length = readBytesCount};
      [dataSource getBytes:bytes range:copyRange];
    }
    currentOffset += readBytesCount;
  }
  return readBytesCount;
}
-(NSUInteger)availableBytes {
  return dataSource.length - currentOffset;
}
-(BOOL)isEndOfStream {
  return currentOffset >= dataSource.length;
}
-(id)copyWithZone:(NSZone *)zone {
  TPDataReader *copy = [TPDataReader.alloc initWithData:dataSource];
  [copy seekToOffset:currentOffset];
  return copy;
}
@end
