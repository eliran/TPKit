//
//  TPXMLNodeTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPXMLElement.h"
#import "TPXMLAttribute.h"

@interface TPXMLElementTests : XCTestCase

@end

@implementation TPXMLElementTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_create_an_element_with_no_params_or_children {
  TPXMLElement *element = [TPXMLElement elementWithName:@"myName"];
  XCTAssertEqualObjects(element.tag.name, @"myName");
}
-(void)test_that_element_with_no_name_space_has_nil_nameSpace_and_same_fullName {
  TPXMLElement *element = [TPXMLElement elementWithName:@"myName"];
  XCTAssertEqualObjects(element.tag.full, @"myName");
  XCTAssertNil(element.tag.space);
}
-(void)test_that_it_can_create_an_element_with_a_name_space {
  TPXMLElement *element = [TPXMLElement elementWithName:@"x:ns:myName"];
  XCTAssertEqualObjects(element.tag.name, @"myName");
  XCTAssertEqualObjects(element.tag.space, @"x:ns");
  XCTAssertEqualObjects(element.tag.full, @"x:ns:myName");
}

-(void)test_that_it_can_have_child_elements {
  TPXMLElement *subElement0 = [TPXMLElement elementWithName:@"sub0"];
  TPXMLElement *subElement1 = [TPXMLElement elementWithName:@"sub1"];

  TPXMLElement *element = [TPXMLElement elementWithName:@"myName"
                                               children:@[subElement1, subElement0]];

  XCTAssertEqual(element.children.count, 2);
  XCTAssertEqualObjects(element.children[0].tag.name, @"sub1");
  XCTAssertEqualObjects(element.children[1].tag.name, @"sub0");
}
-(void)test_that_it_can_have_attributes {
  NSSet *attributes = [NSSet setWithArray:@[[TPXMLAttribute attributeWithName:@"ns:x" value:@"x"],
                                            [TPXMLAttribute attributeWithName:@"x" value:@"y"]
                                            ]];


  TPXMLElement *element = [TPXMLElement elementWithName:@"myName"
                                             attributes:attributes];
  XCTAssertEqual(element.attributes.count, 2);
  XCTAssertEqualObjects([element attributeWithName:@"ns:x"].value, @"x");
  XCTAssertEqualObjects([element attributeWithName:@"x"].value, @"y");
}
-(void)test_that_an_element_with_no_tag_name_and_no_children_returns_empty_string {
  XCTAssertEqualObjects(TPXMLElement.new.toString, @"");
}
-(void)test_that_an_element_with_no_tag_name_but_with_children_returns_the_childres {
  TPXMLElement *element = [TPXMLElement elementWithName:nil children:@[
                                                                       [TPXMLElement elementWithName:@"one"],
                                                                       [TPXMLElement elementWithName:@"two"],
                                                                       ]];
  XCTAssertEqualObjects(element.toString, @"<one /><two />");
}
-(void)test_that_it_can_convert_xml_element_to_string {
  NSSet *testAttributes =  [TPXMLAttribute attributesFromDictionary:@{
                                                                      @"ns:abc": @1,
                                                                      @"xyz": @"ok"
                                                                      }];


  TPXMLElement *divElement = [TPXMLElement elementWithName:@"div" attributes:testAttributes];
  TPXMLElement *blockElement = [TPXMLElement elementWithName:@"block"];
  TPXMLElement *element = [TPXMLElement.alloc initWithName:@"topElement"
                                                attributes:testAttributes
                                                  children:@[divElement, blockElement]];
  NSString *xmlString = @"<topElement ns:abc=\"1\" xyz=\"ok\"><div ns:abc=\"1\" xyz=\"ok\" /><block /></topElement>";
  XCTAssertEqualObjects([element toString], xmlString);
}
-(void)test_that_xml_attributes_are_ordered_alphanumerically {
  NSSet *testAttributes =  [TPXMLAttribute attributesFromDictionary:@{
                                                                      @"b": @2,
                                                                      @"c": @3,
                                                                      @"a": @1,
                                                                      @"d": @4,
                                                                      }];
  NSString *xmlString = [TPXMLElement elementWithName:@"test" attributes:testAttributes].toString;
  XCTAssertEqualObjects(xmlString, @"<test a=\"1\" b=\"2\" c=\"3\" d=\"4\" />");
}

-(void)test_that_it_provides_empty_children_array_when_mapping_with_no_children {
  __block NSUInteger childrenCount = -1;
  [[TPXMLElement elementWithName:@"myName"] map:^id(TPXMLElement *element, NSArray *mappedChildren) {
    if ( mappedChildren != nil )
      childrenCount = mappedChildren.count;
    return nil;
  }];
  XCTAssertEqual(childrenCount, 0);
}
-(void)test_that_it_returns_only_non_null_childrens_when_mapping {
  NSArray *children = @[[TPXMLElement elementWithName:@"show"],
                        [TPXMLElement elementWithName:@"hide"],
                        [TPXMLElement elementWithName:@"show"]];

  NSArray *res = [[TPXMLElement elementWithName:@"tag" children:children] map:^id(TPXMLElement *element, NSArray *mappedChildren) {
    if ( [element.tag.name isEqualToString:@"hide"] ) return nil;
    return @[mappedChildren];
  }];
  XCTAssertEqual(res.count, 1);
  XCTAssertEqual([res[0] count], 2);
}
@end
