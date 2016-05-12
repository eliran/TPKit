//
//  TPRegexDictionary.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/15/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPRegexDictionary.h"
#import "TPKit.h"

@interface TPRegularExpressionDictionaryEntry : NSObject
@property (readonly)NSRegularExpression *regex;
@property (readonly)id value;
-(instancetype)initWithRegex:(NSRegularExpression *)regex value:(id)value;
@end

@interface TPRegexDictionaryMatch ()
-(instancetype)initWithTextCheckingResult:(NSTextCheckingResult *)result inString:(NSString *)string withObject:(id)object;
@end

@implementation TPRegexDictionary {
  NSMutableArray <TPRegularExpressionDictionaryEntry *>*expressions;
}
-(instancetype)init {
  if((self=[super init])){
    _addAnchored = YES;
    expressions = [NSMutableArray new];
  }
  return self;
}
-(NSUInteger)count {
  return expressions.count;
}
-(void)addObject:(id)object forRegex:(NSString *)regexString anchored:(BOOL)anchored {
  NSRegularExpression *regex = [self regexFromRegexString:regexString anchored:anchored];
  if ( regex ) {
    [expressions addObject:[TPRegularExpressionDictionaryEntry.alloc initWithRegex:regex value:object]];
  }
}
-(void)addObject:(id)object forRegex:(NSString *)regexString {
  return[self addObject:object forRegex:regexString anchored:self.addAnchored];
}

-(NSRegularExpression *)regexFromRegexString:(NSString *)regexString anchored:(BOOL)anchored {
  if ( regexString.length > 0 ) {
    NSError *error = nil;
    regexString = anchored ? [self anchorRegexString:regexString] : [self anchorBegining:regexString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionAnchorsMatchLines
                                                                             error:&error];
    if ( regex == nil ) {
      [NSException raise:@"regex-error" format:@"directive regex error %@", error.localizedDescription];
    }
    return regex;
  }
  return nil;
}

-(NSString *)anchorRegexString:(NSString *)regex {
  regex = [self anchorBegining:regex];
  return [self anchorEnding:regex];
}
-(NSString *)anchorBegining:(NSString *)regex {
  if ( ![regex hasPrefix:@"^"] ) regex = [@"^" stringByAppendingString:regex];
  return regex;
}
-(NSString *)anchorEnding:(NSString *)regex {
  if ( ![regex hasSuffix:@"$"] ) regex = [regex stringByAppendingString:@"$"];
  return regex;
}


-(id)objectForString:(NSString *)string {
  return [self matchForString:string].object;
}
-(TPRegexDictionaryMatch *)matchForString:(NSString *)string {
  if ( string.length > 0 ) {
    for (TPRegularExpressionDictionaryEntry *entry in expressions) {
      NSTextCheckingResult *regexMatch = [entry.regex firstMatchInString:string options:0 range:string.range];
      if ( regexMatch ) {
        return [TPRegexDictionaryMatch.alloc initWithTextCheckingResult:regexMatch inString:string withObject:entry.value];
      }
    }
  }
  return nil;
}
@end

@implementation TPRegexDictionaryMatch {
  NSArray <NSValue *> *ranges;
}
-(instancetype)initWithTextCheckingResult:(NSTextCheckingResult *)result inString:(NSString *)string withObject:(id)object {
  if((self=[super init])){
    ranges = [self processResultRanges:result];
    _entireMatch = ranges.count > 0 ? [string substringWithRange:[ranges[0] rangeValue]] : nil;
    _object = object;
  }
  return self;
}
-(NSArray *)processResultRanges:(NSTextCheckingResult *)result {
  NSUInteger numberOfRanges = result.numberOfRanges;
  NSMutableArray *rangesArray = [NSMutableArray new];
  if ( numberOfRanges > 0 ) {
    for ( NSUInteger i = 0; i < numberOfRanges; ++i ){
      NSRange matchRange = [result rangeAtIndex:i];
      if ( matchRange.length > 0 )
        [rangesArray addObject:[NSValue valueWithRange:matchRange]];
    }
  }
  return rangesArray.copy;
}
-(NSUInteger)componentsCount {
  NSUInteger rangesCount = ranges.count;
  if ( rangesCount > 0 )
    return rangesCount - 1;
  return 0;
}
-(NSString *)componentAtIndex:(NSUInteger)index {
  if ( ++index < ranges.count )
    return [_entireMatch substringWithRange:[ranges[index] rangeValue]];
  return nil;
}
@end

@implementation TPRegularExpressionDictionaryEntry
-(instancetype)initWithRegex:(NSRegularExpression *)regex value:(id)value {
  if((self=[super init])){
    _regex = regex;
    _value = value;
  }
  return self;
}
@end

