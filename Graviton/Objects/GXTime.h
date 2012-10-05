//
//  GXTime.h
//  Graviton
//
//  Created by Logan Collins on 8/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#endif


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
+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second microsecond:(NSUInteger)microsecond;

@property (readonly) NSUInteger hour;
@property (readonly) NSUInteger minute;
@property (readonly) NSUInteger second;
@property (readonly) NSUInteger microsecond;

- (BOOL)isEqualToTime:(GXTime *)anotherTime;
- (NSComparisonResult)compare:(GXTime *)anotherTime;

@property (readonly) NSTimeInterval timeIntervalSinceMidnight;

- (NSTimeInterval)timeIntervalSinceTime:(GXTime *)anotherTime;

- (GXTime *)timeByAddingTimeInterval:(NSTimeInterval)seconds;

@end


@interface NSDate (GXTimeAdditions)

- (GXTime *)GXTime;

@end
