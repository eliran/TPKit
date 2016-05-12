//
//  TPLogger.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 1/25/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdarg.h>

typedef NS_OPTIONS(NSUInteger, TPLoggerLevel){
  TPLoggerLevelNone   = 0x00000,
  TPLoggerLevelInfo   = 1<<0,
  TPLoggerLevelWarn   = 1<<1,
  TPLoggerLevelError  = 1<<2,
  TPLoggerLevelDebug  = 1<<3,
  TPLoggerLevelAll    = (TPLoggerLevelInfo|TPLoggerLevelWarn|TPLoggerLevelError|TPLoggerLevelDebug),
};

@protocol TPLoggerReporterProtocol <NSObject>
-(void)log:(TPLoggerLevel)level message:(NSString *)message;
@end
@interface TPLogger : NSObject
@property (readwrite, nonatomic)TPLoggerLevel level;
@property (readonly)NSArray *reporters;
-(instancetype)initWithReporter:(id<TPLoggerReporterProtocol>)reporter;
-(void)attachReporter:(id<TPLoggerReporterProtocol>)reporter;
-(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat, ...;
-(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat arguments:(va_list)args;
-(void)error:(NSString *)messageFormat, ...;
-(void)info:(NSString *)messageFormat, ...;
-(void)warn:(NSString *)messageFormat, ...;
-(void)debug:(NSString *)messageFormat, ...;

+(instancetype)defaultLogger;
+(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat, ...;
+(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat arguments:(va_list)args;
+(void)error:(NSString *)messageFormat, ...;
+(void)info:(NSString *)messageFormat, ...;
+(void)warn:(NSString *)messageFormat, ...;
+(void)debug:(NSString *)messageFormat, ...;

@end

@interface TPLoggerConsoleReporter : NSObject <TPLoggerReporterProtocol>
@end