//
//  GXVersion.h
//  Graviton
//
//  Created by Logan Collins on 6/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


/*!
 * @enum GXVersionReleaseType
 * @abstract Version release types
 * 
 * @constant GXVersionReleaseTypeFinal     Final release
 * @constant GXVersionReleaseTypeAlpha     Alpha release
 * @constant GXVersionReleaseTypeBeta      Beta release
 */
typedef GRAVITON_ENUM(NSUInteger, GXVersionReleaseType) {
    GXVersionReleaseTypeFinal = 0,
    GXVersionReleaseTypeAlpha,
    GXVersionReleaseTypeBeta,
};


/*!
 * @class GXVersion
 * @abstract Object representation of a CoreFoundation-style version string
 */
@interface GXVersion : NSObject <NSCopying>

/*!
 * @method versionWithString:
 * @abstract Creates a new version from a string
 * 
 * @param string
 * The string containing the version
 * 
 * @result An GXVersion object
 */
+ (GXVersion *)versionWithString:(NSString *)string;

/*!
 * @method systemVersion
 * @abstract Gets the current version of OS X.
 * 
 * @result A GXVersion object
 */
+ (GXVersion *)systemVersion;


/*!
 * @property string
 * @abstract The string representation of the version
 * 
 * @result An NSString object
 */
@property (nonatomic, copy, readonly) NSString *string;

/*!
 * @property releaseType
 * @abstract The version release type
 * 
 * @result An GXVersionReleaseType value
 */
@property (nonatomic, readonly) GXVersionReleaseType releaseType;


/*!
 * @method compare:
 * @abstract Compares the receiver to another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result An NSComparisonResult value
 */
- (NSComparisonResult)compare:(GXVersion *)aVersion;

/*!
 * @method isEqualToVersion:
 * @abstract Determines if the receiver is equal to another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result A BOOL value
 */
- (BOOL)isEqualToVersion:(GXVersion *)aVersion;

/*!
 * @method isLessThanOrEqualToVersion:
 * @abstract Determines if the receiver is less than or equal to another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result A BOOL value
 */
- (BOOL)isLessThanOrEqualToVersion:(GXVersion *)aVersion;

/*!
 * @method isLessThanVersion:
 * @abstract Determines if the receiver is less than another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result A BOOL value
 */
- (BOOL)isLessThanVersion:(GXVersion *)aVersion;

/*!
 * @method isGreaterThanOrEqualToVersion:
 * @abstract Determines if the receiver is greater than or equal to another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result A BOOL value
 */
- (BOOL)isGreaterThanOrEqualToVersion:(GXVersion *)aVersion;

/*!
 * @method isGreaterThanVersion:
 * @abstract Determines if the receiver is greater than another version
 * 
 * @param aVersion
 * The second version to compare
 * 
 * @result A BOOL value
 */
- (BOOL)isGreaterThanVersion:(GXVersion *)aVersion;

@end


/*!
 * @category NSBundle(GXVersion)
 * @abstract Additions to NSBundle for GXVersion
 */
@interface NSBundle (GXVersion)

/*!
 * @method GXVersion
 * @abstract Gets the bundle version as a GXVersion object
 * 
 * @result A GXVersion object, or nil
 */
- (GXVersion *)GXVersion;

@end
