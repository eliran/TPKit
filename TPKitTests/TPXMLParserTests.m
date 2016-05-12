//
//  TPXMLParserTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPXMLParser.h"

@interface TPXMLParserTests : XCTestCase

@end

@implementation TPXMLParserTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_parser_xml_from_string {
  TPXMLElement *element = [TPXMLParser parseWithString:@"<myName attr1=\"1\"><sub attr2=\"2\"></sub></myName>"];
  XCTAssertNotNil(element);
  XCTAssertEqualObjects(element.tag.name, @"myName");
  XCTAssertEqual(element.attributes.count, 1);
  XCTAssertEqual(element.children.count, 1);
  XCTAssertEqualObjects([element attributeWithName:@"attr1"].value, @"1");
  XCTAssertEqualObjects(element.children[0].tag.name, @"sub");
}
-(void)test_that_it_parses_only_the_first_root_element {
  TPXMLElement *element = [TPXMLParser parseWithString:@"<one/><two/>"];
  XCTAssertNotNil(element);
  XCTAssertEqualObjects(element.tag.name, @"one");
}
@end
