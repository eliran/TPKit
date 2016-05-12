//
//  TPXMLName.h
//  TPKit
//
//  Created by Eliran Ben-Ezra on 3/8/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPXMLName : NSObject
@property (readonly)NSString *name;
@property (readonly)NSString *space;
@property (readonly)NSString *full;
@property (readonly)NSArray<NSString *>*components;
-(instancetype)initWithFullName:(NSString *)fullName;
@end
