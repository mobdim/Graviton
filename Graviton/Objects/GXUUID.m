//
//  GXUUID.m
//  Graviton
//
//  Created by Logan Collins on 11/2/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXUUID.h"


@implementation GXUUID {
    CFUUIDRef _UUID;
}

+ (GXUUID *)UUID {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _UUID = CFUUIDCreate(NULL);
    }
    return self;
}

- (id)initWithUUIDString:(NSString *)string {
    self = [super init];
    if (self) {
        _UUID = CFUUIDCreateFromString(NULL, (__bridge CFStringRef)string);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSString *string = [aDecoder decodeObjectForKey:@"UUIDString"];
        _UUID = CFUUIDCreateFromString(NULL, (__bridge CFStringRef)string);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self UUIDString] forKey:@"UUIDString"];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc {
    CFRelease(_UUID);
}

- (NSUInteger)hash {
    return (NSUInteger)CFHash(_UUID);
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXUUID class]]) {
        return CFEqual(_UUID, ((GXUUID *)object)->_UUID);
    }
    return NO;
}

- (NSString *)UUIDString {
    return CFBridgingRelease(CFUUIDCreateString(NULL, _UUID));
}

@end
