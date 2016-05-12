//
//  TPExpressionCompilerTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/16/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPExpressionCompiler.h"
#import "TPKit.h"

@interface TPExpressionCompilerTests : XCTestCase

@end

@implementation TPExpressionCompilerTests {
  TPExpressionCompiler *compiler;
}

-(void)setUp {
  [super setUp];
  compiler = TPExpressionCompiler.new;
}

-(void)tearDown {
  [super tearDown];
}


-(void)test_that_it_can_identify_integers {
  [self tokenTestingWithData:@[@"10", @"0", @"12345678"] type:TPExpressionTokenInteger];
}

-(void)test_that_it_can_identify_identifiers {
  [self tokenTestingWithData:@[@"name", @"longName", @"name::spaced",
                               @"_under::_line", @"A1234::a1234"]
                        type:TPExpressionTokenIdentifier];
}

-(void)test_that_it_can_return_a_list_of_tokens {
  NSArray *expectedTypes = @[@(TPExpressionTokenIdentifier),
                             @(TPExpressionTokenInteger),
                             @(TPExpressionTokenOperator),
                             @(TPExpressionTokenInteger),
                             @(TPExpressionTokenOperator),
                             @(TPExpressionTokenInteger),
                             @(TPExpressionTokenIdentifier),
                             @(TPExpressionTokenOperator),
                             @(TPExpressionTokenInteger),
                             @(TPExpressionTokenOperator),
                             @(TPExpressionTokenInteger),
                             ];
  NSArray *expectedValues = @[@"name",
                              @"123",
                              @"+",
                              @"5",
                              @"-",
                              @"1",
                              @"what::is",
                              @"-",
                              @"1",
                              @"+",
                              @"2"
                              ];
  NSArray <TPExpressionToken *> *tokens = [compiler tokenizeString:@"name 123 +5   -1 what::is-1 +2"];
  XCTAssertNotNil(tokens);
  XCTAssertEqual(tokens.count, expectedValues.count);
  XCTAssertEqualObjects([tokens map:^id(TPExpressionToken *element) { return @(element.type); }], expectedTypes);
  XCTAssertEqualObjects([tokens mapUsingSelector:@selector(token)], expectedValues);
}

-(void)test_that_it_can_return_integer_ast {
  XCTAssertEqualObjects([self expectExpr:@"+1235" type:TPExpressionTypeInteger], @"1235");
  XCTAssertEqualObjects([self expectExpr:@"-1235" type:TPExpressionTypeInteger], @"-1235");
}

-(void)test_that_it_can_return_identifier_ast {
  XCTAssertEqualObjects([self expectExpr:@"name::space" type:TPExpressionTypeIdentifier], @"");
}
-(void)test_that_it_can_return_op_ast {
  XCTAssertEqualObjects([self expectExpr:@"1 + 2" type:TPExpressionTypeOperator], @"3");
}
-(void)test_that_it_can_return_value_in_brackets {
  XCTAssertEqualObjects([self expectExpr:@"(-1235)" type:TPExpressionTypeInteger], @"-1235");
}
-(void)test_that_it_can_calculate_semi_complex_math_expression {
  TPExpressionAST *ast = [compiler compileExpression:@"1+5/2*(5-1)"];
  XCTAssertEqualObjects(ast.toString, @"9");
}

-(NSString *)expectExpr:(NSString *)expr type:(TPExpressionType)type {
  TPExpressionAST *ast = [compiler compileExpression:expr];
  XCTAssertNotNil(ast);
  XCTAssertEqual(ast.type, type);
  return ast.toString;
}


/*

 expr := expr OPERATOR expr | number | IDENTIFIER
 number := INTEGER | '+' INTEGER | '-' INTEGER

*/


-(void)tokenTestingWithData:(NSArray *)testData type:(TPExpressionTokenType)type {
  for (NSString *expr in testData) {
    TPExpressionToken *token = [compiler tokenFromString:expr];
    XCTAssertEqual(token.type,type);
  }
}

@end
