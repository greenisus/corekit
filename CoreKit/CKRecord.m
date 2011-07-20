//
//  CKRecord.m
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKRecord.h"
#import "CKManager.h"
#import "CKDefines.h"
#import "NIPaths.h"

@implementation CKRecord

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Entity Methods

+ (NSManagedObjectContext *) managedObjectContext{
    
    return [[CKManager sharedManager] managedObjectContext];
}

+ (NSString *) entityName {
	
	return [self entityNameWithPrefix:YES];
}

+ (NSString *) entityNameWithPrefix:(BOOL) removePrefix{
    
    NSMutableString *name = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", self]];

    if([ckCoreDataClassPrefix length] > 0 && removePrefix)
        [name replaceOccurrencesOfString:ckCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ckCoreDataClassPrefix length])];
	
	return name;
}

+ (NSEntityDescription *) entityDescription{
	
	return [NSEntityDescription entityForName:[self entityNameWithPrefix:NO] inManagedObjectContext:[self managedObjectContext]];
}


#pragma mark -
#pragma mark Creating, Updating, Deleting

+ (id) blank{
    
    return [[[self alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:[self managedObjectContext]] autorelease];
}

#pragma mark -
#pragma mark Fixtures

+ (id) fixtureByName:(NSString *)name{
    
    return [self fixtureByName:name atPath:nil];
}

+ (id) fixtures{
    
    return [self fixtureByName:nil atPath:nil];
}

+ (id) fixtureByName:(NSString *) name atPath:(NSString *) path{
    
    NSString *fixturePath = NIPathForBundleResource([NSBundle bundleForClass:[self class]], ckFixturePath);

    if(path == nil){
        
        NSError *error;
        
        NSArray *fixtures = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fixturePath error:&error];
        NSArray *classFiles = [fixtures filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH %@", [self entityNameWithPrefix:NO]]];
        
        if([classFiles count] > 0)
            fixturePath = [fixturePath stringByAppendingFormat:@"/%@", [classFiles objectAtIndex:0]];
    }
    else
        fixturePath = [fixturePath stringByAppendingFormat:@"/%@", path];
    
    id contents = [[CKManager sharedManager] parse:[NSData dataWithContentsOfFile:fixturePath]];
    
    if([contents isKindOfClass:[NSDictionary class]] && name != nil && [[contents allKeys] containsObject:name])
        contents = [contents objectForKey:name];
    
    return contents;
}



@end
