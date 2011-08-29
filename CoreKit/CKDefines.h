//
//  CKDefines.h
//  CoreKit
//
//  Created by Matt Newberry on 7/20/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

/** @name Defaults */

/** The default path for testing fixtures */
#define ckFixturePath @"fixtures/"

/** The default path for seeds */
#define ckSeedPath @"seeds/"

/** Set a class prefix such as RS, RAX, etc.. Will be parsed out when necessary for remote operations and local file mapping */
#define ckCoreDataClassPrefix @""

/** Default date format used to parse strings to NSDate objects. */
#define ckDateDefaultFormat @"yyyy-MM-dd'T'HH:mm:ssZZZ"

/** Log level for debugging, 0 = None, 1 = Warnings, Errors, 2 = Errors */
#define ckLogLevel 1 

/** Domain used for NSError messages */
#define ckDomainID "com.corekit"


/** @name Methods */
/** Safely release properties */
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

