//
//  TPXMLElementBuilder.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPXMLElementBuilder.h"

@implementation TPXMLElementBuilder {
  NSMutableSet <TPXMLAttribute *>*_attributes;
  NSMutableArray <TPXMLElement *>*_children;
}
-(instancetype)init {
  if((self=[super init])){
    _attributes = [NSMutableSet new];
    _children = [NSMutableArray new];
  }
  return self;
}
-(NSArray<TPXMLElement *> *)children {
  return _children.copy;
}
-(NSDictionary<NSString *,NSString *> *)attributes {
  return _attributes.copy;
}
-(void)addAttribute:(TPXMLAttribute *)attribute {
  [_attributes addObject:attribute];
}
-(void)addAttribute:(NSString *)value name:(NSString *)name {
  [self addAttribute:[TPXMLAttribute attributeWithName:name value:value]];
}
-(void)addAttributes:(NSDictionary *)attributes {
  for (NSString *name in attributes) {
    [self addAttribute:attributes[name] name:name];
  }
}
-(void)addChild:(TPXMLElement *)element {
  [_children addObject:element];
}
-(void)addChildren:(NSArray<TPXMLElement *> *)elements {
  [_children addObjectsFromArray:elements];
}

-(TPXMLElement *)build {
  return [TPXMLElement.alloc initWithName:self.elementName
                               attributes:self.attributes
                                 children:self.children];
}
@end
