//
//  TPTemplateDirectivesTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/14/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPKit.h"
#import "TPDirective.h"

// Directives
#import "TPRepeatDirective.h"
#import "TPLetDirective.h"
#import "TPUseDirective.h"

/*
attributes?        TPAttributeDirective
use                TPUseDirective
yield              TPYieldDirective

repeat(count=?)    TPCompiledRepeatDirective
for

 case, when(?:-(else|-true|-false))?
let
strings?
include

attributes:
if, if-not
 
 <let i='1' j='2' />
 
 <let id='block'>
   <!-- let can define a block if using an id -->
 </let>
 
 <use id='' />

<block id="myBlock">
  <.... ....>
  <yield attrs... />
  <.... ....>
</block>
 
 <use id="myBlock" />  <!-- replace by the content of block with id -->

 <use id="myBlock>
   <!-- content of use directive -->
 </use>

 

*/

@interface TPTemplateDirectivesTests : XCTestCase <TPDirectiveContext>

@end

@implementation TPTemplateDirectivesTests {
  NSMutableDictionary *_context;
  NSMutableDictionary *_blocks;
}

-(void)setVariable:(NSString *)variableName value:(NSString *)value {
  _context[variableName] = value;
}
-(NSString *)valueOfVariable:(NSString *)variableName {
  return _context[variableName];
}
-(void)setBlock:(TPDirective *)directive withName:(NSString *)blockName {
  _blocks[blockName] = directive;
}
-(TPDirective *)blockWithName:(NSString *)blockName {
  return _blocks[blockName];
}

-(void)setUp {
  [super setUp];
  _context = [NSMutableDictionary new];
  _blocks = [NSMutableDictionary new];
}

-(void)tearDown {
  [super tearDown];
}

#pragma mark - REPEAT Directive
-(void)test_that_repeat_directive_with_no_attributes_render_to_empty_string {
  TPDirective *repeat = [TPRepeatDirective.alloc initWithAttributes:nil
                                                            content:self.dummy_directive_body];
  XCTAssertEqualObjects(repeat.render, @"");
}
-(void)test_that_repeat_directive_with_0_count_attribute_render_to_empty_string {
  TPDirective *repeat = [TPRepeatDirective.alloc initWithAttributes:[self attributeWithCount:0]
                                                            content:self.dummy_directive_body];
  XCTAssertEqualObjects(repeat.render, @"");
}

-(void)test_that_repeat_directive_renders_the_content_1_times {
  TPDirective *repeat = [TPRepeatDirective.alloc initWithAttributes:[self attributeWithCount:1]
                                                            content:self.dummy_directive_body];
  XCTAssertEqualObjects(repeat.render,@"<a /><b /><c />");
}
-(void)test_that_repeat_directive_renders_the_content_n_times {
  TPDirective *repeat = [TPRepeatDirective.alloc initWithAttributes:[self attributeWithCount:2]
                                                            content:self.dummy_directive_body];
  XCTAssertEqualObjects(repeat.render,@"<a /><b /><c /><a /><b /><c />");
}

#pragma mark - LET Directive
-(void)test_that_let_directive_renders_to_empty_string {
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:nil content:nil];
  XCTAssertEqualObjects(let.render,@"");
}
-(void)test_that_let_directive_render_with_context_set_variables {
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:[self attributes:@{@"var": @"123",
                                                                                 @"ns:var": @"321"}]
                                                                      content:nil];
  [let renderXMLWithContext:self];
  XCTAssertEqualObjects(_context[@"var"], @"123");
  XCTAssertEqualObjects(_context[@"ns:var"], @"321");
}
-(void)test_that_let_directive_with_an_id_set_block_name_and_not_variables {
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:[self attributes:@{@"id": @"block",
                                                                                 @"ns:var": @"321"}]
                                                                      content:nil];
  [let renderXMLWithContext:self];
  XCTAssertNotNil([self blockWithName:@"block"]);
  XCTAssertNil([self valueOfVariable:@"ns:var"]);
  XCTAssertNil([self valueOfVariable:@"id"]);
}
-(void)test_that_let_directive_with_a_block_renders_the_content {
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:[self attributes:@{@"id": @"block",
                                                                                 @"ns:var": @"321"}]
                                                                      content:@[[TPDirective directiveWithName:@"in-block"]]];
  [let renderXMLWithContext:self];
  TPDirective *block = [self blockWithName:@"block"];
  XCTAssertEqualObjects([block render], @"<in-block />");
}
-(void)test_that_an_attribute_name_with_dashes_is_converted_to_camelCase_name {
  NSString *camelCaseName = @"myName";
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:[self attributes:@{@"my-name": camelCaseName}] content:nil];
  [let renderXMLWithContext:self];
  XCTAssertEqualObjects([self valueOfVariable:camelCaseName], camelCaseName);
}
-(void)test_that_an_attribute_name_space_with_dashes_is_converted_to_camelCase_name {
  NSString *camelCaseName = @"nameSpace:var";
  TPDirective *let = [TPLetDirective.alloc initWithAttributes:[self attributes:@{@"name-space:var": camelCaseName}] content:nil];
  [let renderXMLWithContext:self];
  XCTAssertEqualObjects([self valueOfVariable:camelCaseName], camelCaseName);
}

#pragma mark - USE Directive
-(void)test_that_use_directive_with_unknown_block_renders_to_an_empty_string {
  TPDirective *use = [TPUseDirective.alloc initWithAttributes:[self attributes:@{@"id": @"block"}]
                                                                        content:nil];
  XCTAssertEqualObjects([use renderWithContext:self], @"");
}
-(void)test_that_use_directive_renders_the_a_block_with_given_id {
  [self setBlock:[TPDirective directiveWithName:@"test-block"] withName:@"block"];

  TPDirective *use = [TPUseDirective.alloc initWithAttributes:[self attributes:@{@"id": @"block"}]
                                                                        content:nil];
  XCTAssertEqualObjects([use renderWithContext:self], @"<test-block />");
}


#pragma mark - Utility methods
-(TPDirectiveAttributes *)attributeWithCount:(NSUInteger)count {
  return [self attributes:@{@"count": @(count).stringValue}];
}
-(TPDirectiveAttributes *)attributes:(NSDictionary<NSString *, NSString *> *)attributes {
  return [TPDirectiveAttributes.alloc initWithAttributes:[attributes map:^id(NSString *key, NSString *value) {
    return [TPDirectiveAttribute attributeWithString:value];
  }]];
}
-(NSArray <TPDirective *>*)dummy_directive_body {
  return @[
           [TPDirective directiveWithName:@"a"],
           [TPDirective directiveWithName:@"b"],
           [TPDirective directiveWithName:@"c"],
           ];
}
@end
