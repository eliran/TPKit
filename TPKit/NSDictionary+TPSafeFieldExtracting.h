//
//  NSDictionary+TPSafeFieldExtracting.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/16/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (TPSafeFieldExtracting)
// Basic fields
-(nullable NSNumber *)numberField:(id<NSCopying>)field;
-(nullable NSArray *)arrayField:(id<NSCopying>)field;
-(nullable NSString *)stringField:(id<NSCopying>)field;
-(nullable NSDictionary *)dictionaryField:(id<NSCopying>)field;
-(NSInteger)integerField:(id<NSCopying>)field withDefault:(NSInteger)defaultValue;
-(NSInteger)integerField:(id<NSCopying>)field;
-(double)realField:(id<NSCopying>)field withDefault:(double)defaultValue;
-(double)realField:(id<NSCopying>)field;
-(nullable id)field:(nullable id<NSCopying>)field withDefault:(nullable id)defaultValue;

// Extended fields

@end
NS_ASSUME_NONNULL_END
