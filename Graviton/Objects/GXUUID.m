//
//  GXUUID.m
//  Graviton
//
//  Created by Logan Collins on 11/2/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXUUID.h"


@implementation GXUUID {
    uuid_t _uuid;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (GXUUID *)UUID {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        uuid_generate(_uuid);
    }
    return self;
}

- (id)initWithUUIDString:(NSString *)string {
    self = [super init];
    if (self) {
        if (uuid_parse([string UTF8String], _uuid) != 0) {
            return nil;
        }
    }
    return self;
}

- (id)initWithUUIDBytes:(const uuid_t)bytes {
    self = [super init];
    if (self) {
        uuid_copy(_uuid, bytes);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSString *string = [aDecoder decodeObjectForKey:@"UUIDString"];
        uuid_parse([string UTF8String], _uuid);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self UUIDString] forKey:@"UUIDString"];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSUInteger)hash {
    return [[self UUIDString] hash];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXUUID class]]) {
        return (uuid_compare(_uuid, ((GXUUID *)object)->_uuid) == 0);
    }
    return NO;
}

- (NSString *)UUIDString {
    uuid_string_t string;
    uuid_unparse(_uuid, string);
    return [NSString stringWithCString:string encoding:NSUTF8StringEncoding];
}

- (void)getUUIDBytes:(uuid_t)uuid {
    uuid_copy(uuid, _uuid);
}

@end
