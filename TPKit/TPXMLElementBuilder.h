//
//  TPXMLElementBuilder.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPXMLElement.h"

@interface TPXMLElementBuilder : NSObject
@property (readwrite)NSString *elementName;
@property (readonly)NSSet <TPXMLAttribute *>*attributes;
@property (readonly)NSArray <TPXMLElement *> *children;

-(void)addAttributes:(NSDictionary *)attributes;
-(void)addAttribute:(NSString *)value name:(NSString *)name;
-(void)addAttribute:(TPXMLAttribute *)attribute;

-(void)addChild:(TPXMLElement *)element;
-(void)addChildren:(NSArray <TPXMLElement *> *)elements;

-(TPXMLElement *)build;
@end
