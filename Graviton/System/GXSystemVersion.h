//
//  GXSystemVersion.h
//  Graviton
//
//  Created by Logan Collins on 4/16/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class GXSystemVersion
 * @abstract Object representation of a system version
 */
@interface GXSystemVersion : NSObject <NSCopying> {
	NSString *_string;
}

+ (GXSystemVersion *)currentSystemVersion;
+ (GXSystemVersion *)systemVersionWithString:(NSString *)aString;

@property (copy, readonly) NSString *string;

- (NSComparisonResult)compare:(GXSystemVersion *)aVersion;

- (BOOL)isEqualToSystemVersion:(GXSystemVersion *)aVersion;
- (BOOL)isLessThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion;
- (BOOL)isLessThanSystemVersion:(GXSystemVersion *)aVersion;
- (BOOL)isGreaterThanOrEqualToSystemVersion:(GXSystemVersion *)aVersion;
- (BOOL)isGreaterThanSystemVersion:(GXSystemVersion *)aVersion;

- (BOOL)isEqualToString:(NSString *)string;
- (BOOL)isLessThanOrEqualToString:(NSString *)string;
- (BOOL)isLessThanString:(NSString *)string;
- (BOOL)isGreaterThanOrEqualToString:(NSString *)string;
- (BOOL)isGreaterThanString:(NSString *)string;

@end
