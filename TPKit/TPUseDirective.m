//
//  TPCompiledUseDirective.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/15/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPUseDirective.h"

@implementation TPUseDirective
+(void)load {
  [TPDirective registerDefaultDirective:self];
}

+(NSString *)directiveRegex {
  return @"use";
}

-(NSArray<TPXMLElement *> *)renderXMLWithContext:(id<TPDirectiveContext>)context {
  NSString *blockId = [self.attributes attributeValueWithName:@"id"];
  if ( blockId )
    return [[context blockWithName:blockId] renderXMLWithContext:context];
  return nil;
}
@end
