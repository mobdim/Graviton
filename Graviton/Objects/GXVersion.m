//
//  GXVersion.m
//  Graviton
//
//  Created by Logan Collins on 6/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXVersion.h"
#import "GXVersion_Private.h"


@implementation GXVersion

@synthesize releaseString=_releaseString;
@synthesize prereleaseString=_prereleaseString;
@synthesize releaseType=_releaseType;

+ (GXVersion *)versionWithString:(NSString *)string {
#if __has_feature(objc_arc)
    return [[self alloc] initWithString:string];
#else
    return [[[self alloc] initWithString:string] autorelease];
#endif
}

- (id)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        NSString *releaseString = nil;
        NSString *prereleaseString = nil;
        GXVersionReleaseType releaseType = GXVersionReleaseTypeFinal;
        
        // Check for prerelease version identifiers (e.g. "2.0b1")
        NSArray *prereleaseIdentifiers = [NSArray arrayWithObjects:@"alpha", @"beta", @"a", @"b", nil];
        for (NSString *prereleaseIdentifier in prereleaseIdentifiers) {
            NSRange range = [string rangeOfString:prereleaseIdentifier];
            if (range.location != NSNotFound) {
                releaseString = [string substringToIndex:range.location];
                prereleaseString = [string substringFromIndex:NSMaxRange(range)];
                
                if ([prereleaseIdentifier isEqualToString:@"beta"]
                    || [prereleaseIdentifier isEqualToString:@"b"]) {
                    releaseType = GXVersionReleaseTypeBeta;
                }
                else if ([prereleaseIdentifier isEqualToString:@"alpha"]
                         || [prereleaseIdentifier isEqualToString:@"a"]) {
                    releaseType = GXVersionReleaseTypeAlpha;
                }
                
                break;
            }
        }
        
        if (releaseString == nil) {
            releaseString = string;
        }
        
        NSArray *components = [releaseString componentsSeparatedByString:@"."];
        NSMutableArray *newComponents = [NSMutableArray arrayWithCapacity:[components count]];
        
        for (NSString *component in components) {
            NSUInteger value = [component integerValue];
            [newComponents addObject:[NSString stringWithFormat:@"%lu", (unsigned long)value]];
        }
        
        // Strip extra 0'd components
        for (NSInteger i=[newComponents count]-1; i>=2; i--) {
            NSString *component = [newComponents objectAtIndex:i];
            if ([component isEqualToString:@"0"]) {
                [newComponents removeObjectAtIndex:i];
            }
        }
        
        if ([newComponents count] == 1) {
            // Add a "0" if we only have one component (prefer "2.0" over "2")
            [newComponents addObject:@"0"];
        }
        
        self.releaseString = [newComponents componentsJoinedByString:@"."];
        self.releaseType = releaseType;
        self.prereleaseString = prereleaseString;
    }
    return self;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [_releaseString release];
    [_prereleaseString release];
    [super dealloc];
}
#endif

- (NSUInteger)hash {
    return [[self string] hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXVersion class]]) {
        return [self isEqualToVersion:object];
    }
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
#if __has_feature(objc_arc)
    return self;
#else
    return [self retain];
#endif
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : %@>", [self class], self, [self string]];
}

- (NSString *)string {
    NSMutableString *string = [NSMutableString string];
    [string appendString:self.releaseString];
    if (self.releaseType == GXVersionReleaseTypeAlpha) {
        [string appendString:@"a"];
        [string appendString:self.prereleaseString];
    }
    else if (self.releaseType == GXVersionReleaseTypeBeta) {
        [string appendString:@"b"];
        [string appendString:self.prereleaseString];
    }
    return string;
}

- (NSComparisonResult)compare:(GXVersion *)aVersion {
    NSMutableArray *components = [[[self releaseString] componentsSeparatedByString:@"."] mutableCopy];
#if !__has_feature(objc_arc)
    [components autorelease];
#endif
    NSMutableArray *otherComponents = [[[aVersion releaseString] componentsSeparatedByString:@"."] mutableCopy];
#if !__has_feature(objc_arc)
    [otherComponents autorelease];
#endif
    
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
    
    if (self.prereleaseString != nil && aVersion.prereleaseString == nil) {
        return NSOrderedAscending;
    }
    else if (self.prereleaseString == nil && aVersion.prereleaseString != nil) {
        return NSOrderedDescending;
    }
    else if (self.prereleaseString != nil && aVersion.prereleaseString != nil) {
        if (self.releaseType == GXVersionReleaseTypeAlpha && aVersion.releaseType == GXVersionReleaseTypeBeta) {
            return NSOrderedAscending;
        }
        else if (self.releaseType == GXVersionReleaseTypeBeta && aVersion.releaseType == GXVersionReleaseTypeAlpha) {
            return NSOrderedDescending;
        }
        else {
            NSComparisonResult result = [self.prereleaseString compare:aVersion.prereleaseString options:NSNumericSearch];
            if (result != NSOrderedSame) {
                return result;
            }
        }
    }
    
    return NSOrderedSame;
}

- (BOOL)isEqualToVersion:(GXVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanOrEqualToVersion:(GXVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedAscending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isLessThanVersion:(GXVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedAscending);
}

- (BOOL)isGreaterThanOrEqualToVersion:(GXVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedDescending || [self compare:aVersion] == NSOrderedSame);
}

- (BOOL)isGreaterThanVersion:(GXVersion *)aVersion {
    return ([self compare:aVersion] == NSOrderedDescending);
}

@end


@implementation NSBundle (GXVersion)

- (GXVersion *)GXVersion {
    NSString *versionString = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (versionString != nil) {
        return [GXVersion versionWithString:versionString];
    }
    return nil;
}

@end
