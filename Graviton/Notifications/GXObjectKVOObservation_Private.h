//
//  GXObjectKVOObservation_Private.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXObjectKVOObservation.h>


@interface GXObjectKVOObservation ()

- (id)initWithObserver:(id)observer
                object:(id)object
               keyPath:(NSString *)keyPath
              selector:(SEL)selector
               options:(NSKeyValueObservingOptions)options
              userInfo:(NSDictionary *)userInfo;

@property (weak, readwrite) id observer;
@property (weak, readwrite) id object;
@property (copy, readwrite) NSString *keyPath;
@property (assign, readwrite) SEL selector;
@property (assign, readwrite) NSKeyValueObservingOptions options;
@property (copy, readwrite) NSDictionary *userInfo;

@end
