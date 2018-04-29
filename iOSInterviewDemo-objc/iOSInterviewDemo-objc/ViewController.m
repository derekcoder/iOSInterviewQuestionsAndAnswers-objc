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
@property (nonatomic, copy) void (^myCopyBlk)(void);
@property (nonatomic, strong) void (^myStrongBlk)(void);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *name = [self.delegate name];
    NSLog(@"%@", name);
    [self.delegate setName:@"ViewController"];
    
    [super viewDidLoad];
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
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
    
    void (^localBlk)(void) = blk;
    NSLog(@"block's & address: %p", &blk);
    NSLog(@"block's address: %p", blk);
    self.myCopyBlk = blk;
    self.myStrongBlk = self.myCopyBlk;
    NSLog(@"block's local address: %p", localBlk);
    NSLog(@"block's copy address: %p", _myCopyBlk);
    NSLog(@"block's strong address: %p", _myStrongBlk);
    NSLog(@"block's & address: %p", &blk);
    NSLog(@"block's address: %p", blk);
//    self.myBlk();
    
}


@end
