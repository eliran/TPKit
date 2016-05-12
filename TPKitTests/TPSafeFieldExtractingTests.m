//
//  TPSafeFieldExtractingDictionaryTests.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/16/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+TPSafeFieldExtracting.h"

@interface TPSafeFieldExtractingTests : XCTestCase

@end

@implementation TPSafeFieldExtractingTests {
  NSDictionary *testDictionary;
}

- (void)setUp {
  [super setUp];
  testDictionary = @{@"one": @1,
                     @"two": @"2",
                     @"three": @"3.5",
                     @"four": @[@1,@"2",@"3.5",@"Test"],
                     @"five": @"Testing",
                     @5: @"Again",
                     @"nest": @[ @{@"a":@{@"b":@1}} ],
                     @"dict": @{ @1: @1 }
                     };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)test_that_can_extract_integers {
  XCTAssertEqual([testDictionary integerField:@"one"], 1);
  XCTAssertEqual([testDictionary integerField:@"two"], 2);
  XCTAssertEqual([testDictionary integerField:@"three"], 3);
  XCTAssertEqual([testDictionary integerField:@"four"], 0);
  XCTAssertEqual([testDictionary integerField:@"five" withDefault:123], 123);
}
-(void)test_that_can_extract_doubles {
  XCTAssertEqualWithAccuracy([testDictionary realField:@"one"], 1.0, 0.1);
  XCTAssertEqualWithAccuracy([testDictionary realField:@"three"], 3.5, 0.1);
  XCTAssertEqualWithAccuracy([testDictionary realField:@"five"], 0.0, 0.1);
  XCTAssertEqualWithAccuracy([testDictionary realField:@5 withDefault:123.45], 123.45, 0.1);
}
-(void)test_that_can_extract_array {
  NSArray *array = [testDictionary arrayField:@"four"];
  XCTAssertEqual(array.count, 4);
  XCTAssertEqual([[testDictionary arrayField:@"nest"] count], 1);
  XCTAssertNil([testDictionary arrayField:@"one"]);
}
-(void)test_that_can_extract_strings {
  XCTAssertEqualObjects([testDictionary stringField:@"two"], @"2");
  XCTAssertEqualObjects([testDictionary stringField:@"three"], @"3.5");
  XCTAssertEqualObjects([testDictionary stringField:@5], @"Again");
  XCTAssertNil([testDictionary stringField:@"nest"]);
}
-(void)test_that_can_extract_dictionary {
  XCTAssertNil([testDictionary dictionaryField:@"one"]);
  XCTAssertTrue([[testDictionary dictionaryField:@"dict"] isKindOfClass:NSDictionary.class]);
}
-(void)test_that_field_returns_default_for_nil_name {
  XCTAssertEqualObjects([testDictionary field:nil withDefault:@1], @1);
}
-(void)test_that_field_returns_default_for_non_existing_name {
  XCTAssertEqualObjects([testDictionary field:@"abcd" withDefault:@1], @1);
}
-(void)test_that_field_returns_value_of_an_existing_field {
  XCTAssertEqualObjects([testDictionary field:@"two" withDefault:@1], @"2");
  XCTAssertEqualObjects([testDictionary field:@"one" withDefault:@2], @1);
}
@end
