//
//  TPXMLParser.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPXMLParser.h"
#import "TPXMLElementBuilder.h"

@interface TPXMLParser () <NSXMLParserDelegate>
@property (readonly)TPXMLElement *rootElement;
@end

@implementation TPXMLParser {
  NSXMLParser *parser;
  NSMutableArray <TPXMLElementBuilder *>*builderStack;
}
+(TPXMLElement *)parseWithString:(NSString *)xmlString {
  return [self parseWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
}
+(TPXMLElement *)parseWithData:(NSData *)xmlData {
  TPXMLParser *parser = [self.alloc initWithData:xmlData];
  return parser.rootElement;
}
-(instancetype)initWithData:(NSData *)data {
  if((self=[super init])){
    parser = [NSXMLParser.alloc initWithData:data];
    parser.delegate = self;
    [parser parse];
  }
  return self;
}
-(TPXMLElementBuilder *)currentBuilder {
  return builderStack.lastObject;
}
-(void)pushBuilder:(TPXMLElementBuilder *)builder {
  [builderStack addObject:builder];
}
-(TPXMLElementBuilder *)popBuilder {
  TPXMLElementBuilder *builder = builderStack.lastObject;
  [builderStack removeLastObject];
  return builder;
}
-(void)addElement:(TPXMLElement *)element {
  [self.currentBuilder addChild:element];
}

-(void)startDocument {
  builderStack = [@[TPXMLElementBuilder.new] mutableCopy];
  _rootElement = nil;
}
-(void)startElementWithName:(NSString *)name attributes:(NSDictionary *)attributes {
  TPXMLElementBuilder *builder = TPXMLElementBuilder.new;
  builder.elementName = name;
  [builder addAttributes:attributes];
  [self pushBuilder:builder];
}
-(void)endElement {
  [self addElement:[self popBuilder].build];
}
-(void)endDocument {
  TPXMLElementBuilder *rootBuilder = builderStack.lastObject;
  if ( rootBuilder.children.count == 1 ) {
    _rootElement = rootBuilder.children[0];
  }
  else if ( rootBuilder.children.count > 1 ) {
    rootBuilder.elementName = @"__root__";
    _rootElement = rootBuilder.build;
  }
}
#pragma mark - NSXMLParser delegate
-(void)parserDidStartDocument:(NSXMLParser *)parser {
  [self startDocument];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
  [self startElementWithName:elementName attributes:attributeDict];
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  [self endElement];
}
-(void)parserDidEndDocument:(NSXMLParser *)parser {
  [self endDocument];
}
@end
