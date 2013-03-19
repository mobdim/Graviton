//
//  GXVersion.h
//  Graviton
//
//  Created by Logan Collins on 6/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


typedef GRAVITON_ENUM(NSUInteger, GXVersionReleaseType) {
    GXVersionReleaseTypeFinal = 0,
    GXVersionReleaseTypeAlpha,
    GXVersionReleaseTypeBeta,
};


@interface GXVersion : NSObject <NSCopying>

+ (GXVersion *)versionWithString:(NSString *)string;
+ (GXVersion *)systemVersion;

@property (nonatomic, copy, readonly) NSString *string;
@property (nonatomic, readonly) GXVersionReleaseType releaseType;

- (NSComparisonResult)compare:(GXVersion *)aVersion;

- (BOOL)isEqualToVersion:(GXVersion *)aVersion;
- (BOOL)isLessThanOrEqualToVersion:(GXVersion *)aVersion;
- (BOOL)isLessThanVersion:(GXVersion *)aVersion;
- (BOOL)isGreaterThanOrEqualToVersion:(GXVersion *)aVersion;
- (BOOL)isGreaterThanVersion:(GXVersion *)aVersion;

@end


@interface NSBundle (GXVersion)

- (GXVersion *)GXVersion;

@end
