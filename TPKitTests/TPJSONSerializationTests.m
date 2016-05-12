//
//  TPJSONSerializationTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPJSONSerialization.h"

@interface TPJSONSerializationTests : XCTestCase

@end

@implementation TPJSONSerializationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)test_that_it_serializes_string {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"test" error:nil], @"\"test\"");
}
-(void)test_that_it_serializes_null {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:nil error:nil], @"null");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:[NSNull null] error:nil], @"null");
}
-(void)test_that_it_serializes_boolean {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@YES error:nil], @"true");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@NO error:nil], @"false");
}
-(void)test_that_it_serializes_integers {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@1 error:nil],@"1");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@(-1) error:nil],@"-1");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@123456789 error:nil],@"123456789");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@(-800000000) error:nil],@"-800000000");
}
-(void)test_that_it_serializes_floats {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@1.1 error:nil],@"1.1");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@(-1.1) error:nil],@"-1.1");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@12345.6789 error:nil],@"12345.6789");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@(-3.14e-15) error:nil],@"-3.14e-15");
}
-(void)test_that_it_serializes_arrays {
  NSArray *emptyArray = @[];
  NSArray *nastedArray = @[@[],@[]];
  NSArray *arrayWithNumbers = @[@1,@[@2],@3];
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:emptyArray error:nil],@"[]");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:nastedArray error:nil],@"[[],[]]");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:arrayWithNumbers error:nil],@"[1,[2],3]");
}
-(void)test_that_it_escapes_string_correctly {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\"" error:nil],@"\"\\\"\"");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\n" error:nil],@"\"\\n\"");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\b" error:nil],@"\"\\b\"");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\f" error:nil],@"\"\\f\"");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\r" error:nil],@"\"\\r\"");
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@"\t" error:nil],@"\"\\t\"");
}
-(void)test_that_it_serializes_empty_dictationy {
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:@{} error:nil], @"{}");
}
-(void)test_that_it_serializes_dictionaries_alphabetically {
  NSDictionary *testDictionary = @{@"c":@1,@"b":@2,@"a":@3};
  XCTAssertEqualObjects([TPJSONSerialization stringWithJSONObject:testDictionary error:nil],@"{\"a\":3,\"b\":2,\"c\":1}");
}
-(void)test_that_it_returns_nil_error_when_no_error {
  NSError *error = [NSError errorWithDomain:@"test" code:0 userInfo:@{}];
  [TPJSONSerialization stringWithJSONObject:@{} error:&error];
  XCTAssertNil(error);
}
-(void)test_that_it_reports_unknown_class_error {
  NSError *error;
  [TPJSONSerialization stringWithJSONObject:[NSObject new] error:&error];
  XCTAssert([[error localizedDescription] containsString:@"NSObject"]);
  XCTAssertEqualObjects([error domain],@"JSONSerialize");
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
