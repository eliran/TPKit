//
//  TPXMLNameTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPXMLName.h"

#define TEST_NAME_SPACE @"ns:test"

@interface TPXMLNameTests : XCTestCase

@end

@implementation TPXMLNameTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_name_without_name_space_returns_nil_name_space {
  XCTAssertNil([self withoutNameSpace].space);
}
-(void)test_that_name_without_name_space_have_matching_full_name {
  TPXMLName *name = [self withoutNameSpace];
  XCTAssertEqualObjects(name.full, name.name);
}
-(void)test_that_nameSpace_is_extracted_from_fullname {
  XCTAssertEqualObjects([self withNameSpace].space, TEST_NAME_SPACE);
}
-(void)test_that_fullname_match_withNameSpace {
  XCTAssertEqualObjects([self withNameSpace].full, [self fullNameWithNameSpace] );
}
-(void)test_that_name_is_extracted_when_using_nameSpaces {
  XCTAssertEqualObjects([self withNameSpace].name, @"name" );
}
-(void)test_that_name_can_be_used_as_a_set_key {
  TPXMLName *name1 = [TPXMLName.alloc initWithFullName:@"ns:name"];
  TPXMLName *name2 = [TPXMLName.alloc initWithFullName:@"name"];
  TPXMLName *name3 = [TPXMLName.alloc initWithFullName:@"name-2"];
  TPXMLName *name4 = [TPXMLName.alloc initWithFullName:@"name"];
  NSSet *nameSet = [NSSet setWithArray:@[name1, name2, name3, name4]];
  XCTAssertEqual(nameSet.count, 3);
  XCTAssert([nameSet containsObject:name1]);
  XCTAssert([nameSet containsObject:name3]);
  XCTAssert([nameSet containsObject:name4]);
}

#pragma mark - Utility methods
-(NSString *)fullNameWithNameSpace {
  return [NSString stringWithFormat:@"%@:name",TEST_NAME_SPACE];
}
-(TPXMLName *)withNameSpace {
  return [TPXMLName.alloc initWithFullName:[self fullNameWithNameSpace]];
}
-(TPXMLName *)withoutNameSpace {
  return [TPXMLName.alloc initWithFullName:@"name"];
}

@end
