//
//  GXObjectKVOObservation.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXKVOObservation.h>


@interface GXObjectKVOObservation : GXKVOObservation

+ (GXObjectKVOObservation *)observationWithObserver:(id)observer
                                             object:(id)object
                                            keyPath:(NSString *)keyPath
                                           selector:(SEL)selector
                                            options:(NSKeyValueObservingOptions)options;

- (id)initWithObserver:(id)observer
                object:(id)object
               keyPath:(NSString *)keyPath
              selector:(SEL)selector
               options:(NSKeyValueObservingOptions)options;

@property (weak) id observer;
@property (weak) id object;
@property (copy) NSString *keyPath;
@property (unsafe_unretained) SEL selector;
@property (assign) NSKeyValueObservingOptions options;

@end
