//
//  TPDelegatedReader.m
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/26/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "TPDelegatedReader.h"

@implementation TPDelegatedReader
-(instancetype)initWithDelegate:(id<TPReaderDelegate>)delegate {
  if((self=[super init])){
    self.delegate = delegate;
  }
  return self;
}
@end
