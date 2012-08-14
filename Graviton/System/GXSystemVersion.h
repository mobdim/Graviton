//
//  GXSystemVersion.h
//  Graviton
//
//  Created by Logan Collins on 4/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


#if !TARGET_OS_IPHONE

/*!
 * @class GXSystemVersion
 * @abstract Object representation of a system version
 */
@interface GXSystemVersion : NSObject <NSCopying>

/*!
 * @method currentSystemVersion
 * @abstract Gets the current system version
 *
 * @result An GXSystemVersion object
 */
+ (GXSystemVersion *)currentSystemVersion;

/*!
 * @method systemVersionWithString:
 * @abstract Creates a new system version from a string
 *
 * @param aString
 * The string containing the version
 *
 * @result An GXSystemVersion object
 */
+ (GXSystemVersion *)systemVersionWithString:(NSString *)aString;


/*!
 * @property string
 * @abstract The string representation of the version
 *
 * @result An NSString object
 */
@property (copy, readonly) NSString *string;


/*!
 * @method compare:
 * @abstract Compares the receiver to another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result An NSComparisonResult value
 */
- (NSComparisonResult)compare:(GXSystemVersion *)aVersion;

/*!
 * @method isEqualToSystemVersion:
 * @abstract Determines if the receiver is equal to another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result A BOOL value
 */
- (BOOL)isEqualToSystemVersion:(GXSystemVersion *)aVersion;

/*!
 * @method isLessThanOrEqualToSystemVersion:
 * @abstract Determines if the receiver is less than or equal to another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result A BOOL value
 */
- (BOOL)isLessThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion;

/*!
 * @method isLessThanSystemVersion:
 * @abstract Determines if the receiver is less than another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result A BOOL value
 */
- (BOOL)isLessThanSystemVersion:(GXSystemVersion *)aVersion;

/*!
 * @method isGreaterThanOrEqualToSystemVersion:
 * @abstract Determines if the receiver is greater than or equal to another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result A BOOL value
 */
- (BOOL)isGreaterThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion;

/*!
 * @method isGreaterThanSystemVersion:
 * @abstract Determines if the receiver is greater than another system version
 *
 * @param aVersion
 * The second system version to compare
 *
 * @result A BOOL value
 */
- (BOOL)isGreaterThanSystemVersion:(GXSystemVersion *)aVersion;


/*!
 * @method isEqualToString:
 * @abstract Determines if the receiver is equal to a system version string
 *
 * @param string
 * The system version string to compare
 *
 * @result A BOOL value
 */
- (BOOL)isEqualToString:(NSString *)string;

/*!
 * @method isLessThanOrEqualToString:
 * @abstract Determines if the receiver is less than or equal to a system version string
 *
 * @param string
 * The system version string to compare
 *
 * @result A BOOL value
 */
- (BOOL)isLessThanOrEqualToString:(NSString *)string;

/*!
 * @method isLessThanString:
 * @abstract Determines if the receiver is less than a system version string
 *
 * @param string
 * The system version string to compare
 *
 * @result A BOOL value
 */
- (BOOL)isLessThanString:(NSString *)string;

/*!
 * @method isGreaterThanOrEqualToString:
 * @abstract Determines if the receiver is greater than or equal to a system version string
 *
 * @param string
 * The system version string to compare
 *
 * @result A BOOL value
 */
- (BOOL)isGreaterThanOrEqualToString:(NSString *)string;

/*!
 * @method isGreaterThanString:
 * @abstract Determines if the receiver is greater than a system version string
 *
 * @param string
 * The system version string to compare
 *
 * @result A BOOL value
 */
- (BOOL)isGreaterThanString:(NSString *)string;

@end

#endif
