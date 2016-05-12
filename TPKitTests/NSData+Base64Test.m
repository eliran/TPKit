//
//  UtilKitNSData+Base64Test.m
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TPKit.h"

@interface UtilKitNSData_Base64Test : XCTestCase

@end

@implementation UtilKitNSData_Base64Test


static NSString *base64_abcdefg = @"YWJjZGVmZw==";

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)test_that_base64_encoded_string_can_be_converted_to_data {
}
@end
