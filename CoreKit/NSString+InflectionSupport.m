//
//  NSString+InflectionSupport.m
//  
//
//  Created by Ryan Daigle on 7/31/08.
//  Copyright 2008 yFactorial, LLC. 
//

#import "NSString+InflectionSupport.h"

@implementation NSString (InflectionSupport)

static NSMutableDictionary *cachedCamelized;

- (NSCharacterSet *)capitals {
	return [NSCharacterSet uppercaseLetterCharacterSet];
}

- (NSString *)deCamelizeWith:(NSString *)delimiter {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	NSString *currChar;
	for (int i = 0; i < [self length]; i++) {
		currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([[self capitals] characterIsMember:buffer[i]]) {
			[underscored appendFormat:@"%@%@", delimiter, [currChar lowercaseString]];
		} else {
			[underscored appendString:currChar];
		}
	}
	
	free(buffer);
	return underscored;
}
	

- (NSString *)dasherize {
	return [self deCamelizeWith:@"-"];
}

- (NSString *)underscore {
	return [self deCamelizeWith:@"_"];
}

- (NSCharacterSet *)camelcaseDelimiters {
	return [NSCharacterSet characterSetWithCharactersInString:@"-_"];
}

- (NSString *)camelize {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer ];
	NSMutableString *underscored = [NSMutableString string];
	
	BOOL capitalizeNext = NO;
	NSCharacterSet *delimiters = [self camelcaseDelimiters];
	for (int i = 0; i < [self length]; i++) {
		NSString *currChar = [NSString stringWithCharacters:buffer+i length:1];
		if([delimiters characterIsMember:buffer[i]]) {
			capitalizeNext = YES;
		} else {
			if(capitalizeNext) {
				[underscored appendString:[currChar uppercaseString]];
				capitalizeNext = NO;
			} else {
				[underscored appendString:currChar];
			}
		}
	}
	
	free(buffer);
	return underscored;
}

- (NSString*)camelizeCached {
    if (cachedCamelized == nil)
        cachedCamelized = [[NSMutableDictionary dictionary] retain];
    else {
        NSString* cached = [cachedCamelized objectForKey:self];
        if (cached != nil)
            return cached;
    }
    
    NSString* camelized = [self camelize];
    [cachedCamelized setObject:camelized forKey:self];
    return camelized;
}

- (NSString *)titleize {
	
	if([self length] == 0)
		return self;
	
	NSArray *words = [self componentsSeparatedByString:@" "];
	
	NSMutableArray *output = [NSMutableArray array];
	
	for(NSString *word in words){
		
		if([word stringIsEmptyOrWhitespace])
			continue;
		
		[output addObject:[[word lowercaseString] capitalizedString]];
	}
		
	return [output componentsJoinedByString:@" "];
}

- (NSString *)decapitalize {
    return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)toClassName {
	NSString *result = [self camelize];
	return [result stringByReplacingCharactersInRange:NSMakeRange(0,1) 
										 withString:[[result substringWithRange:NSMakeRange(0,1)] uppercaseString]];
}

//// From three20, renamed to avoid any issues

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)stringIsEmptyOrWhitespace {
	return !self.length ||
	![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (NSString*)pluralForm    { 
    return [[CWInflector inflector] pluralFormOf:self];    }
- (NSString*)singularForm  { return [[CWInflector inflector] singularFormOf:self];  }
- (NSString*)humanizedForm { return [[CWInflector inflector] humanizedFormOf:self]; }


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Parses a URL query string into a dictionary where the values are arrays.
 *
 * A query string is one that looks like &param1=value1&param2=value2...
 *
 * The resulting NSDictionary will contain keys for each parameter name present in the query.
 * The value for each key will be an NSArray which may be empty if the key is simply present
 * in the query. Otherwise each object in the array with be an NSString corresponding to a value
 * in the query for that parameter.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[[NSScanner alloc] initWithString:self] autorelease];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}
@end
