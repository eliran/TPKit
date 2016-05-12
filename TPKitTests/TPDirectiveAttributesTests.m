//
//  TPDirectiveAttributesTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/14/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPDirectiveAttributes.h"
#import "TPKit.h"
#import "TPXMLAttribute.h"

@interface TPDirectiveAttributesTests : XCTestCase

@end

@implementation TPDirectiveAttributesTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}
-(void)test_that_it_can_be_initialized_with_named_compile_attributes {
  TPDirectiveAttributes *attributes = [TPDirectiveAttributes.alloc initWithAttributes:@{@"ns:x":[TPDirectiveAttribute attributeWithString:@"123"]}];
  XCTAssertNotNil(attributes);
}
-(void)test_that_it_can_return_a_list_of_attribute_names {
  TPDirectiveAttribute *attr = [TPDirectiveAttribute attributeWithString:@"123"];
  TPDirectiveAttributes *attributes = [TPDirectiveAttributes.alloc initWithAttributes:@{@"ns:x":attr,
                                                                                      @"y":attr
                                                                                      }];
  NSArray *names = [[attributes attributeNames] sortedArrayUsingSelector:@selector(compare:)];
  XCTAssertEqual(names.count, 2);
  XCTAssertEqualObjects(names[0], @"ns:x");
  XCTAssertEqualObjects(names[1], @"y");
}
-(void)test_that_it_can_return_the_count_of_attributes {
  TPDirectiveAttribute *attr = [TPDirectiveAttribute attributeWithString:@"123"];
  TPDirectiveAttributes *attrs = [TPDirectiveAttributes.alloc initWithAttributes:@{@"x":attr,@"y":attr}];
  XCTAssertEqual(attrs.count, 2);
}
-(void)test_that_it_can_return_xml_attribute_set {
  TPDirectiveAttribute *attr = [TPDirectiveAttribute attributeWithString:@"123"];
  TPDirectiveAttributes *attributes = [TPDirectiveAttributes.alloc initWithAttributes:@{@"ns:x":attr,
                                                                                      @"y":attr
                                                                                      }];
  NSSet *xmlAttr = [attributes xmlAttributes];
  XCTAssertEqual(xmlAttr.count, 2);
  NSArray *xmlStr = [[xmlAttr.allObjects map:^id(TPXMLAttribute *element) {
    return element.toString;
  }] sortedArrayUsingSelector:@selector(compare:)];;
  XCTAssertEqualObjects(xmlStr[0], @"ns:x=\"123\"");
  XCTAssertEqualObjects(xmlStr[1], @"y=\"123\"");
}
-(void)test_that_it_can_return_the_value_of_an_attribute {
  TPDirectiveAttributes *attrs = [TPDirectiveAttributes.alloc initWithAttributes:@{@"key":[TPDirectiveAttribute attributeWithNumber:@1]}];
  XCTAssertEqualObjects([attrs attributeValueWithName:@"key"], @"1");
}

-(void)test_that_it_can_be_initialized_with_xml_attribute_set {
  NSSet *xmlAttr = [TPXMLAttribute attributesFromDictionary:@{@"ns:x": @"123", @"y": @"456"}];
  TPDirectiveAttributes *attrs = [TPDirectiveAttributes.alloc initWithXMLAttributes:xmlAttr];
  XCTAssertEqual(attrs.count, 2);
  XCTAssertEqualObjects([attrs attributeValueWithName:@"ns:x"], @"123");
  XCTAssertEqualObjects([attrs attributeValueWithName:@"y"], @"456");
}

-(void)test_that_attribute_can_evaluate_expressions_with_no_variables {
  XCTAssertEqualObjects([TPDirectiveAttribute attributeWithString:@"{{2+ 2}}"].toString, @"4");
}
-(void)test_that_attribute_can_evaluate_multiple_expressions_with_no_variables {
  XCTAssertEqualObjects([TPDirectiveAttribute attributeWithString:@"{{2+ 2}}-{{9*11}}"].toString, @"4-99");
}
-(void)test_that_attribute_can_evaluate_expression_with_variables {
  TPDirectiveContext *context = TPDirectiveContext.new;
  [context setVariable:@"number" value:@"2"];
  [context setVariable:@"other" value:@"3"];
  XCTAssertEqualObjects([[TPDirectiveAttribute attributeWithString:@"{{1 + number * other}}"] toStringWithContext:context], @"7");
}

@end
