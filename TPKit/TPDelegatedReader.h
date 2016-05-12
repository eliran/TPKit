//
//  TPDelegatedReader.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 2/26/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <TPKit/TPKit.h>

@protocol TPReaderDelegate <NSObject>
@end

@interface TPDelegatedReader : TPNullReader
@property (readwrite)id<TPReaderDelegate> delegate;
-(instancetype)initWithDelegate:(id<TPReaderDelegate>)delegate;
@end
