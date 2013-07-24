//
//  NSTimer+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 7/23/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "NSTimer+GravitonAdditions.h"


@implementation NSTimer (GravitonAdditions)

#if !TARGET_OS_IPHONE

+ (NSTimer *)gx_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo tolerance:(NSTimeInterval)tolerance {
    NSTimer *timer = [self timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [timer gx_setTolerance:tolerance];
    return timer;
}

+ (NSTimer *)gx_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo tolerance:(NSTimeInterval)tolerance {
    NSTimer *timer = [self scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [timer gx_setTolerance:tolerance];
    return timer;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (NSTimeInterval)gx_tolerance {
    if ([self respondsToSelector:@selector(tolerance)]) {
        return (NSTimeInterval)[(NSNumber *)[self performSelector:@selector(tolerance)] doubleValue];
    }
    return (NSTimeInterval)0.0;
}

- (void)gx_setTolerance:(NSTimeInterval)tolerance {
    if ([self respondsToSelector:@selector(setTolerance:)]) {
        (void)[self performSelector:@selector(setTolerance:) withObject:@(tolerance)];
    }
}
#pragma clang diagnostic pop

#endif

@end
