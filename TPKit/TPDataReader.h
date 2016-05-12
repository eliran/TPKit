//
//  TPDataReader.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/23/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPReader.h"

@interface TPDataReader : TPNullReader <TPReader>
-(nullable instancetype)init NS_UNAVAILABLE;
-(nonnull instancetype)initWithData:(nonnull NSData *)data;
@end
