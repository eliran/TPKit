//
//  NSString+Directories.h
//  SlingshotDave
//
//  Created by Eliran Ben-Ezra on 1/20/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Directories)
-(NSString *)stringByPrependingDirectory:(NSString *)directory;
-(NSString *)stringByPrependingCacheDirectory;
-(NSString *)resourcePathInMainBundle;
-(NSString *)resourcePathInBundle:(NSBundle *)bundle;
@end
