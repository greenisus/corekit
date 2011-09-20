//
//  AppDelegate.h
//  Twitter
//
//  Created by Matt Newberry on 9/16/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TwitterVC *vc;

@end
