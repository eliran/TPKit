//
//  TPTemplateTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/13/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPTemplate.h"
#import "TPDirective.h"
#import "TPLetDirective.h"

#import "TPTemplateCompiler.h"
#import "TPXMLParser.h"

@interface TPTemplateTests : XCTestCase

@end

@implementation TPTemplateTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_be_created_with_compiled_directives {
  TPTemplate *template = [TPTemplate.alloc initWithCompiledDirectives:@[[TPDirective directiveWithName:@"test"]]];
  XCTAssertEqualObjects(template.render, @"<test />");
}

-(void)test_that_it_can_set_context_variables {
  TPTemplate *template = TPTemplate.new;
  XCTAssertNil([template valueOfVariable:@"test"]);
  [template setVariable:@"test" value:@"1"];
  XCTAssertEqualObjects([template valueOfVariable:@"test"],@"1");
}

-(void)test_that_let_directive_set_context_variable {
  TPLetDirective *let = [TPLetDirective.alloc initWithAttributes:[TPDirectiveAttributes attributes:@{@"x": @"123",
                                                                                                                    @"y": @"432"}]
                                                                         content:nil];

  TPTemplate *template = [TPTemplate.alloc initWithCompiledDirectives:@[let]];
  [template render];
  XCTAssertEqualObjects([template valueOfVariable:@"x"], @"123");
  XCTAssertEqualObjects([template valueOfVariable:@"y"], @"432");
}
-(void)test_that_it_can_set_compiled_blocks_with_id {
  TPTemplate *template = TPTemplate.new;
  XCTAssertNil([template blockWithName:@"test"]);
  [template setBlock:[TPDirective directiveWithName:@"test"] withName:@"test"];
  XCTAssertNotNil([template blockWithName:@"test"]);
  XCTAssertEqualObjects([[template blockWithName:@"test"] render], @"<test />");
}

-(void)test_that_it_doesnt_return_nil_named__sub_elements {
  TPDirective *root = [TPDirective directiveWithName:@"root"
                                             content:@[
                                                       [TPDirective directiveWithName:@"one"],
                                                       [TPDirective directiveWithName:nil
                                                                              content:@[[TPDirective directiveWithName:@"two"]]],
                                                       [TPDirective directiveWithName:@"three"]
                                                       ]];
  TPTemplate *template = [TPTemplate.alloc initWithCompiledDirectives:@[root]];
  TPXMLElement *rootElement = template.renderXML;
  NSArray <TPXMLElement *>*children = rootElement.children;
  XCTAssertEqual(children.count, 3);
  XCTAssertEqualObjects(children[0].tag.full, @"one");
  XCTAssertEqualObjects(children[1].tag.full, @"two");
  XCTAssertEqualObjects(children[2].tag.full, @"three");
}


-(void)test_full_xml {
  NSLog(@"Rendered Test XML:\r<!-- start -->\r%@\r<!-- end -->", [[self template] render]);
}

-(TPTemplate *)template {
  TPTemplateCompiler *compiler = [TPTemplateCompiler usingDefaultDirectives];
  [compiler addXMLElement:[TPXMLParser parseWithString:[self xmlTemplateString]]];
  return [compiler compile];
}
-(NSString *)xmlTemplateString {
  NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"template-test" ofType:@"xml"];
  return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

@end
