//
//  TwitterVCDataSource.m
//  Twitter
//
//  Created by Matt Newberry on 9/20/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "TwitterVCDataSource.h"
#import "Tweet.h"
#import "TweetCell.h"

@implementation TwitterVCDataSource

- (void) configureCell:(TweetCell *) cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    
    Tweet *tweet = object;
    
    cell.userName.text = tweet.from_user;
    
    cell.tweet.text = tweet.text;
    CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    cell.tweet.frame = CGRectMake(cell.tweet.frame.origin.x, cell.tweet.frame.origin.y, cell.tweet.frame.size.width, size.height);
    
    cell.time.text = [tweet relativeDate];    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
