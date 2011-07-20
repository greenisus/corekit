//
//  CKNSJSONSerialization.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKSerialization.h"

/**
 For iOS 5, CKNSJSONSerialization servers as the default serializer.
 
 See protocol CKSerialization
 */
@interface CKNSJSONSerialization : NSObject <CKSerialization>

@end
