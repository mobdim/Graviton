//
//  NSString+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 2/4/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import "NSString+GravitonAdditions.h"


@implementation NSString (GravitonAdditions)

- (NSString *)gx_stringUniqueToSet:(NSSet *)strings {
	NSString *uniqueString = nil;
	
	if ([strings containsObject:self]) {
		NSString *baseString = self;
		unsigned long copyIndex = 2;
		NSArray *components = [self componentsSeparatedByString:@" "];
		
		if ([components count] > 1) {
			char *endPtr = NULL;
			copyIndex = strtoul([[components objectAtIndex:[components count] - 1] UTF8String], &endPtr, 10);
			
			if (copyIndex != ULONG_MAX && *endPtr == '\0') {
				baseString = [[components subarrayWithRange:NSMakeRange(0, [components count] - 1)] componentsJoinedByString:@" "];
			}
			else {
				copyIndex = 2;
			}
		}
		
		do {
			uniqueString = [baseString stringByAppendingFormat:@" %lu", copyIndex++];
		}
		while ([strings containsObject:uniqueString]);
	}
	
	if (uniqueString == nil) {
		uniqueString = self;
    }
	
	return uniqueString;
}

- (NSString *)gx_stringUniqueToArray:(NSArray *)names copySuffix:(NSString *)copySuffix {
    return [self gx_stringUniqueToArray:names copySuffix:copySuffix filenames:NO];
}

- (NSString *)gx_stringUniqueToArray:(NSArray *)names copySuffix:(NSString *)copySuffix filenames:(BOOL)useExtension {
	NSString *uniqueString = nil;
	
	if (![names containsObject:self]) {
		uniqueString = self;
    }
	else {
		NSString *baseString = nil;
		NSString *extension = useExtension ? [self pathExtension] : nil;
		NSMutableSet *filteredFilenames = [NSMutableSet setWithCapacity:[names count]];
		
		if (useExtension && ![extension isEqualToString:@""]) {
			for (NSString *curFilename in names) {
				if ([[curFilename pathExtension] isEqualToString:extension]) {
					[filteredFilenames addObject:[curFilename stringByDeletingPathExtension]];
                }
			}
			baseString = [self stringByDeletingPathExtension];
		}
		else {
			[filteredFilenames addObjectsFromArray:names];
			baseString = self;
		}
		
		if (copySuffix != nil) {
			BOOL appendCopy = YES;
			NSArray *components = [baseString componentsSeparatedByString:@" "];
			
			if ([components count] > 1 && [[components objectAtIndex:[components count] - 1] isEqualToString:copySuffix]) {
				appendCopy = NO;
			}
			else if ([components count] > 2 && [[components objectAtIndex:[components count] - 2] isEqualToString:copySuffix]) {
				char *endPtr = NULL;
				unsigned long copyIndex = strtoul([[components objectAtIndex:[components count] - 1] UTF8String], &endPtr, 10);
				
				if (copyIndex != ULONG_MAX && *endPtr == '\0') {
					appendCopy = NO;
				}
			}
			
			if (appendCopy) {
				baseString = [baseString stringByAppendingFormat:@" %@", copySuffix];
			}
		}
		
		uniqueString = [baseString gx_stringUniqueToSet:filteredFilenames];
		
		if (useExtension && ![extension isEqualToString:@""]) {
			uniqueString = [uniqueString stringByAppendingPathExtension:extension];
        }
	}
	
	return uniqueString;
}

@end
