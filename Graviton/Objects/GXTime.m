//
//  GXTime.m
//  Graviton
//
//  Created by Logan Collins on 8/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXTime.h"

#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
#endif


@interface GXTime ()

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval;

@property (readwrite) NSTimeInterval timeInterval;

- (NSDate *)gx_formattingDate;

@end


static NSCalendar *__formattingCalendar = nil;


@implementation GXTime {
    NSTimeInterval _timeInterval; // since midnight
}

+ (void)initialize {
    if (self == [GXTime class]) {
        __formattingCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (GXTime *)midnight {
    return [[self alloc] initWithTimeInterval:0.0];
}

+ (GXTime *)time {
    return [[self alloc] init];
}

+ (GXTime *)timeWithTimeIntervalSinceNow:(NSTimeInterval)seconds {
    return [[self time] timeByAddingTimeInterval:seconds];
}

+ (GXTime *)timeWithTimeIntervalSinceMidnight:(NSTimeInterval)seconds {
    return [[self midnight] timeByAddingTimeInterval:seconds];
}

+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second {
    return [self timeWithHour:hour minute:minute second:second microsecond:0];
}

+ (GXTime *)timeWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second microsecond:(NSUInteger)microsecond {
    while (microsecond > 1000) {
        microsecond -= 1000;
        second++;
    }
    while (second > 60) {
        second -= 60;
        minute++;
    }
    while (minute > 60) {
        minute -= 60;
        hour++;
    }
    hour = hour % 24;
    
    NSTimeInterval timeInterval = (NSTimeInterval)((hour * 3600) + (minute * 60) + second);
    timeInterval += (microsecond / 1000);
    
    return [[self alloc] initWithTimeInterval:timeInterval];
}

- (id)init {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [__formattingCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *baseDate = [__formattingCalendar dateFromComponents:components];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:baseDate];
    return [self initWithTimeInterval:timeInterval];
}

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval {
    self = [super init];
    if (self) {
        self.timeInterval = timeInterval;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.timeInterval = [aDecoder decodeDoubleForKey:@"timeInterval"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.timeInterval forKey:@"timeInterval"];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GXTime class]]) {
        return [self isEqualToTime:object];
    }
    return NO;
}

- (NSUInteger)hash {
    return [[NSNumber numberWithDouble:_timeInterval] hash];
}

- (BOOL)isEqualToTime:(GXTime *)anotherTime {
    return [self timeInterval] == [anotherTime timeInterval];
}

- (NSComparisonResult)compare:(GXTime *)anotherTime {
    if ([self timeInterval] < [anotherTime timeInterval]) {
        return NSOrderedAscending;
    }
    else if ([self timeInterval] > [anotherTime timeInterval]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p : hour=%ld, minute=%ld, second=%ld, microsecond=%ld>", [self class], self, (unsigned long)[self hour], (unsigned long)[self minute], (unsigned long)[self second], (unsigned long)[self microsecond]];
}

- (NSUInteger)hour {
    return ((NSUInteger)floor(_timeInterval / 3600) % 24);
}

- (NSUInteger)minute {
    return ((NSUInteger)floor(_timeInterval / 60) % 60);
}

- (NSUInteger)second {
    return ((NSUInteger)floor(_timeInterval) % 60);
}

- (NSUInteger)microsecond {
    return ((NSUInteger)floor(_timeInterval * 1000000) % 1000000);
}

- (NSTimeInterval)timeIntervalSinceMidnight {
    return _timeInterval;
}

- (NSTimeInterval)timeIntervalSinceTime:(GXTime *)anotherTime {
    NSTimeInterval anotherTimeInterval = [anotherTime timeInterval];
    if (_timeInterval < anotherTimeInterval) {
        return -(anotherTimeInterval - _timeInterval);
    }
    else {
        return _timeInterval - anotherTimeInterval;
    }
}

- (GXTime *)timeByAddingTimeInterval:(NSTimeInterval)seconds {
    while (seconds > 86400.0) {
        seconds -= 86400.0;
    }
    while (seconds < -86400.0) {
        seconds += 86400.0;
    }
    if (seconds < 0.0) {
        return [[GXTime alloc] initWithTimeInterval:(86400.0 + seconds)];
    }
    if (_timeInterval + seconds >= 86400.0) {
        NSTimeInterval timeInterval = 86400.0 - (_timeInterval + seconds);
        return [[GXTime alloc] initWithTimeInterval:timeInterval];
    }
    else {
        return [[GXTime alloc] initWithTimeInterval:_timeInterval + seconds];
    }
}

- (NSDate *)gx_formattingDate {
    NSDateComponents *components = [__formattingCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *baseDate = [__formattingCalendar dateFromComponents:components];
    NSDate *date = [baseDate dateByAddingTimeInterval:self.timeInterval];
    return date;
}

@end


@implementation NSDate (GXTimeAdditions)

+ (NSDate *)dateWithGXTime:(GXTime *)time {
    return [self dateWithDate:[NSDate date] GXTime:time];
}

+ (NSDate *)dateWithDate:(NSDate *)date GXTime:(GXTime *)time {
    NSDateComponents *components = [__formattingCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *baseDate = [__formattingCalendar dateFromComponents:components];
    return [baseDate dateByAddingTimeInterval:time.timeInterval];
}

- (GXTime *)GXTime {
    NSDateComponents *components = [__formattingCalendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    NSDate *baseDate = [__formattingCalendar dateFromComponents:components];
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:baseDate];
    return [[GXTime alloc] initWithTimeInterval:timeInterval];
}

@end


@implementation NSDateFormatter (GXTimeAdditions)

+ (NSString *)localizedStringFromGXTime:(GXTime *)time timeStyle:(NSDateFormatterStyle)tstyle {
    return [self localizedStringFromDate:[time gx_formattingDate] dateStyle:NSDateFormatterNoStyle timeStyle:tstyle];
}

- (NSString *)stringFromGXTime:(GXTime *)time {
    return [self stringFromDate:[time gx_formattingDate]];
}

- (GXTime *)GXTimeFromString:(NSString *)string {
    return [[self dateFromString:string] GXTime];
}

@end
