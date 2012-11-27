//
//  GXObservation.m
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXObservation.h"
#import "GXObservation_Private.h"

#import "GXObservation.h"
#import "GXObjectObservation.h"
#import "GXBlockObservation.h"


@implementation GXObservationCenter {
    NSMutableDictionary *_observations;
}

+ (GXObservationCenter *)defaultCenter {
    static GXObservationCenter *defaultCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [self new];
    });
    return defaultCenter;
}

- (id)init {
    self = [super init];
    if (self) {
        _observations = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    for (NSString *key in [_observations keyEnumerator]) {
        GXObservation *observation = [_observations objectForKey:key];
        [observation unregister];
    }
}


#pragma mark -
#pragma mark Observers

- (NSString *)keyForObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath {
    return [NSString stringWithFormat:@"%p:%p:%@", observer, object, keyPath];
}

- (void)addObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath selector:(SEL)selector options:(NSKeyValueObservingOptions)options {
    NSString *key = [self keyForObserver:observer object:object keyPath:keyPath];
    GXObjectObservation *observation = [_observations objectForKey:key];
    if (observation == nil) {
        observation = [GXObjectObservation observationWithObserver:observer object:object keyPath:keyPath selector:selector options:options];
        [_observations setObject:observation forKey:key];
    }
}

- (id)addObserverForObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *change))block {
    if (block == nil) {
        return nil;
    }
    
    NSString *key = [self keyForObserver:block object:object keyPath:keyPath];
    GXBlockObservation *observation = [_observations objectForKey:key];
    if (observation == nil) {
        observation = [GXBlockObservation observationWithObject:object keyPath:keyPath options:options block:block];
        [_observations setObject:observation forKey:key];
    }
    return observation;
}

- (void)removeObserver:(id)observer {
    [self removeObserver:observer object:nil keyPath:nil];
}

- (void)removeObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath {
    id observerObject = observer;
    if ([observer isKindOfClass:[GXBlockObservation class]]) {
        observerObject = [observer block];
    }
    
    NSString *key = [self keyForObserver:observerObject object:object keyPath:keyPath];
    GXObservation *observation = [_observations objectForKey:key];
    [observation unregister];
    [_observations removeObjectForKey:key];
}

@end


@implementation GXObservation

- (void)unregister {
    // no-op
}

@end
