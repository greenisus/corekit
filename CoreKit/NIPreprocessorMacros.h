//
// Copyright 2011 Jeff Verkoeyen
//
// Forked from Three20 June 10, 2011 - Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Preprocessor Macros

/**
 * Release and assign nil to an object.
 *
 * This macro is preferred to simply releasing an object to avoid accidentally using the
 * object later on in a method.
 */
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }


///////////////////////////////////////////////////////////////////////////////////////////////////
/**@}*/// End of Preprocessor Macros //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
