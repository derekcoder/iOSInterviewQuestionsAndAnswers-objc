//
//  ViewController.m
//  iOSInterviewDemo-objc
//
//  Created by Julie on 30/6/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

#import "ViewController.h"
#import "Son.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, assign) NSString *str;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    NSString *name = [self.delegate name];
    NSLog(@"%@", name);
    [self.delegate setName:@"ViewController"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    Son *son = [[Son alloc] init];
    
    void (^blk)(void) = ^{
        for (int i = 0; i < 100; i++) {
            printf("Hello, World!");
        }
    };
    blk();
}


@end
