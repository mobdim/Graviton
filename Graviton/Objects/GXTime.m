//
//  GXTime.m
//  Graviton
//
//  Created by Logan Collins on 8/17/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXTime.h"


@interface GXTime ()

- (id)initWithTimeInterval:(NSTimeInterval)timeInterval;

@property (readwrite) NSTimeInterval timeInterval;

@end


@interface NSDate (GXTimePrivateAdditions)

- (NSDate *)gx_dateByRemovingTimeComponents;

@end


@implementation GXTime {
    NSTimeInterval _timeInterval;
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

+ (GXTime *)timeWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds {
    return [self timeWithHours:hours minutes:minutes seconds:seconds milliseconds:0];
}

+ (GXTime *)timeWithHours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds milliseconds:(NSUInteger)milliseconds {
    while (milliseconds > 1000) {
        milliseconds -= 1000;
        seconds++;
    }
    while (seconds > 60) {
        seconds -= 60;
        minutes++;
    }
    while (minutes > 60) {
        minutes -= 60;
        hours++;
    }
    hours = hours % 24;
    
    CGFloat timeInterval = (CGFloat)((hours * 3600) + (minutes * 60) + seconds);
    timeInterval += (milliseconds / 1000);
    
    return [[self alloc] initWithTimeInterval:timeInterval];
}

- (id)init {
    NSDate *date = [NSDate date];
    NSDate *baseDate = [date gx_dateByRemovingTimeComponents];
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
        self.timeInterval = [aDecoder decodeDoubleForKey:@"GXTimeInterval"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.timeInterval forKey:@"GXTimeInterval"];
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

- (GXTime *)timeByAddingTimeInterval:(NSTimeInterval)seconds {
    while (seconds > 86400.0) {
        seconds -= 86400.0;
    }
    while (seconds < -86400.0) {
        seconds += 86400.0;
    }
    if (seconds < 0.0) {
        NSTimeInterval timeInterval = (_timeInterval - seconds);
        if (timeInterval < 0.0) {
            timeInterval = 86400.0 - timeInterval;
        }
        return [[GXTime alloc] initWithTimeInterval:timeInterval];
    }
    if (_timeInterval + seconds >= 86400.0) {
        NSTimeInterval timeInterval = 86400.0 - (_timeInterval + seconds);
        return [[GXTime alloc] initWithTimeInterval:timeInterval];
    }
    else {
        return [[GXTime alloc] initWithTimeInterval:_timeInterval + seconds];
    }
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

@end


@implementation NSDate (GXTimeAdditions)

- (GXTime *)GXTime {
    NSDate *baseDate = [self gx_dateByRemovingTimeComponents];
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:baseDate];
    return [[GXTime alloc] initWithTimeInterval:timeInterval];
}

- (NSDate *)gx_dateByRemovingTimeComponents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    return [calendar dateFromComponents:components];
}

@end
