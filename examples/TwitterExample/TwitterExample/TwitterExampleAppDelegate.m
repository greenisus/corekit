//
//  TwitterExampleAppDelegate.m
//  TwitterExample
//
//  Created by Matt Newberry on 8/10/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "TwitterExampleAppDelegate.h"
#import "CoreKit.h"
#import "Tweet.h"
#import "TwitterSearchTableViewController.h"

@implementation TwitterExampleAppDelegate
@synthesize navigationController = _navigationController;

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CKManager sharedManager] setBaseURL:@"http://search.twitter.com/"];
    [[CKManager sharedManager] setResponseKeyPath:@"results"];
    [[CKManager sharedManager] setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss ZZ"];
    
    [Tweet mapToRemotePath:@"search.json"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];    
    
    TwitterSearchTableViewController *vc = [[TwitterSearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window addSubview:_navigationController.view];
    [vc release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) dealloc{
    
    [super dealloc];
    
    [_navigationController release];
}

@end
