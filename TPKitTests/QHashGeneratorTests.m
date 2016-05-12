//
//  QHashGeneratorTests.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPKit.h"

@interface QHashGeneratorTests : XCTestCase

@end

@implementation QHashGeneratorTests {
  NSDictionary *testHash;
  QHashGenerator *testLazyHash;
}

-(void)setUp {
  [super setUp];
  testHash = @{@"one": @1,
               @"two": @2,
               @"four": @4,
               @"eight": @8};
  testLazyHash = testHash.lazy;
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_a_lazy_hash_can_be_mapped {
  NSDictionary *dict = [testLazyHash map:^id(id key, id value) {
    return @([value integerValue] * 2);
  }].dictionary;

  XCTAssertEqual(dict.count, 4);
  XCTAssertEqualObjects(dict[@"one"], @2);
  XCTAssertEqualObjects(dict[@"four"], @8);
  XCTAssertEqualObjects(dict[@"eight"], @16);
}
-(void)test_that_a_lazy_hash_can_be_filtered {
  NSDictionary *dict = [testLazyHash filter:^BOOL(id key, id value) {
    return [value integerValue] < 3;
  }].dictionary;

  XCTAssertEqual(dict.count, 2);
  XCTAssertNil(dict[@"one"]);
  XCTAssertNil(dict[@"two"]);
  XCTAssertEqualObjects(dict[@"four"], @4);
  XCTAssertEqualObjects(dict[@"eight"], @8);
}
-(void)test_that_A_lazy_hash_can_keep_elements {
  NSDictionary *dict = [testLazyHash keep:^BOOL(id key, id value) {
    return [value integerValue] < 3;
  }].dictionary;

  XCTAssertEqual(dict.count, 2);
  XCTAssertEqualObjects(dict[@"one"], @1);
  XCTAssertEqualObjects(dict[@"two"], @2);
  XCTAssertNil(dict[@"four"]);
  XCTAssertNil(dict[@"eight"]);
}
-(void)test_that_a_lazy_hash_can_map_keys {
  NSDictionary *dict = [testLazyHash mapKeys:^id<NSCopying>(id key, id value) {
    return [key stringByAppendingString:key];
  }].dictionary;

  XCTAssertEqual(dict.count, 4);
  XCTAssertEqualObjects(dict[@"oneone"], @1);
  XCTAssertEqualObjects(dict[@"twotwo"], @2);
  XCTAssertEqualObjects(dict[@"fourfour"], @4);
  XCTAssertEqualObjects(dict[@"eighteight"], @8);
}

-(void)test_that_a_lazy_hash_can_return_all_keys {
  NSArray *keys = testLazyHash.keys.array;
  XCTAssertEqual(keys.count, 4);
  XCTAssertTrue([keys containsObject:@"one"]);
  XCTAssertTrue([keys containsObject:@"eight"]);
}
-(void)test_that_a_lazy_hash_can_return_all_values {
  NSArray *values = testLazyHash.values.array;

  XCTAssertEqual(values.count, 4);
  XCTAssertTrue([values containsObject:@1]);
  XCTAssertTrue([values containsObject:@8]);
}
-(void)test_that_a_lazy_hash_can_flatten_to_array {
  NSArray *values = [testLazyHash toArray:^id(id key, id value) {
    return [NSString stringWithFormat:@"%@-%@", key, value];
  }].array;

  XCTAssertEqual(values.count, 4);
  XCTAssertTrue([values containsObject:@"one-1"]);
  XCTAssertTrue([values containsObject:@"eight-8"]);
}
-(void)test_that_a_lazy_hash_can_return_a_single_object {
  id value = [testLazyHash findObject:^BOOL(id key, id value) {
    return [key isEqualToString:@"two"];
  }];
  XCTAssertEqualObjects(value, @2);
}
-(void)test_that_a_lazy_hash_can_return_a_single_key {
  id value = [testLazyHash findKey:^BOOL(id key, id value) {
    return [value integerValue] == 2;
  }];
  XCTAssertEqualObjects(value, @"two");
}
-(void)test_that_a_lazy_hash_can_return_a_blocks_value_from_returnObject_call {
  id value = [testLazyHash returnObject:^id(id key, id value) {
    if ( [key isEqualToString:@"two"] ) return @"foundMe";
    return nil;
  }];
  XCTAssertEqualObjects(value, @"foundMe");
}
-(void)test_that_a_lazy_hash_returns_nil_if_no_block_call_returned_a_non_nil_value {
  id value = [testLazyHash returnObject:^id(id key, id value) {
    return nil;
  }];
  XCTAssertNil(value);
}
@end
