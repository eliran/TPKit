//
//  QRange.h
//  UtilKit
//
//  Created by Eliran Ben-Ezra on 12/15/15.
//  Copyright © 2015 Threeplay Inc. All rights reserved.
//

#import "QArrayGenerator.h"
@interface QRange : NSObject
@property (readonly)NSInteger from;
@property (readonly)NSInteger to;
@property (readonly)NSInteger step;
+(instancetype)naturalNumbers;
+(instancetype)naturalsWithZero;

+(instancetype)integerRangeFrom:(NSInteger)from to:(NSInteger)to;
-(instancetype)initWithIntegerRangeFrom:(NSInteger)from to:(NSInteger)to;
-(QArrayGenerator *)lazy;
@end
