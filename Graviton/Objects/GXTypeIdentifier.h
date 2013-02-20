//
//  GXTypeIdentifier.h
//  Graviton
//
//  Created by Logan Collins on 11/19/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


@interface GXTypeIdentifier : NSObject <NSCopying, NSSecureCoding>

+ (GXTypeIdentifier *)typeIdentifierWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;

+ (GXTypeIdentifier *)typeIdentifierWithTag:(NSString *)tag tagClass:(NSString *)tagClass;

@property (nonatomic, strong, readonly) NSString *string;

@property (nonatomic, strong, readonly) NSBundle *bundle;
@property (nonatomic, strong, readonly) NSDictionary *infoDictionary;

@property (nonatomic, copy, readonly) NSString *localizedDescription;
@property (nonatomic, copy, readonly) NSArray *conformedTypes;
@property (nonatomic, copy, readonly) NSURL *referenceURL;
@property (nonatomic, copy, readonly) NSString *version;

- (BOOL)isEqualToTypeIdentifier:(GXTypeIdentifier *)typeIdentifier;
- (BOOL)conformsToTypeIdentifier:(GXTypeIdentifier *)typeIdentifier;

- (NSString *)preferredTagForClass:(NSString *)tagClass;

@end


GRAVITON_EXTERN NSString * const GXTagClassFilenameExtension;
GRAVITON_EXTERN NSString * const GXTagClassMIMEType;
GRAVITON_EXTERN NSString * const GXTagClassNSPboardType;
GRAVITON_EXTERN NSString * const GXTagClassOSType;
