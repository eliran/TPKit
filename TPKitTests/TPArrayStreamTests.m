//
//  TPArrayStreamTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/17/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPArrayStream.h"

@interface TPArrayStreamTests : XCTestCase

@end

@implementation TPArrayStreamTests {
  NSArray *testArray;
  TPArrayStream *testStream;
}

-(void)setUp {
  [super setUp];
  testArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
  testStream = [TPArrayStream streamWithArray:testArray];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_be_created_with_out_a_source_array {
  TPArrayStream *stream = TPArrayStream.new;
  XCTAssertNotNil(stream);
}
-(void)test_that_it_can_be_created_with_a_source_array {
  XCTAssertNotNil(testStream);
}
-(void)test_that_it_can_stream_entries_from_the_source {
  XCTAssertEqualObjects([testStream next], @1);
  XCTAssertEqualObjects([testStream next], @2);
  XCTAssertEqualObjects([testStream next], @3);
}
-(void)test_that_it_can_skip_entries {
  [testStream skip:2];
  XCTAssertEqualObjects([testStream next], @3);
}
-(void)test_that_it_returns_the_current_stream_index {
  XCTAssertEqual(testStream.currentIndex, 0);
  [testStream skip:2];
  XCTAssertEqual(testStream.currentIndex, 2);
  [testStream next];
  XCTAssertEqual(testStream.currentIndex, 3);
}
-(void)test_that_it_cannot_skip_beyond_the_end_of_the_stream {
  [testStream skip:100];
  XCTAssertEqual(testStream.currentIndex, testArray.count);
}
-(void)test_that_it_have_endOfStream_indicator {
  XCTAssertFalse([testStream isEndOfStream]);
  [testStream skip:100];
  XCTAssertTrue(testStream.endOfStream);
}
-(void)test_that_it_can_seek_to_a_different_stream_location {
  [testStream seekOffset:5];
  XCTAssertEqualObjects(testStream.next, @6);
  [testStream seekOffset:2];
  XCTAssertEqualObjects(testStream.next, @3);
}
-(void)test_that_it_cannot_seek_past_the_of_the_stream {
  [testStream seekOffset:100];
  XCTAssertEqual(testStream.currentIndex, testArray.count);
}
-(void)test_that_it_can_peek_the_head_of_the_stream {
  XCTAssertEqualObjects([testStream peek], @1);
  XCTAssertEqual(testStream.currentIndex, 0);
  XCTAssertEqualObjects([testStream peek], @1);
  [testStream skip:2];
  XCTAssertEqualObjects([testStream peek], @3);
}
-(void)test_that_it_remembers_the_the_last_returned_value {
  XCTAssertNil(testStream.lastReturned);
  [testStream next];
  XCTAssertEqualObjects(testStream.lastReturned, @1);
}
@end
