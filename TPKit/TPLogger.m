//
//  TPLogger.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 1/25/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPLogger.h"
#include "stdarg.h"
@implementation TPLogger
-(instancetype)init {
  return [self initWithReporter:nil];
}
-(instancetype)initWithReporter:(id<TPLoggerReporterProtocol>)reporter {
  if((self=[super init])){
    self.level = TPLoggerLevelError;
    _reporters = reporter ? @[reporter] : @[];
  }
  return self;
}
+(instancetype)defaultLogger {
  static TPLogger *defaultLogger = nil;
  if ( defaultLogger == nil ) {
    defaultLogger = [[self alloc] init];
    [defaultLogger attachReporter:[TPLoggerConsoleReporter new]];
  }
  return defaultLogger;
}
-(void)attachReporter:(id<TPLoggerReporterProtocol>)reporter {
  _reporters = [_reporters arrayByAddingObject:reporter];
}
-(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat arguments:(va_list)args {
  if ( level & _level ) {
    NSString *logMessage = [[NSString alloc] initWithFormat:messageFormat arguments:args];
    for (id<TPLoggerReporterProtocol> reporter in _reporters) {
      [reporter log:level message:logMessage];
    }
  }
}
#define LOG_BODY(level) va_list args; \
                        va_start(args, messageFormat); \
                        [self log:level message:messageFormat arguments:args]; \
                        va_end(args)

-(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat, ... {
  LOG_BODY(level);
}
-(void)error:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelError);
}
-(void)info:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelInfo);
}
-(void)warn:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelWarn);
}
-(void)debug:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelDebug);
}

+(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat arguments:(va_list)args {
  [TPLogger.defaultLogger log:level message:messageFormat arguments:args];
}
+(void)log:(TPLoggerLevel)level message:(NSString *)messageFormat, ... {
  LOG_BODY(level);
}
+(void)error:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelError);
}
+(void)info:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelInfo);
}
+(void)warn:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelWarn);
}
+(void)debug:(NSString *)messageFormat, ... {
  LOG_BODY(TPLoggerLevelDebug);
}
@end

@implementation TPLoggerConsoleReporter
-(void)log:(TPLoggerLevel)level message:(NSString *)message {
  NSLog(@"%@", message);
}
@end
