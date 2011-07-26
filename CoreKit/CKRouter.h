//
//  CKRouter.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRequest.h"

@interface CKRouter : NSObject{
    
    NSMutableDictionary *_routes;
}

/** Routing dictionary for classes 
 
 */
@property (nonatomic, retain) NSMutableDictionary *routes;

- (void) map:(Class) cls toURL:(NSString *) url forMethod:(CKRequestMethod) method;
- (void) mapKey:(NSString *) key toClass:(Class) cls property:(NSString *) property;
- (void) mapRelationship:(NSString *) relationship forClass:(Class) cls toProperty:(NSString *) property;

- (NSString *) urlForClass:(Class) cls forMethod:(CKRequestMethod) method;

@end
