//
//  TPXMLAttributeTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPXMLAttribute.h"
#import "TPKit.h"
@interface TPXMLAttributeTests : XCTestCase

@end

@implementation TPXMLAttributeTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_attribute_creates_with_name_and_value {
  TPXMLAttribute *attr = [TPXMLAttribute attributeWithName:@"attr1" value:@"value"];
  XCTAssertEqualObjects(attr.name.name, @"attr1");
  XCTAssertEqualObjects(attr.value, @"value");
}
-(void)test_that_attribute_can_split_nameSpace {
  TPXMLAttribute *attr = [TPXMLAttribute attributeWithName:@"ns:x:attr1" value:@"value"];
  XCTAssertEqualObjects(attr.name.space, @"ns:x");
  XCTAssertEqualObjects(attr.name.name, @"attr1");
  XCTAssertEqualObjects(attr.name.full, @"ns:x:attr1");
}
-(void)test_that_attribute_can_be_used_as_a_set_key {
  TPXMLAttribute *attr1 = [TPXMLAttribute attributeWithName:@"ns:attr1" value:@"value"];
  TPXMLAttribute *attr2 = [TPXMLAttribute attributeWithName:@"attr1" value:@"value"];
  TPXMLAttribute *attr3 = [TPXMLAttribute attributeWithName:@"attr2" value:@"value"];
  TPXMLAttribute *attr4 = [TPXMLAttribute attributeWithName:@"attr1" value:@"otherValue"];
  NSSet *attrSet = [NSSet setWithArray:@[attr1, attr2, attr3, attr4]];
  XCTAssertEqual(attrSet.count, 3);
  XCTAssert([attrSet containsObject:attr1]);
  XCTAssert([attrSet containsObject:attr3]);
  XCTAssert([attrSet containsObject:attr4]);
}
-(void)test_that_it_can_be_compared {
  NSArray *unsortedAttributes = @[
                                  [TPXMLAttribute attributeWithName:@"bcd" value:@""],
                                  [TPXMLAttribute attributeWithName:@"ABC" value:@""],
                                  [TPXMLAttribute attributeWithName:@"abc" value:@""],
                                  ];
  NSArray *sortNames = [[unsortedAttributes sortedArrayUsingSelector:@selector(compare:)] map:^id(TPXMLAttribute *attribute) {
    return attribute.name.full;
  }];
  NSArray *expectedOrder = @[@"ABC", @"abc", @"bcd"];
  XCTAssertEqualObjects(sortNames, expectedOrder);
}
-(void)test_that_it_can_create_a_set_of_attributes_from_a_dictionary {
  NSSet *attributes = [TPXMLAttribute attributesFromDictionary:@{@"abc":@2,
                                                                 @"y":@"123"
                                                                 }];
  XCTAssertEqual(attributes.count, 2);
  NSArray <TPXMLAttribute *>*attr = [attributes.allObjects sortedArrayUsingSelector:@selector(compare:)];
  XCTAssertEqualObjects(attr[0].name.full, @"abc");
  XCTAssertEqualObjects(attr[0].value, @"2");

  XCTAssertEqualObjects(attr[1].name.full, @"y");
  XCTAssertEqualObjects(attr[1].value, @"123");
}
-(void)test_that_it_can_be_converted_to_string {
  TPXMLAttribute *attr = [TPXMLAttribute attributeWithName:@"ns:abc" value:@"12345"];
  XCTAssertEqualObjects(attr.toString, @"ns:abc=\"12345\"");
}
@end
