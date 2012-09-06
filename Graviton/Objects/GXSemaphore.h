//
//  GXSemaphore.h
//  Graviton
//
//  Created by Logan Collins on 9/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXSemaphore : NSObject

+ (GXSemaphore *)semaphore;
+ (GXSemaphore *)semaphoreWithValue:(NSUInteger)value;

- (id)initWithValue:(NSUInteger)value;

- (void)wait;
- (void)signal;

@end
