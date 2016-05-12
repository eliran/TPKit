//
//  TPExpressionTokenTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/16/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPExpressionToken.h"

@interface TPExpressionTokenTests : XCTestCase

@end

@implementation TPExpressionTokenTests {
}

-(void)setUp {
  [super setUp];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_it_can_be_created_with_token_and_type {
  TPExpressionToken *token = [TPExpressionToken.alloc initWithToken:@"token" type:TPExpressionTokenInteger];
  XCTAssertEqualObjects(token.toString, @"token");
  XCTAssertEqual(token.type, TPExpressionTokenInteger);
}

@end
