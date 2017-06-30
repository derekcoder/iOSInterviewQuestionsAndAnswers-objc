//
//  ViewController.h
//  iOSInterviewDemo-objc
//
//  Created by Julie on 30/6/17.
//  Copyright © 2017 ZHOU DENGFENG DEREK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>

@property (nonatomic, strong) NSString *name;

@end

@interface ViewController : UIViewController

@property (nonatomic, weak) id<ViewControllerDelegate> delegate;

@end

