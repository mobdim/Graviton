//
//  NSTimer+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 7/23/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (GravitonAdditions)

#if !TARGET_OS_IPHONE
+ (NSTimer *)gx_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo tolerance:(NSTimeInterval)tolerance;
+ (NSTimer *)gx_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo tolerance:(NSTimeInterval)tolerance;

- (NSTimeInterval)gx_tolerance;
- (void)gx_setTolerance:(NSTimeInterval)tolerance;
#endif

@end
