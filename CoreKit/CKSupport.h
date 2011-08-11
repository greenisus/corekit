//
//  CKSupport.h
//  CoreKit
//
//  Created by Matt Newberry on 7/28/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Create NSSortDescriptors from a string
 @param sort Example: @"id DESC"
 */
NSArray* CK_SORT(NSString *sort);

BOOL CK_CONNECTION_AVAILABLE();