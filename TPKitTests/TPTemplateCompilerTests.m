//
//  TPTemplateCompilerTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/13/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPTemplateCompiler.h"
#import "TPXMLElement.h"
#import "TPXMLParser.h"
#import "TPTemplate.h"
#import "TPRepeatDirective.h"
#import "TPLetDirective.h"

@interface TPTemplateCompilerTests : XCTestCase

@end

@implementation TPTemplateCompilerTests {
  TPTemplateCompiler *compiler;
}

-(void)setUp {
  [super setUp];
  compiler = TPTemplateCompiler.new;
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_returns_a_compiled_template {
  XCTAssertNotNil([compiler compile]);
}
-(void)test_that_it_returns_a_empty_template_when_no_elements_added {
  TPXMLElement *renderedTemplate = [[compiler compile] renderXML];
  XCTAssertNotNil(renderedTemplate);
  XCTAssertEqualObjects(renderedTemplate.toString, @"");
}
-(void)test_that_it_returns_an_element_if_it_isnt_a_known_directive {
  [compiler addXMLElement:[TPXMLElement elementWithName:@"test"]];
  XCTAssertEqualObjects(self.renderedString, @"<test />");
}

-(void)test_that_it_returns_nasted_elements {
  [compiler addXMLElement:[TPXMLElement elementWithName:@"test"
                                               children:@[[TPXMLElement elementWithName:@"elem"]]]];
  XCTAssertEqualObjects(self.renderedString, @"<test><elem /></test>");
}

-(void)test_that_it_throws_if_trying_to_register_a_non_compiled_directive_subclass {
  XCTAssertThrows([compiler registerDirective:@"test" class:NSObject.class]);
}
-(void)test_that_it_can_register_directive_class_with_regex_from_the_directive {
  [compiler registerDirectiveClass:TPRepeatDirective.class];
  XCTAssertTrue([compiler hasRegisteredDirective:@"repeat"]);
}
-(void)test_that_it_can_render_a_register_directive {
  [compiler registerDirective:@"test" class:TPRepeatDirective.class];
  [compiler addXMLElement:[TPXMLElement.alloc initWithName:@"test"
                                                attributes:[TPXMLAttribute attributesFromDictionary:@{@"count": @"2"}]
                                                  children:@[[TPXMLElement elementWithName:@"body"]]]];
  XCTAssertEqualObjects(self.renderedString, @"<body /><body />");
}


-(TPXMLElement *)xmlFromString:(NSString *)xmlString {
  return [TPXMLParser parseWithString:xmlString];
}

-(NSString *)renderedString {
  return compiler.compile.render;
}

@end
