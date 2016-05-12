//
//  TPReader.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/24/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPReader.h"

@implementation TPNullReader
-(NSUInteger)currentOffset {
  return 0;
}
-(void)seekToOffset:(NSUInteger)offset {
}
-(NSUInteger)maximumReadBytesWithCount:(NSUInteger)count {
  NSUInteger maxReadCount = self.availableBytes;
  return MIN(maxReadCount, count);
}

-(NSUInteger)nextBytes:(void *)bytes count:(NSUInteger)count {
  if ( bytes ) memset(bytes, 0, count);
  return count;
}
-(NSData *)nextDataWithLength:(NSUInteger)length {
  length = [self maximumReadBytesWithCount:length];
  if ( length > 0 ) {
    void *bytes = malloc(length);
    NSUInteger readCount = [self nextBytes:bytes count:length];
    return [NSData dataWithBytesNoCopy:bytes length:readCount];
  }
  return nil;
}
-(NSUInteger)skipBytes:(NSUInteger)byteCount {
  return [self nextBytes:nil count:byteCount];
}
-(uint8_t)nextByte {
  uint8_t u8 = 0;
  [self nextBytes:&u8 count:1];
  return u8;
}
-(uint16_t)next16bits {
  uint16_t u16 = 0;
  [self nextBytes:&u16 count:2];
  return u16;
}
-(uint32_t)next32bits {
  uint32_t u32 = 0;
  [self nextBytes:&u32 count:4];
  return u32;
}
-(uint64_t)next64bits {
  uint64_t u64 = 0;
  [self nextBytes:&u64 count:8];
  return u64;
}
-(NSUInteger)availableBytes {
  return (NSUInteger)-1;
}
-(BOOL)isEndOfStream {
  return NO;
}
-(id)copyWithZone:(NSZone *)zone {
  return self;
}
@end
