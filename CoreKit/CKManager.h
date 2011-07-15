//
//  CKManager.h
//  CoreKit
//
//  Created by Matt Newberry on 7/14/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKCoreData.h"

@interface CKManager : NSObject{
    
    NSString *_baseURL;
    NSURLCredential *_credentials;
    
    CKCoreData *_coreData;
    
    id _connectionClass;
	id _serializationClass;
    id _fixtureParsingClass;
}

@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSURLCredential *credentials;
@property (nonatomic, assign) id serializationClass;
@property (nonatomic, assign) id fixtureParsingClass;
@property (nonatomic, assign) id connectionClass;
@property (nonatomic, retain) CKCoreData *coreData;


+ (CKManager *) sharedManager;
- (CKManager *) managerWithURL:(NSString *) url user:(NSString *) user password:(NSString *) password;

@end
