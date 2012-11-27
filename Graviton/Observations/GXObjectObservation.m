//
//  GXObjectObservation.m
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXObjectObservation.h"


static NSString * const GXObjectObservationContext = @"GXObjectObservationContext";


@implementation GXObjectObservation

@synthesize observer=_observer;
@synthesize object=_object;
@synthesize keyPath=_keyPath;
@synthesize selector=_selector;
@synthesize options=_options;

+ (GXObjectObservation *)observationWithObserver:(id)observer
                                             object:(id)object
                                            keyPath:(NSString *)keyPath
                                           selector:(SEL)selector
                                            options:(NSKeyValueObservingOptions)options {
    return [[self alloc] initWithObserver:observer object:object keyPath:keyPath selector:selector options:options];
}

- (id)initWithObserver:(id)observer
                object:(id)object
               keyPath:(NSString *)keyPath
              selector:(SEL)selector
               options:(NSKeyValueObservingOptions)options {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.object = object;
        self.keyPath = keyPath;
        self.selector = selector;
        self.options = options;
        
        [self.object addObserver:self.observer forKeyPath:self.keyPath options:self.options context:(__bridge void *)GXObjectObservationContext];
    }
    return self;
}

- (void)unregister {
    [self.object removeObserver:self.observer forKeyPath:self.keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)GXObjectObservationContext) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.observer performSelector:self.selector withObject:change];
#pragma clang diagnostic pop
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
