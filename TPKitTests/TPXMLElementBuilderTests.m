//
//  TPXMLElementBuilderTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPXMLElementBuilder.h"
#import "TPXMLElement.h"

@interface TPXMLElementBuilderTests : XCTestCase

@end

@implementation TPXMLElementBuilderTests {
  TPXMLElementBuilder *builder;
}

-(void)setUp {
  [super setUp];
  builder = [TPXMLElementBuilder new];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_set_elementName {
  [builder setElementName:@"myName"];
  XCTAssertEqualObjects(builder.elementName, @"myName");
  [builder setElementName:@"otherName"];
  XCTAssertEqualObjects(builder.elementName, @"otherName");
}
-(void)test_that_it_can_add_attributes {
  XCTAssertEqual(builder.attributes.count, 0);
  [builder addAttribute:@"1" name:@"attr1"];
  [builder addAttributes:@{@"attr2":@"2", @"attr3": @"3", @"attr1": @"4"}];
  XCTAssertEqual(builder.attributes.count, 3);
}
-(void)test_that_it_can_add_child_elements {
  XCTAssertEqual(builder.children.count, 0);
  [builder addChild:[TPXMLElement elementWithName:@"child1"]];
  [builder addChildren:@[[TPXMLElement elementWithName:@"child2"], [TPXMLElement elementWithName:@"child3"]]];
  XCTAssertEqual(builder.children.count, 3);
  XCTAssertEqualObjects(builder.children[0].tag.name, @"child1");
  XCTAssertEqualObjects(builder.children[1].tag.name, @"child2");
  XCTAssertEqualObjects(builder.children[2].tag.name, @"child3");
}

-(void)test_that_it_creates_an_element {
  [builder addChildren:@[[TPXMLElement elementWithName:@"child1"], [TPXMLElement elementWithName:@"child2"]]];
  [builder addAttribute:@"1" name:@"attr1"];
  [builder addAttribute:@"2" name:@"attr2"];
  [builder setElementName:@"myElement"];

  TPXMLElement *element = [builder build];
  XCTAssertNotNil(element);
  XCTAssertEqual(element.children.count, 2);
  XCTAssertEqual(element.attributes.count, 2);
  XCTAssertEqualObjects(element.children[0].tag.name, @"child1");
  XCTAssertEqualObjects(element.children[1].tag.name, @"child2");
  XCTAssertEqualObjects([element attributeWithName:@"attr1"].value, @"1");
  XCTAssertEqualObjects([element attributeWithName:@"attr2"].value, @"2");
}

@end
