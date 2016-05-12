//
//  TPRegexDictionaryTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/15/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPRegexDictionary.h"

@interface TPRegexDictionaryTests : XCTestCase
@end

@implementation TPRegexDictionaryTests {
  TPRegexDictionary *dictionary;
}

-(void)setUp {
  [super setUp];
  dictionary = TPRegexDictionary.new;
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_add_new_regex_with_values {
  [dictionary addObject:@1 forRegex:@"test"];
  [dictionary addObject:@2 forRegex:@"test2"];
  [dictionary addObject:@3 forRegex:@"test3"];
  XCTAssertEqual(dictionary.count, 3);
}

-(void)test_that_it_can_return_result_to_a_matching_regex {
  [dictionary addObject:@1 forRegex:@"test"];
  XCTAssertEqualObjects([dictionary objectForString:@"test"], @1);
  [dictionary addObject:@2 forRegex:@"will_it(_match)?"];
  XCTAssertEqualObjects([dictionary objectForString:@"will_it"], @2);
  XCTAssertEqualObjects([dictionary objectForString:@"will_it_match"], @2);
  XCTAssertNil([dictionary objectForString:@"will_it_match_me"]);
}
-(void)test_that_it_can_add_regex_with_no_end_anchoring {
  [dictionary addObject:@1 forRegex:@"test" anchored:NO];
  XCTAssertEqual([dictionary objectForString:@"test-not-anchored"], @1);
}

-(void)test_that_it_can_return_match_object_with_match_data {
  [dictionary addObject:@1 forRegex:@"(test)(?:-(extra))?" anchored:NO];
  TPRegexDictionaryMatch *match = [dictionary matchForString:@"test-extra-not-matched"];
  XCTAssertNotNil(match);
  XCTAssertEqualObjects(match.object, @1);
  XCTAssertEqualObjects(match.entireMatch, @"test-extra");
  XCTAssertEqual(match.componentsCount, 2);
  XCTAssertEqualObjects([match componentAtIndex:0], @"test");
  XCTAssertEqualObjects([match componentAtIndex:1], @"extra");
}

@end
