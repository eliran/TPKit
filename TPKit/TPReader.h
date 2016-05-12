//
//  TPReader.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/24/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPReader <NSObject, NSCopying>
@property (readonly,getter=isEndOfStream)BOOL endOfStream;
@property (readonly)NSUInteger availableBytes;
@property (readonly)NSUInteger currentOffset;
-(void)seekToOffset:(NSUInteger)offset;

-(NSUInteger)maximumReadBytesWithCount:(NSUInteger)count;
-(NSUInteger)nextBytes:(nullable void *)bytes count:(NSUInteger)length;
-(NSUInteger)skipBytes:(NSUInteger)byteCount;
-(nullable NSData *)nextDataWithLength:(NSUInteger)length;

-(uint8_t)nextByte;
-(uint16_t)next16bits;
-(uint32_t)next32bits;
-(uint64_t)next64bits;
@end

@interface TPNullReader : NSObject <TPReader>
@end
