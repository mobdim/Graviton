//
//  GXTime.h
//  Graviton
//
//  Created by Logan Collins on 8/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXTime : NSObject
#if TARGET_OS_IPHONE
<NSCoding, NSCopying>
#else
<NSCopying, NSSecureCoding>
#endif

+ (GXTime *)time;
+ (GXTime *)midnight;
+ (GXTime *)timeWithTimeIntervalSinceNow:(NSTimeInterval)seconds;
+ (GXTime *)timeWithTimeIntervalSinceMidnight:(NSTimeInterval)seconds;
+ (GXTime *)timeWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
+ (GXTime *)timeWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds milliseconds:(NSUInteger)milliseconds;

- (BOOL)isEqualToTime:(GXTime *)anotherTime;
- (NSComparisonResult)compare:(GXTime *)anotherTime;

- (GXTime *)timeByAddingTimeInterval:(NSTimeInterval)seconds;
- (NSTimeInterval)timeIntervalSinceTime:(GXTime *)anotherTime;

@end


@interface NSDate (GXTimeAdditions)

- (GXTime *)GXTime;

@end
