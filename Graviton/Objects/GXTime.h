//
//  GXTime.h
//  Graviton
//
//  Created by Logan Collins on 8/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXTime : NSObject <NSCopying, NSSecureCoding>

+ (GXTime *)time;
+ (GXTime *)midnight;
+ (GXTime *)timeWithTimeIntervalSinceNow:(NSTimeInterval)seconds;
+ (GXTime *)timeWithTimeIntervalSinceMidnight:(NSTimeInterval)seconds;
+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second microsecond:(NSUInteger)microsecond;

@property (nonatomic, readonly) NSUInteger hour;
@property (nonatomic, readonly) NSUInteger minute;
@property (nonatomic, readonly) NSUInteger second;
@property (nonatomic, readonly) NSUInteger microsecond;

- (BOOL)isEqualToTime:(GXTime *)anotherTime;
- (NSComparisonResult)compare:(GXTime *)anotherTime;

@property (nonatomic, readonly) NSTimeInterval timeIntervalSinceMidnight;

- (NSTimeInterval)timeIntervalSinceTime:(GXTime *)anotherTime;

- (GXTime *)timeByAddingTimeInterval:(NSTimeInterval)seconds;

@end


@interface NSDate (GXTimeAdditions)

+ (NSDate *)dateWithGXTime:(GXTime *)time;
- (GXTime *)GXTime;

@end


@interface NSDateFormatter (GXTimeAdditions)

+ (NSString *)localizedStringFromGXTime:(GXTime *)time timeStyle:(NSDateFormatterStyle)tstyle;
- (NSString *)stringFromGXTime:(GXTime *)time;
- (GXTime *)GXTimeFromString:(NSString *)string;

@end
