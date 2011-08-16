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

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * from_user;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * text;

+ (void) search:(NSString *) query parseBlock:(CKParseBlock) parseBlock completionBlock:(CKResultBlock) completionBlock errorBlock:(CKErrorBlock) errorBlock;

@end
