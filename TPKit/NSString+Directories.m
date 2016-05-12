//
//  NSString+Directories.m
//  SlingshotDave
//
//  Created by Eliran Ben-Ezra on 1/20/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import "NSString+Directories.h"

@implementation NSString (Directories)
-(NSString *)cacheDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

-(NSString *)stringByPrependingDirectory:(NSString *)directory {
  return [directory stringByAppendingPathComponent:self];
}
-(NSString *)stringByPrependingCacheDirectory{
  return [self stringByPrependingDirectory:[self cacheDirectory]];
}
-(NSString *)resourcePathInMainBundle {
  return [self resourcePathInBundle:[NSBundle mainBundle]];
}
-(NSString *)resourcePathInBundle:(NSBundle *)bundle {
  return [bundle pathForResource:[self stringByDeletingPathExtension] ofType:[self pathExtension]];
}
@end
