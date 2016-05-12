//
//  TPDataReaderTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/22/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPDataReader.h"

@interface TPDataReaderTests : XCTestCase

@end

@implementation TPDataReaderTests {
  TPDataReader *reader;
  NSData *testData;
}

-(void)setUp {
  [super setUp];
  testData = [@"0123456789abcdef" dataUsingEncoding:NSUTF8StringEncoding];
  reader = [TPDataReader.alloc initWithData:testData];
}

-(void)test_that_it_can_read_byte_by_byte {
  XCTAssertEqual([reader nextByte], '0');
  XCTAssertEqual([reader nextByte], '1');
  XCTAssertEqual([reader nextByte], '2');
}
-(void)test_that_it_can_seek_to_different_position {
  [reader seekToOffset:5];
  XCTAssertEqual([reader nextByte], '5');
}
-(void)test_that_it_can_return_current_offset {
  XCTAssertEqual(reader.currentOffset, 0);
  [reader seekToOffset:5];
  XCTAssertEqual(reader.currentOffset, 5);
  [reader nextByte];
  XCTAssertEqual(reader.currentOffset, 6);
}
-(void)test_that_it_detects_end_of_stream {
  XCTAssertFalse(reader.endOfStream);
  [reader seekToOffset:testData.length];
  XCTAssertTrue(reader.endOfStream);
}
-(void)test_that_it_can_return_nsdata {
  [reader skipBytes:1];
  NSData *data = [reader nextDataWithLength:5];
  NSData *expected = [testData subdataWithRange:(NSRange){.location=1, .length=5}];
  XCTAssertEqualObjects(data, expected);
}

-(void)test_that_it_calculates_remaining_bytes_to_the_end_correctly {
  [reader skipBytes:13];
  XCTAssertEqual([reader maximumReadBytesWithCount:5], 3);
}
-(void)test_that_it_can_skip_bytes {
  [reader skipBytes:1];
  [reader skipBytes:3];
  XCTAssertEqual([reader nextByte], '4');
}
-(void)test_that_reader_conforms_to_nscopying {
  XCTAssert([reader conformsToProtocol:@protocol(NSCopying)]);
}
-(void)test_that_reader_can_be_copied {
  XCTAssertNotNil([reader copy]);
}
-(void)test_that_reader_copy_offset_change_doesnt_affect_the_original {
  TPDataReader *copied = [reader copy];
  [copied seekToOffset:10];
  XCTAssertEqual(reader.currentOffset, 0);
}
-(void)test_that_reader_copy_copies_offset {
  [reader seekToOffset:10];
  TPDataReader *copied = [reader copy];
  XCTAssertEqual(copied.currentOffset, 10);
}
-(void)test_that_reader_copy_accesses_the_same_data {
  XCTAssertEqualObjects([reader.copy nextDataWithLength:testData.length], [reader nextDataWithLength:testData.length]);
}

@end
