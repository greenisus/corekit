//
//  CKDefines.h
//  CoreKit
//
//  Created by Matt Newberry on 7/20/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

/** @name ckFixturePath */
/** The default path for testing fixtures */
#define ckFixturePath @"fixtures/"

/** @name ckFixturePath */
/** The default path for seeds */
#define ckSeedPath @"seeds/"

/** Set a class prefix such as RS, RAX, etc.. Will be parsed out when necessary for remote operations and local file mapping */
#define ckCoreDataClassPrefix @""

/** Default date format used to parse strings to NSDate objects. */
#define ckDateDefaultFormat @"yyyy-MM-dd'T'HH:mm:ssZZZ"

#define ckLogLevel 1 

#define ckDomainID "com.corekit"


/** @name Methods */
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

