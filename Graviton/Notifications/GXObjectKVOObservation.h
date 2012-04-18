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
                                            options:(NSKeyValueObservingOptions)options
                                           userInfo:(NSDictionary *)userInfo;

@property (weak, readonly) id observer;
@property (weak, readonly) id object;
@property (copy, readonly) NSString *keyPath;
@property (assign, readonly) SEL selector;
@property (assign, readonly) NSKeyValueObservingOptions options;
@property (copy, readonly) NSDictionary *userInfo;

@end
