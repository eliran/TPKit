//
//  TPExpressionASTTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/16/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPExpressionAST.h"
#import "TPDirective.h"

@interface TPExpressionASTTests : XCTestCase <TPDirectiveContext>
@end

@implementation TPExpressionASTTests
-(NSString *)valueOfVariable:(NSString *)variableName {
  if ( [variableName isEqualToString:@"var"] ) return @"123";
  return nil;
}
-(void)setVariable:(NSString *)variableName value:(NSString *)value {
}
-(void)setBlock:(TPDirective *)directive withName:(NSString *)blockName {
}
-(TPDirective *)blockWithName:(NSString *)blockName {
  return nil;
}

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

#pragma mark - Integer AST
-(void)test_that_it_can_create_integer_ast {
  XCTAssertEqual([TPExpressionAST nodeWithInteger:@"123"].type, TPExpressionTypeInteger);
}
-(void)test_that_it_can_return_integer_string {
  XCTAssertEqualObjects([TPExpressionAST nodeWithInteger:@"123"].toString, @"123");
}

#pragma mark - Identifier AST
-(void)test_that_it_returns_empty_string_for_identifier_with_no_context {
  XCTAssertEqualObjects([TPExpressionAST nodeWithIdentifier:@"identifier"].toString, @"");
}
-(void)test_that_it_returns_the_value_of_a_variable_matching_identifer_when_providing_context {
  XCTAssertEqualObjects([[TPExpressionAST nodeWithIdentifier:@"var"] toStringWithContext:self], @"123");
}
-(void)test_that_it_returns_empty_string_when_a_variable_not_matching_identifer_when_providing_context {
  XCTAssertEqualObjects([[TPExpressionAST nodeWithIdentifier:@"nonVar"] toStringWithContext:self], @"");
}

@end
