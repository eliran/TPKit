//
//  TPRegexDictionary.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/15/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPRegexDictionaryMatch<ObjectType> : NSObject
@property (readonly)ObjectType object;
@property (readonly)NSString *entireMatch;
@property (readonly)NSUInteger componentsCount;
-(NSString *)componentAtIndex:(NSUInteger)index;
@end

@interface TPRegexDictionary<ObjectType> : NSObject
@property (readonly)NSUInteger count;
@property (readwrite)BOOL addAnchored;
-(void)addObject:(ObjectType)object forRegex:(NSString *)regex;
-(void)addObject:(ObjectType)object forRegex:(NSString *)regex anchored:(BOOL)anchored;
-(ObjectType)objectForString:(NSString *)string;
-(TPRegexDictionaryMatch<ObjectType> *)matchForString:(NSString *)string;
@end
