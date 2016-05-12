//
//  TPXMLElement.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPXMLElement.h"
#import "NSArray+LazyGenerator.h"

@implementation TPXMLElement {
  NSDictionary <NSString *, TPXMLAttribute *> *attributesDict;
}
+(instancetype)elementWithName:(NSString *)name {
  return [[self alloc] initWithName:name attributes:nil children:nil];
}
+(instancetype)elementWithName:(NSString *)name attributes:(NSSet <TPXMLAttribute *> *)attributes {
  return [[self alloc] initWithName:name attributes:attributes children:nil];
}
+(instancetype)elementWithName:(NSString *)name children:(NSArray<TPXMLElement *> *)elements {
  return [[self alloc] initWithName:name attributes:nil children:elements];
}

-(instancetype)init {
  return [self initWithName:nil attributes:nil children:nil];
}
-(instancetype)initWithName:(NSString *)name
                 attributes:(NSSet <TPXMLAttribute *> *)attributes
                   children:(NSArray<TPXMLElement *> *)elements {
  if((self=[super init])){
    _tag =[TPXMLName.alloc initWithFullName:name];
    _children = elements;
    _attributes = attributes;
  }
  return self;
}

-(TPXMLAttribute *)attributeWithName:(NSString *)name {
  if ( attributesDict == nil ) [self buildAttributesIndex];
  return attributesDict[name];
}
-(void)buildAttributesIndex {
  NSMutableDictionary *index = [NSMutableDictionary new];
  for (TPXMLAttribute *attribute in _attributes) {
    index[attribute.name.full] = attribute;
  }
  attributesDict = index.copy;
}

-(NSString *)toString {
  NSString *body = [[_children mapUsingSelector:@selector(toString)] componentsJoinedByString:@""];

  if ( _tag.full.length == 0 )
    return body.length > 0 ? body : @"";

  NSArray *sortedAttributes = [_attributes.allObjects sortedArrayUsingSelector:@selector(compare:)];
  NSString *attributes = [[sortedAttributes  mapUsingSelector:@selector(toString)] componentsJoinedByString:@" "];
  NSMutableString *xmlString = [NSMutableString stringWithFormat:@"<%@", _tag.full];
  if ( attributes.length > 0 )
    [xmlString appendFormat:@" %@", attributes];

  if ( body.length > 0 ) {
    [xmlString appendFormat:@">%@</%@>", body, _tag.full];
  }
  else [xmlString appendFormat:@" />"];
  return xmlString.copy;
}

-(id)map:(XMLMapBlock)block {
  NSArray *mappedChildren = [self.children.lazy map:^id(TPXMLElement *element) {
    return [element map:block];
  }].filterNulls.array;
  return block(self, mappedChildren ? mappedChildren : @[]);
}


-(NSString *)attributesDescription {
  NSString *description = [[self.attributes.allObjects map:^id(TPXMLAttribute *element) {
    return [NSString stringWithFormat:@"%@: %@", element.name.full, element.value];
  }] componentsJoinedByString:@", "];

  if ( description == nil ) return @"";
  return description;
}
-(NSString *)descriptionWithIndent:(NSUInteger)count {
  NSString *indent = [@"" stringByPaddingToLength:count withString:@" " startingAtIndex:0];
  NSMutableString *description = [NSMutableString new];
  NSString *bodyText = @""; //_bodyText?_bodyText:@""
  [description appendFormat:@"%@%@ {%@} %@\r",indent, self.tag.full, self.attributesDescription, bodyText];
  [self.children eachWithIndex:^(NSUInteger index, TPXMLElement *element) {
    [description appendString:[element descriptionWithIndent:count+2]];
  }];
  return description;
}
-(NSString *)description {
  return [self descriptionWithIndent:0];
}

@end
