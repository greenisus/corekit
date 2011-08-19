//
//  main.m
//  TwitterExample
//
//  Created by Matt Newberry on 8/10/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TwitterExampleAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retval = UIApplicationMain(argc, argv, nil, NSStringFromClass([TwitterExampleAppDelegate class]));
    [pool release];
    return retval;
}
