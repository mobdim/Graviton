//
//  GXObjectKVOObservation.m
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXObjectKVOObservation.h"
#import "GXObjectKVOObservation_Private.h"


static NSString * const GXObjectKVOObservationContext = @"GXObjectKVOObservationContext";


@implementation GXObjectKVOObservation

@synthesize observer=_observer;
@synthesize object=_object;
@synthesize keyPath=_keyPath;
@synthesize selector=_selector;
@synthesize options=_options;
@synthesize userInfo=_userInfo;

+ (GXObjectKVOObservation *)observationWithObserver:(id)observer
                                             object:(id)object
                                            keyPath:(NSString *)keyPath
                                           selector:(SEL)selector
                                            options:(NSKeyValueObservingOptions)options
                                           userInfo:(NSDictionary *)userInfo {
    return [[self alloc] initWithObserver:observer object:object keyPath:keyPath selector:selector options:options userInfo:userInfo];
}

- (id)initWithObserver:(id)observer
                object:(id)object
               keyPath:(NSString *)keyPath
              selector:(SEL)selector
               options:(NSKeyValueObservingOptions)options
              userInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.object = object;
        self.keyPath = keyPath;
        self.selector = selector;
        self.options = options;
        self.userInfo = userInfo;
        
        [self.object addObserver:self.observer forKeyPath:self.keyPath options:self.options context:(__bridge void *)GXObjectKVOObservationContext];
    }
    return self;
}

- (void)unregister {
    [self.object removeObserver:self.observer forKeyPath:self.keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)GXObjectKVOObservationContext) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.observer performSelector:self.selector withObject:change];
#pragma clang diagnostic pop
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
