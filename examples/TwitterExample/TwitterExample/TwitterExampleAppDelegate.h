//
//  TwitterExampleAppDelegate.h
//  TwitterExample
//
//  Created by Matt Newberry on 8/10/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterExampleAppDelegate : UIResponder <UIApplicationDelegate>{
    
    UINavigationController *_navigationController;
}

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIWindow *window;

@end
