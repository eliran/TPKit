//
//  TPLoggerTests.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 1/25/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
@import TPKit;

@interface TPLoggerTests : XCTestCase <TPLoggerReporterProtocol>

@end

@implementation TPLoggerTests {
  TPLogger *logger;
  NSMutableString *_loggerOutput;
}
-(void)log:(TPLoggerLevel)level message:(NSString *)message{
  [_loggerOutput appendString:message];
}
-(void)setUp {
  [super setUp];
  _loggerOutput = [NSMutableString new];
  logger = [TPLogger new];
  [logger attachReporter:self];
}

-(void)tearDown {
  [super tearDown];
}

-(void)test_that_logger_can_change_its_report_level {
  logger.level = TPLoggerLevelDebug;
  XCTAssertEqual(logger.level, TPLoggerLevelDebug);
  logger.level = TPLoggerLevelError;
  XCTAssertEqual(logger.level, TPLoggerLevelError);
  logger.level = TPLoggerLevelWarn;
  XCTAssertEqual(logger.level, TPLoggerLevelWarn);
  logger.level = TPLoggerLevelInfo;
  XCTAssertEqual(logger.level, TPLoggerLevelInfo);
  logger.level = TPLoggerLevelNone;
  XCTAssertEqual(logger.level, TPLoggerLevelNone);
}
-(void)test_that_the_initial_logger_level_is_error {
  XCTAssertEqual(logger.level, TPLoggerLevelError);
}
-(void)test_that_logger_can_have_a_reporter_attached {
  NSString *testMessage = [NSString stringWithUTF8String:__FUNCTION__];
  [logger error:testMessage];
  XCTAssertEqualObjects(_loggerOutput, testMessage);
}
-(void)test_that_logger_can_format_string {
  [logger error:@"Error %@", @"not"];
  XCTAssertEqualObjects(_loggerOutput, @"Error not");
}
-(void)test_that_logger_filters_out_mesages_that_arent_in_the_correct_level {
  logger.level = TPLoggerLevelDebug;
  [self logAll];
  XCTAssertEqualObjects(_loggerOutput, @"Debug");
}
-(void)test_that_logger_leave_selected_levels {
  logger.level = TPLoggerLevelInfo | TPLoggerLevelWarn;
  [self logAll];
  XCTAssertEqualObjects(_loggerOutput, @"WarningInfo");
}
-(void)logAll {
  [logger warn:@"Warning"];
  [logger error:@"Error"];
  [logger info:@"Info"];
  [logger debug:@"Debug"];
}
@end
