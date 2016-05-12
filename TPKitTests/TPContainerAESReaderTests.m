//
//  TPContainerAESReaderTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/27/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPContainerAESReader.h"

@interface TPContainerAESReaderTests : XCTestCase

@end

@implementation TPContainerAESReaderTests {
  id<TPReader> reader;
}

#define block0Verify "\xDC\x95\xC0\x78\xA2\x40\x89\x89\xAD\x48\xA2\x14\x92\x84\x20\x87"
#define block1Verify "\x53\x0f\x8a\xfb\xc7\x45\x36\xb9\xa9\x63\xb4\xf1\xc4\xcb\x73\x8b"

-(void)setUp {
  [super setUp];
  reader = [self readerWithSource:TPNullReader.new];
}
-(TPContainerAESReader *)readerWithSource:(id<TPReader>)sourceReader {
  return [TPContainerAESReader.alloc initWithKey:[self dataWithRepeatedByte:0x00 count:32]
                                       iv:[self dataWithRepeatedByte:0x00 count:16]
                                   source:sourceReader];
}
-(void)tearDown {
  [super tearDown];
}

-(void)test_that_source_reader_is_copied_by_aesReader {
  TPDataReader *testSourceReader = [TPDataReader.alloc initWithData:[NSData dataWithBytes:"0123456789abcdef" length:16]];
  reader = [self readerWithSource:testSourceReader];
  [reader nextDataWithLength:5];
  XCTAssertEqual(testSourceReader.currentOffset, 0);
}

-(void)test_that_first_two_blocks_match_verification_vector {
  XCTAssertEqualObjects([reader nextDataWithLength:16],[NSData dataWithBytes:block0Verify length:16]);
  XCTAssertEqualObjects([reader nextDataWithLength:16],[NSData dataWithBytes:block1Verify length:16]);
}

-(void)test_that_it_returns_the_different_sequantial_blocks {
  NSData *firstBlock = [reader nextDataWithLength:16];
  NSData *secondBlock = [reader nextDataWithLength:16];
  XCTAssertNotEqualObjects(firstBlock, secondBlock);
}
-(void)test_that_it_returns_the_same_block_if_seeking_backwards {
  NSData *firstBlock = [reader nextDataWithLength:16];
  [reader seekToOffset:0];
  NSData *repeatedBlock = [reader nextDataWithLength:16];
  XCTAssertEqualObjects(firstBlock, repeatedBlock);
}


-(NSData *)dataWithRepeatedByte:(uint8_t)by count:(NSUInteger)count {
  uint8_t *buffer = malloc(count);
  memset(buffer, by, count);
  return [NSData dataWithBytesNoCopy:buffer length:count];
}
@end
