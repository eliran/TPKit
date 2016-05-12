//
//  TPCompiledDirectiveTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/14/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPDirective.h"
#import "TPXMLElement.h"

@interface TPDirectiveTests : XCTestCase

@end

@implementation TPDirectiveTests

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_be_created_with_just_directive_name {
  TPDirective *directive = [TPDirective directiveWithName:@"div"];
  XCTAssertNotNil(directive);
}
-(void)test_that_it_returns_an_array_of_xml_elements_when_rendering {
  TPDirective *directive = [TPDirective directiveWithName:@"div"];
  XCTAssertEqual([directive renderXML].count, 1);
}
-(void)test_that_it_can_render_to_string {
  TPDirective *directive = [TPDirective directiveWithName:@"div"];
  XCTAssertEqualObjects([directive render], @"<div />");
}
-(void)test_that_it_can_be_created_with_empty_contentDirectives {
  TPDirective *directive = [TPDirective directiveWithName:@"top"
                                                        content:@[]];
  XCTAssertEqualObjects([directive render], @"<top />");
}
-(void)test_that_it_can_be_created_with_non_empty_contentDirectives {
  TPDirective *directive = [TPDirective directiveWithName:@"top"
                                                        content:@[[TPDirective directiveWithName:@"content"]]];
  XCTAssertEqualObjects([directive render], @"<top><content /></top>");
}
-(void)test_that_it_can_render_only_the_content {
  TPDirective *directive = [TPDirective directiveWithName:@"top"
                                                                  content:@[[TPDirective directiveWithName:@"content"]]];
  NSArray *content = [directive renderContentXML];
  XCTAssertEqual(content.count, 1);
  XCTAssertEqualObjects([content[0] toString], @"<content />");
}
-(void)test_that_it_can_be_created_with_compiled_attributes {
  TPDirective *directive = [TPDirective directiveWithName:@"top"
                                                               attributes:TPDirectiveAttributes.new
                                                                  content:nil];
  XCTAssertNotNil(directive);
}
-(void)test_that_it_can_render_directive_with_attributes {
  TPDirectiveAttributes *attributes = [TPDirectiveAttributes.alloc initWithAttributes:@{@"ns:x":[TPDirectiveAttribute attributeWithString:@"123"],
                                                                                      @"y":[TPDirectiveAttribute attributeWithString:@"456"]}];
  TPDirective *directive = [TPDirective directiveWithName:@"top"
                                                               attributes:attributes
                                                                  content:nil];
  XCTAssertEqualObjects([directive render], @"<top ns:x=\"123\" y=\"456\" />");
}
@end
