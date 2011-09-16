//
//  Tweet.h
//  TwitterExample
//
//  Created by Matt Newberry on 8/15/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRecord.h"


@interface Tweet : CKRecord

@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSString * from_user;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSString * profile_image_url;
@property (nonatomic, strong) NSString * text;

+ (void) search:(NSString *) query parseBlock:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKResultBlock) errorBlock;
- (NSString *) relativeDate;

@end
