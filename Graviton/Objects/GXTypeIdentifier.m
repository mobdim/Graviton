//
//  GXTypeIdentifier.m
//  Graviton
//
//  Created by Logan Collins on 11/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXTypeIdentifier.h"

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#endif


NSString * const GXTagClassFilenameExtension = @"public.filename-extension";
NSString * const GXTagClassMIMEType = @"public.mime-type";
NSString * const GXTagClassNSPboardType = @"com.apple.nspboard-type";
NSString * const GXTagClassOSType = @"com.apple.ostype";


@implementation GXTypeIdentifier {
    NSString *_string;
    NSDictionary *_declaration;
}

static NSMutableDictionary *_typeIdentifiers = nil;

+ (void)initialize {
    if (self == [GXTypeIdentifier class]) {
        _typeIdentifiers = [[NSMutableDictionary alloc] init];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (GXTypeIdentifier *)typeIdentifierWithString:(NSString *)string {
    if (string != nil) {
        return [[GXTypeIdentifier alloc] initWithString:string];
    }
    return nil;
}

+ (GXTypeIdentifier *)typeIdentifierWithTag:(NSString *)tag tagClass:(NSString *)tagClass {
    NSString *string = CFBridgingRelease(UTTypeCreatePreferredIdentifierForTag((__bridge CFStringRef)tagClass, (__bridge CFStringRef)tag, NULL));
    return [self typeIdentifierWithString:string];
}

- (id)initWithString:(NSString *)string {
    NSParameterAssert(string != nil);
    
    self = [super init];
    if (self) {
        NSString *lowercaseString = [string lowercaseString];
        NSDictionary *declaration = _typeIdentifiers[lowercaseString];
        if (declaration == nil) {
            declaration = CFBridgingRelease(UTTypeCopyDeclaration((__bridge CFStringRef)string));
            if (declaration != nil) {
                _typeIdentifiers[lowercaseString] = declaration;
            }
        }
        
        _declaration = declaration;
        _string = _declaration[(__bridge NSString *)kUTTypeIdentifierKey];
        if (_string == nil) {
            return nil;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _string = [aDecoder decodeObjectForKey:@"string"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_string forKey:@"string"];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXTypeIdentifier class]]) {
        return [_string isEqual:((GXTypeIdentifier *)object)->_string];
    }
    return NO;
}

- (NSUInteger)hash {
    return [_string hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : %@>", [self class], self, _string];
}

- (NSString *)localizedDescription {
    return CFBridgingRelease(UTTypeCopyDescription((__bridge CFStringRef)_string));
}

- (NSDictionary *)infoDictionary {
    return _declaration;
}

- (NSBundle *)bundle {
    NSURL *bundleURL = CFBridgingRelease(UTTypeCopyDeclaringBundleURL((__bridge CFStringRef)_string));
    return [NSBundle bundleWithURL:bundleURL];
}

- (NSArray *)conformedTypes {
    NSArray *conformedTypeIdentifier = _declaration[(__bridge NSString *)kUTTypeConformsToKey];
    NSMutableArray *types = [NSMutableArray arrayWithCapacity:[conformedTypeIdentifier count]];
    for (NSString *type in types) {
        GXTypeIdentifier *identifier = [GXTypeIdentifier typeIdentifierWithString:type];
        if (identifier != nil) {
            [types addObject:identifier];
        }
    }
    return conformedTypeIdentifier;
}

- (NSURL *)referenceURL {
    NSString *URLString = _declaration[(__bridge NSString *)kUTTypeReferenceURLKey];
    if (URLString != nil) {
        return [NSURL URLWithString:URLString];
    }
    return nil;
}

- (NSString *)version {
    return _declaration[(__bridge NSString *)kUTTypeVersionKey];
}

- (BOOL)isEqualToTypeIdentifier:(GXTypeIdentifier *)typeIdentifier {
    return UTTypeEqual((__bridge CFStringRef)_string, (__bridge CFStringRef)typeIdentifier->_string);
}

- (BOOL)conformsToTypeIdentifier:(GXTypeIdentifier *)typeIdentifier {
    return UTTypeConformsTo((__bridge CFStringRef)_string, (__bridge CFStringRef)typeIdentifier->_string);
}

- (NSString *)preferredTagForClass:(NSString *)tagClass {
    return CFBridgingRelease(UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)_string, (__bridge CFStringRef)tagClass));
}

@end
