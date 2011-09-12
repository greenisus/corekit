//
//  CKBindingMap.m
//  CoreKit
//
//  Created by Matt Newberry on 8/26/11.
//  Copyright (c) 2011 MNDCreative, LLC. All rights reserved.
//

#import "CKBindingMap.h"
#import "CKDefines.h"
#import "CKManager.h"
#import "CKRecordPrivate.h"
#import <UIKit/UIKit.h>

@implementation CKBindingMap

@synthesize objectID = _objectID;
@synthesize entityClass = _entityClass;
@synthesize control = _control;
@synthesize target = _target;
@synthesize changeType = _changeType;
@synthesize block = _block;
@synthesize selector = _selector;
@synthesize keyPath = _keyPath;

+ (CKBindingMap *) map{
    
    return [[CKBindingMap alloc] init];
}

- (void) setObjectID:(NSManagedObjectID *)objectID{
    
    self.entityClass = NSClassFromString([[objectID entity] managedObjectClassName]); 
    _objectID = objectID;
}

- (CKRecord *) object{
    
    return (CKRecord *) [[CKManager sharedManager].managedObjectContext objectWithID:_objectID];
}

- (void) fire{
    
    if(_control != nil && _keyPath != nil)
        [self updateControl];    
    
    if(_selector != nil && _target != nil)
        [_target performSelector:_selector withObject:self];
    
    if(_block != nil)
        _block();
}

- (void) updateControl{
    
    id value = [self.object valueForKeyPath:_keyPath];
        
    if(value == nil)
        return;
    
    if([value isKindOfClass:[NSString class]]){
     
        if([_control respondsToSelector:@selector(setText:)])
            [_control performSelectorOnMainThread:@selector(setText:) withObject:value waitUntilDone:YES];
    }
    
    else if([value isKindOfClass:[NSNumber class]]){
        
        if([_control respondsToSelector:@selector(setText:)]){
         
            [_control performSelectorOnMainThread:@selector(setText:) withObject:[[self object] stringValueForKeyPath:_keyPath] waitUntilDone:YES];
        }
        else if([_control isKindOfClass:[UIProgressView class]]){
            
            float progress = [value floatValue];
            progress = progress > 1 ? progress / 100 : progress;
            
            [_control setProgress:progress animated:NO];
        }
        else if([_control isKindOfClass:[UISlider class]] || [_control isKindOfClass:NSClassFromString(@"UIStepper")]){
            
            [(UISlider *) _control setValue:[value floatValue]];
        }
        else if([_control isKindOfClass:[UISwitch class]]){
            
            [_control setOn:[value boolValue] animated:NO];
        }
    }
    
    else if([value isKindOfClass:[NSDate class]] && [_control respondsToSelector:@selector(setText:)]){
        
        [_control performSelectorOnMainThread:@selector(setText:) withObject:[[self object] stringValueForKeyPath:_keyPath] waitUntilDone:YES];
    }
}

@end
