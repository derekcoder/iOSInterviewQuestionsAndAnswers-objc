//
//  Son.m
//  iOSInterviewDemo-objc
//
//  Created by Julie on 30/6/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

#import "Son.h"

@implementation Son

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}

@end
