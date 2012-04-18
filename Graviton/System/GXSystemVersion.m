//
//  GXSystemVersion.m
//  Graviton
//
//  Created by Logan Collins on 4/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXSystemVersion.h"


@interface GXSystemVersion ()

@property (copy, readwrite) NSString *string;

@end


@implementation GXSystemVersion

@synthesize string=_string;

+ (NSString *)pc_normalizedSystemVersionStringWithString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"."];
    NSMutableArray *newComponents = [NSMutableArray arrayWithCapacity:[components count]];
    
    for (NSString *component in components) {
        NSUInteger value = [component integerValue];
        [newComponents addObject:[NSString stringWithFormat:@"%lu", value]];
    }
    
    // Strip extra 0'd components
    for (NSInteger i=[newComponents count]-1; i>=0; i--) {
        NSString *component = [newComponents objectAtIndex:i];
        if ([component isEqualToString:@"0"]) {
            [newComponents removeObjectAtIndex:i];
        }
    }
    
    return [newComponents componentsJoinedByString:@"."];
}

+ (GXSystemVersion *)currentSystemVersion {
    static GXSystemVersion *currentSystemVersion = nil;
    
    if (currentSystemVersion == nil) {
        // This is the (official internal Apple) recommended way of getting the system version in 10.##.## form.
        // Gestalt is broken and deprecated on 10.8+.
        // All Unix-level utilities will not give the OS X version number, only Darwin's.
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSURL *systemVersionURL = [[fileManager URLForDirectory:NSLibraryDirectory inDomain:NSSystemDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:@"CoreServices/SystemVersion.plist"];
        NSData *systemVersionData = [NSData dataWithContentsOfURL:systemVersionURL];
        NSDictionary *systemInfo = [NSPropertyListSerialization propertyListWithData:systemVersionData options:0 format:NULL error:nil];
        if (systemInfo != nil) {
            NSString *productVersion = [systemInfo objectForKey:@"ProductVersion"];
            if ([productVersion length] > 0) {
                currentSystemVersion = [GXSystemVersion systemVersionWithString:productVersion];
            }
        }
    }
    
    return currentSystemVersion;
}

+ (GXSystemVersion *)systemVersionWithString:(NSString *)aString {
    NSString *normalizedString = [self pc_normalizedSystemVersionStringWithString:aString];
    GXSystemVersion *systemVersion = [[self alloc] init];
    systemVersion.string = normalizedString;
    return systemVersion;
}

- (NSUInteger)hash {
    return [[self string] hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXSystemVersion class]]) {
        return [self isEqualToSystemVersion:object];
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSComparisonResult)compare:(GXSystemVersion *)aVersion {
    NSMutableArray *components = [[[self string] componentsSeparatedByString:@"."] mutableCopy];
    NSMutableArray *otherComponents = [[[aVersion string] componentsSeparatedByString:@"."] mutableCopy];
    
    NSString *component = nil;
    while (([components count] > 0) && (component = [components objectAtIndex:0])) {
        NSString *otherComponent = ([otherComponents count] > 0) ? [otherComponents objectAtIndex:0] : nil;
        
        if (otherComponent == nil) {
            return NSOrderedDescending;
        }
        
        NSComparisonResult result = [component compare:otherComponent options:NSNumericSearch];
        if (result != NSOrderedSame) {
            return result;
        }
        
        [components removeObjectAtIndex:0];
        [otherComponents removeObjectAtIndex:0];
    }
    
    if ([otherComponents count] > 0) {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : %@>", [self class], self, [self string]];
}

- (BOOL)isEqualToSystemVersion:(GXSystemVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedAscending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanSystemVersion:(GXSystemVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedAscending);
}

- (BOOL)isGreaterThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedDescending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isGreaterThanSystemVersion:(GXSystemVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedDescending);
}

- (BOOL)isEqualToString:(NSString *)string {
    GXSystemVersion *aVersion = [GXSystemVersion systemVersionWithString:string];
    return ([self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanOrEqualToString:(NSString *)string {
    GXSystemVersion *aVersion = [GXSystemVersion systemVersionWithString:string];
    return ([self compare:aVersion] == NSOrderedAscending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanString:(NSString *)string {
    GXSystemVersion *aVersion = [GXSystemVersion systemVersionWithString:string];
    return ([self compare:aVersion] == NSOrderedAscending);
}

- (BOOL)isGreaterThanOrEqualToString:(NSString *)string {
    GXSystemVersion *aVersion = [GXSystemVersion systemVersionWithString:string];
    return ([self compare:aVersion] == NSOrderedDescending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isGreaterThanString:(NSString *)string {
    GXSystemVersion *aVersion = [GXSystemVersion systemVersionWithString:string];
    return ([self compare:aVersion] == NSOrderedDescending);
}

@end
