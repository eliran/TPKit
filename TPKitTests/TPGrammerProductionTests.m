//
//  TPParserProductionTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/17/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPGrammerProduction.h"
#import "TPKit.h"

@interface TPGrammerProductionTests : XCTestCase
@end

@implementation TPGrammerProductionTests {
  NSArray *testDerivation;
  BOOL blockInvoked;
  BOOL blockDefaultReturn;
  id blockReturn;
  TPGrammerProductionResult *blockResult;
  TPGrammerProduction *production;
}

-(void)setUp {
  [super setUp];
  blockDefaultReturn = YES;
  production = [TPGrammerProduction.alloc initWithDeriveBlock:^id(TPGrammerProductionResult *result) {
    blockInvoked = YES;
    blockResult = result;
    if ( blockDefaultReturn ) return result;
    return blockReturn;
  }];
  production.derives = testDerivation = @[@"a", @"b"];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_non_terminal_can_be_initialized_with_a_completion_block {

}
-(void)test_that_production_can_set_the_derived_array {
  XCTAssertEqualObjects(production.derives, testDerivation);
}
-(void)test_that_number_implements_grammerSymbol_protocol {
  XCTAssertTrue([NSNumber conformsToProtocol:@protocol(TPGrammerProductionSymbol)]);
}
-(void)test_that_string_implements_grammerSymbol_protocol {
  XCTAssertTrue([NSString conformsToProtocol:@protocol(TPGrammerProductionSymbol)]);
}
-(void)test_that_grammerProduction_implements_grammerSymbol_protocol {
  XCTAssertTrue([TPGrammerProduction conformsToProtocol:@protocol(TPGrammerProductionSymbol)]);
}
-(void)test_that_it_returns_productionResult_when_derivation_succeeds_and_no_block_supplied {
  production = TPGrammerProduction.new;
  TPGrammerProductionResult *result = [production deriveFromTokenStream:[self aTestStream]];
  XCTAssertNotNil(result);
  XCTAssertTrue([result isKindOfClass:TPGrammerProductionResult.class]);
}
-(void)test_that_grammerSymbol_number_derives_token_value_when_type_match {
  XCTAssertEqualObjects([@(TPExpressionTokenUnknown) deriveFromTokenStream:[self tokenWithValue:@"123"]], @"123");
}
-(void)test_that_grammerSymbol_number_derives_nil_when_type_mismatch {
  XCTAssertNil([@(TPExpressionTokenIdentifier) deriveFromTokenStream:[self tokenWithValue:@"123"]]);
}

-(void)test_that_grammerSymbol_string_derives_token_value_when_token_match {
  XCTAssertEqualObjects([@"123" deriveFromTokenStream:[self tokenWithValue:@"123"]], @"123");
}
-(void)test_that_grammerSymbol_string_derives_token_value_when_token_mismatch {
  XCTAssertNil([@"123" deriveFromTokenStream:[self tokenWithValue:@"321"]]);
}

-(void)test_that_it_returns_nil_when_derivation_fails {
  XCTAssertNil([production deriveFromTokenStream:[self tokenFromArray:@[@"c"]]]);
}


-(void)test_that_token_stream_advances_when_derivation_succeeds {
  TPArrayStream *stream = [self aTestStream];
  [production deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 2);
}
-(void)test_that_token_stream_reverts_to_start_when_derivation_fails {
  TPArrayStream *stream = [self tokenFromArray:@[testDerivation[0]]];
  [production deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 0);
}
-(void)test_that_grammerSymbol_number_advances_stream_when_match {
  TPArrayStream *stream = [self tokenWithType:TPExpressionTokenIdentifier];
  [@(TPExpressionTokenIdentifier) deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 1);
}
-(void)test_that_grammerSymbol_number_doesnt_advance_when_mismatch {
  TPArrayStream *stream = [self tokenWithType:TPExpressionTokenUnknown];
  [@(TPExpressionTokenIdentifier) deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 0);
}
-(void)test_that_grammerSymbol_string_advances_stream_when_match {
  TPArrayStream *stream = [self tokenWithValue:@"123"];
  [@"123" deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 1);
}
-(void)test_that_grammerSymbol_string_doesnt_adance_when_mismatch {
  TPArrayStream *stream = [self tokenWithValue:@"321"];
  [@"123" deriveFromTokenStream:stream];
  XCTAssertEqual(stream.currentIndex, 0);
}

-(void)test_that_productionResult_have_a_array_with_individual_derived_results_for_each_symbol {
  TPGrammerProductionResult *result = [production deriveFromTokenStream:[self tokenFromArray:testDerivation]];
  XCTAssertEqualObjects(result.derived[0], @"a");
  XCTAssertEqualObjects(result.derived[1], @"b");
}

-(void)test_that_it_has_epsilon_symbol_that_match_any_input {
  TPGrammerProduction *epsilon = [TPGrammerProduction epsilon];
  XCTAssertNotNil([epsilon deriveFromTokenStream:[TPArrayStream streamWithArray:@[]]]);
  XCTAssertNotNil([epsilon deriveFromTokenStream:[self tokenFromArray:testDerivation]]);
}

-(void)test_that_a_derive_block_is_invoked_when_match {
  [production deriveFromTokenStream:[self aTestStream]];
  XCTAssertTrue(blockInvoked);
}
-(void)test_that_a_derive_block_receives_the_result {
  [production deriveFromTokenStream:[self aTestStream]];
  XCTAssertEqual(blockResult.derived.count, 2);
  XCTAssertEqual(blockResult.derived[0], @"a");
  XCTAssertEqual(blockResult.derived[1], @"b");
}
-(void)test_that_a_derive_block_return_value_returns_as_the_derive_result {
  blockDefaultReturn = NO;
  blockReturn = @"return-value";
  XCTAssertEqualObjects([production deriveFromTokenStream:[self aTestStream]], blockReturn);
}
-(void)test_that_a_derive_block_is_not_invoked_when_mismatch {
  [production deriveFromTokenStream:[TPArrayStream streamWithArray:@[]]];
  XCTAssertFalse(blockInvoked);
}
-(void)test_that_a_production_list_can_be_created_with_alternative_derivations {
  XCTAssertNotNil([self productionListWithDefaultData]);
}
-(void)test_that_a_production_list_returns_nil_if_no_match {
  TPArrayStream *tokens = [self tokenFromArray:@[@"1",@"4"]];
  XCTAssertNil([[self productionListWithDefaultData] deriveFromTokenStream:tokens]);
}
-(void)test_that_a_production_list_returns_the_result_of_the_matching_production {
  TPGrammerProductionList *list = [self productionListWithDefaultData];
  TPArrayStream *firstTokens = [self tokenFromArray:@[@"1", @"2"]];
  TPArrayStream *secondTokens = [self tokenFromArray:@[@"1", @"3"]];
  XCTAssertEqualObjects([[list deriveFromTokenStream:firstTokens] derived][0], @1);
  XCTAssertEqualObjects([[list deriveFromTokenStream:secondTokens] derived][0], @2);
}
-(void)test_that_a_production_list_propogates_the_original_result_object_if_it_returns_from_a_production {
  TPGrammerProductionList *list = [TPGrammerProductionList productionDerives:@[production] block:nil];
  TPGrammerProductionResult *result = [list deriveFromTokenStream:[self aTestStream]];
  XCTAssertEqual(result.derived.count, 2);
}
-(void)test_that_a_production_list_invokes_a_block_when_a_production_matches {
  TPGrammerProductionList *list = [TPGrammerProductionList productionDerives:@[production] block:^id(TPGrammerProductionResult *result) {
    return @1;
  }];
  XCTAssertEqualObjects([list deriveFromTokenStream:[self aTestStream]], @1);
}


-(TPGrammerProductionList *)productionListWithDefaultData {
  TPGrammerProductionList *list = TPGrammerProductionList.new;
  list.derives = @[
                   [TPGrammerProduction productionDerives:@[@"1",@"2"] block:^id(TPGrammerProductionResult *result) {
                     return @1;
                   }],
                   [TPGrammerProduction productionDerives:@[@"1",@"3"] block:^id(TPGrammerProductionResult *result) {
                     return @2;
                   }]
                   ];
  return list;
}

-(TPArrayStream<TPExpressionToken *>*)tokenWithValue:(NSString *)value {
  return [self tokenWithValue:value type:TPExpressionTokenUnknown];
}
-(TPArrayStream<TPExpressionToken *>*)tokenWithType:(TPExpressionTokenType)type {
  return [self tokenWithValue:nil type:type];
}
-(TPArrayStream<TPExpressionToken *>*)tokenWithValue:(NSString *)value type:(TPExpressionTokenType)type {
  return [TPArrayStream streamWithArray:@[[TPExpressionToken.alloc initWithToken:value type:type]]];
}
-(TPArrayStream *)aTestStream {
  return [self tokenFromArray:testDerivation];
}
-(TPArrayStream<TPExpressionToken *>*)tokenFromArray:(NSArray <NSString *>*)array {
  return [TPArrayStream streamWithArray:[array map:^id(NSString *element) {
    return [TPExpressionToken.alloc initWithToken:element type:TPExpressionTokenIdentifier];
  }]];
}
@end
