//
//  TPXMLElement.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPXMLName.h"
#import "TPXMLAttribute.h"

@class TPXMLElement;

NS_ASSUME_NONNULL_BEGIN

typedef _Nullable id(^XMLMapBlock)(TPXMLElement *element, NSArray  *mappedChildren);

@interface TPXMLElement : NSObject
@property (readonly)TPXMLName * _Nullable tag;

@property (readonly)NSSet <TPXMLAttribute *> * _Nullable attributes;
@property (readonly)NSArray <TPXMLElement *> * _Nullable children;

+(instancetype)elementWithName:(nullable NSString *)name;
+(instancetype)elementWithName:(nullable NSString *)name attributes:(nullable NSSet <TPXMLAttribute *> *)attributes;
+(instancetype)elementWithName:(nullable NSString *)name children:(nullable NSArray <TPXMLElement *> *)elements;

-(instancetype)initWithName:(nullable NSString *)name
                 attributes:(nullable NSSet <TPXMLAttribute *> *)attributes
                   children:(nullable NSArray<TPXMLElement *> *)elements;

-(nullable TPXMLAttribute *)attributeWithName:(nonnull NSString *)name;

-(nonnull id)map:(XMLMapBlock)block;

-(NSString *)toString;
@end

NS_ASSUME_NONNULL_END

