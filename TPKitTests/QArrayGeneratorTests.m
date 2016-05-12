//
//  QGeneratorTest.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPKit.h"

@interface NSString (QArrayTestCategory)
-(NSNumber *)integerObject;
@end
@implementation NSString (QArrayTestCategory)

-(NSNumber *)integerObject {
  return @(self.integerValue);
}

@end

@interface QArrayGeneratorTests : XCTestCase

@end

@implementation QArrayGeneratorTests {
  NSArray *testNumbers;
  QArrayGenerator *testLazyNumbers;
}

-(void)setUp {
  [super setUp];
  testNumbers = @[@1,@2,@4,@8];
  testLazyNumbers = testNumbers.lazy;
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_a_range_generator_can_be_converted_to_an_array {
  QRange *range = [QRange integerRangeFrom:0 to:50];
  NSArray *rangeValues = range.lazy.array;
  XCTAssertNotNil(rangeValues);
  XCTAssertEqual(rangeValues.count, 51);
  XCTAssertEqualObjects(rangeValues[0], @0);
  XCTAssertEqualObjects(rangeValues[10], @10);
  XCTAssertEqualObjects(rangeValues[50], @50);
}

-(void)test_that_a_lazy_array_can_reduce {
  NSNumber *sum = [testLazyNumbers reduce:^id(id reduced, id element) {
    return @([reduced integerValue] + [element integerValue]);
  }];
  XCTAssertEqual([sum integerValue], 15);
}
-(void)test_that_a_lazy_array_can_map {
  NSArray *numbers = [testLazyNumbers map:^id(id element) {
    return @([element integerValue] * 2);
  }].array;
  XCTAssertEqual(numbers.count, 4);
  XCTAssertEqualObjects(numbers[0], @2);
  XCTAssertEqualObjects(numbers[1], @4);
  XCTAssertEqualObjects(numbers[2], @8);
  XCTAssertEqualObjects(numbers[3], @16);
}
-(void)test_that_a_lazy_array_can_filter {
  NSArray *numbers = [testLazyNumbers filter:^BOOL(id element) {
    return [element integerValue] < 3;
  }].array;
  XCTAssertEqual(numbers.count, 2);
  XCTAssertEqualObjects(numbers[0], @4);
  XCTAssertEqualObjects(numbers[1], @8);
}
-(void)test_that_a_lazy_array_can_keep_elements {
  NSArray *numbers = [testLazyNumbers keep:^BOOL(id element) {
    return [element integerValue] < 3;
  }].array;
  XCTAssertEqual(numbers.count, 2);
  XCTAssertEqualObjects(numbers[0], @1);
  XCTAssertEqualObjects(numbers[1], @2);
}
-(void)test_that_a_lazy_array_can_drop_elements {
  NSArray *numbers = [testLazyNumbers drop:3].array;
  XCTAssertEqual(numbers.count, 1);
  XCTAssertEqualObjects(numbers[0], @8);
}

-(void)test_that_a_lazy_array_can_take_elements {
  NSArray *numbers = [testLazyNumbers take:2].array;
  XCTAssertEqual(numbers.count, 2);
  XCTAssertEqualObjects(numbers[0], @1);
  XCTAssertEqualObjects(numbers[1], @2);
}

-(void)test_that_a_lazy_array_can_drop_and_take_elements {
  NSArray *numbers = [[testLazyNumbers drop:1] take:2].array;
  XCTAssertEqual(numbers.count, 2);
  XCTAssertEqualObjects(numbers[0], @2);
  XCTAssertEqualObjects(numbers[1], @4);
}

-(void)test_that_a_lazy_array_can_be_categorized {
  NSDictionary *cats = [testLazyNumbers categorize:^id<NSCopying>(id element) {
    if ( [element integerValue] < 3 ) return @"low";
    return @"high";
  }].dictionary;
  XCTAssertEqual(cats.count, 2);
  XCTAssertEqual([cats[@"low"] count], 2);
  XCTAssertEqual([cats[@"high"] count], 2);
}
-(void)test_that_a_lazy_array_can_map_with_index {
  NSArray *values = [testLazyNumbers mapWithIndex:^id(NSUInteger index, id element) {
    return @([element integerValue] + index + 1);
  }].array;
  XCTAssertEqual(values.count, 4);
  XCTAssertEqualObjects(values[0], @(1+1+0));
  XCTAssertEqualObjects(values[1], @(2+1+1));
  XCTAssertEqualObjects(values[2], @(4+1+2));
  XCTAssertEqualObjects(values[3], @(8+1+3));
}
-(void)test_that_a_lazy_array_can_filter_with_index {
  NSArray *values = [testLazyNumbers filterWithIndex:^BOOL(NSUInteger index, id element) {
    return ( index == 1 || index == 3);
  }].array;

  XCTAssertEqual(values.count, 2);
  XCTAssertEqualObjects(values[0], @1);
  XCTAssertEqualObjects(values[1], @4);
}
-(void)test_that_a_lazy_array_can_keep_with_index {
  NSArray *values = [testLazyNumbers keepWithIndex:^BOOL(NSUInteger index, id element) {
    return ( index == 1 || index == 3);
  }].array;

  XCTAssertEqual(values.count, 2);
  XCTAssertEqualObjects(values[0], @2);
  XCTAssertEqualObjects(values[1], @8);
}


-(void)test_that_a_lazy_array_can_iterate_with_index {
  NSMutableString *testString = [NSMutableString new];
  [testLazyNumbers eachWithIndex:^(NSUInteger index, id element) {
    [testString appendFormat:@"(%d)%@-",(int)index, element];
  }];
  XCTAssertEqualObjects(testString, @"(0)1-(1)2-(2)4-(3)8-");
}
-(void)test_that_a_lazy_array_can_find_a_single_object {
  id value = [testLazyNumbers findWithIndex:^BOOL(NSUInteger index, id element) {
    return [element integerValue] > 3;
  }];
  XCTAssertEqualObjects(value, @4);
}
-(void)test_that_a_lazy_array_can_drop_null_elements {
  NSArray *values = [testLazyNumbers mapWithIndex:^id(NSUInteger index, id element) {
    if ( index == 1 || index == 3 ) return nil;
    return element;
  }].dropNulls.array;

  XCTAssertEqual(values.count, 2);
  XCTAssertEqualObjects(values[0], @1);
  XCTAssertEqualObjects(values[1], @4);
}
-(void)test_that_a_lazy_array_can_map_using_selector {
  NSArray *values = [@[@"100",@"10",@"55"].lazy mapUsingSelector:@selector(integerObject)].array;
  XCTAssertEqual(values.count, 3);
  XCTAssertEqualObjects(values[0], @100);
  XCTAssertEqualObjects(values[1], @10);
  XCTAssertEqualObjects(values[2], @55);
}
-(void)test_that_a_lazy_array_can_filter_null_values {
  NSArray *values = [@[@1, [NSNull null], @"123", [NSNull null], @2].lazy filterNulls].array;
  XCTAssertEqual(values.count, 3);
  XCTAssertEqualObjects(values[0], @1);
  XCTAssertEqualObjects(values[1], @"123");
  XCTAssertEqualObjects(values[2], @2);
}
-(void)test_that_a_lazy_array_can_flatten_nasted_arrays {
  NSArray *values = @[@1,@[@2,@[@3,@4],@5],@6,@[@7,@[@8],@[],@9]].lazy.flatten.array;
  XCTAssertEqual(values.count, 9);
  for ( int i = 0; i < 9; ++i ) {
    XCTAssertEqualObjects(values[i], @(1+i));
  }
}
@end
