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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 233, 21)];
        self.userName.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.userName];
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(289, 5, 25, 21)];
        self.time.font = [UIFont boldSystemFontOfSize:12];
        self.time.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.time];
        
        self.tweet = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 300, 21)];
        self.tweet.numberOfLines = 0;
        self.tweet.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.tweet];
    }
    
    return self;
}

@end
