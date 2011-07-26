//
//  CKDefines.h
//  CoreKit
//
//  Created by Matt Newberry on 7/20/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//


/** @name Properties */
/** The default path for fixtures, used for testing or seeding inital data */
#define ckFixturePath @"fixtures/"

/** Set a class prefix such as RS, RAX, etc.. Will be parsed out when necessary for remote operations and local file mapping */
#define ckCoreDataClassPrefix @""

/** Default date format used to parse strings to NSDate objects. */
#define ckDateDefaultFormat @"yyyy-MM-dd'T'HH:mm:ssZZZ"


/** @name Methods */
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }