//
//  GXBlockKVOObservation.m
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXBlockKVOObservation.h"
#import "GXBlockKVOObservation_Private.h"


static NSString * const GXBlockKVOObservationContext = @"GXBlockKVOObservationContext";


@implementation GXBlockKVOObservation

@synthesize object=_object;
@synthesize keyPath=_keyPath;
@synthesize options=_options;
@synthesize block=_block;

+ (GXBlockKVOObservation *)observationWithObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *))block {
    return [[self alloc] initWithObject:object keyPath:keyPath options:options block:block];
}

- (id)initWithObject:(id)object
             keyPath:(NSString *)keyPath
             options:(NSKeyValueObservingOptions)options
               block:(void (^)(NSDictionary *change))block {
    self = [super init];
    if (self) {
        self.object = object;
        self.keyPath = keyPath;
        self.options = options;
        self.block = block;
        
        [self.object addObserver:self forKeyPath:self.keyPath options:self.options context:(__bridge void *)GXBlockKVOObservationContext];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void *)GXBlockKVOObservationContext) {
        if (self.block != nil) {
            self.block(change);
        }
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)unregister {
    [self.object removeObserver:self forKeyPath:self.keyPath];
}

@end
