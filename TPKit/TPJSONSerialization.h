//
//  TPJSONSerialization.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/7/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPJSONSerialization : NSObject
+(NSString *)stringWithJSONObject:(id)object error:(NSError **)error;
@end
