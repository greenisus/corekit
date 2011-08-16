//
//  TweetCell.m
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"

@implementation TweetCell
@synthesize userName = _userName;
@synthesize tweet = _tweet;
@synthesize time = _time;


- (void) dealloc{
    
    [super dealloc];
    
    [_userName release];
    [_tweet release];
    [_time release];
}

@end
