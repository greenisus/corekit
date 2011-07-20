//
//  CKSerialization.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 * CKSerialization defines conforming methods for third-party serialization libraries 
 */
@protocol CKSerialization <NSObject>

@required

/** @name Serializations */

/** Convert plain-text HTTP responses, such as JSON, into native objects
 @param object Plain-text
 */
- (id) deserialize:(NSData *) object;

/** Convert native objects to NSData objects
 @param object NSDictionary, NSArray, etc... to plain-text
 */
- (NSData *) serialize:(id) object;

@end
