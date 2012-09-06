//
//  GXSemaphore.m
//  Graviton
//
//  Created by Logan Collins on 9/6/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXSemaphore.h"


@implementation GXSemaphore {
    dispatch_semaphore_t _semaphore;
}

+ (GXSemaphore *)semaphore {
    return [[self alloc] init];
}

+ (GXSemaphore *)semaphoreWithValue:(NSUInteger)value {
    return [[self alloc] initWithValue:value];
}

- (id)init {
    return [self initWithValue:0];
}

- (id)initWithValue:(NSUInteger)value {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(value);
    }
    return self;
}

- (void)dealloc {
    dispatch_release(_semaphore);
}

- (void)wait {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)signal {
    dispatch_semaphore_signal(_semaphore);
}

@end
