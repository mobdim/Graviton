//
//  GXKVONotificationCenter.m
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXKVONotificationCenter.h"

#import "GXKVOObservation.h"
#import "GXObjectKVOObservation.h"
#import "GXBlockKVOObservation.h"


@implementation GXKVONotificationCenter {
    NSMutableDictionary *_observations;
}

+ (GXKVONotificationCenter *)defaultCenter {
    static GXKVONotificationCenter *defaultCenter = nil;
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
        GXKVOObservation *observation = [_observations objectForKey:key];
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
    GXObjectKVOObservation *observation = [_observations objectForKey:key];
    if (observation == nil) {
        observation = [GXObjectKVOObservation observationWithObserver:observer object:object keyPath:keyPath selector:selector options:options];
        [_observations setObject:observation forKey:key];
    }
}

- (id)addObserverForObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *change))block {
    if (block == nil) {
        return nil;
    }
    
    NSString *key = [self keyForObserver:block object:object keyPath:keyPath];
    GXBlockKVOObservation *observation = [_observations objectForKey:key];
    if (observation == nil) {
        observation = [GXBlockKVOObservation observationWithObject:object keyPath:keyPath options:options block:block];
        [_observations setObject:observation forKey:key];
    }
    return observation;
}

- (void)removeObserver:(id)observer {
    [self removeObserver:observer object:nil keyPath:nil];
}

- (void)removeObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath {
    id observerObject = observer;
    if ([observer isKindOfClass:[GXBlockKVOObservation class]]) {
        observerObject = [observer block];
    }
    
    NSString *key = [self keyForObserver:observerObject object:object keyPath:keyPath];
    GXKVOObservation *observation = [_observations objectForKey:key];
    [observation unregister];
    [_observations removeObjectForKey:key];
}

@end
