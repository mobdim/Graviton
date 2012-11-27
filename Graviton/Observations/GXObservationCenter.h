//
//  GXObservationCenter.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXObservationCenter : NSObject

+ (GXObservationCenter *)defaultCenter;

- (void)addObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath selector:(SEL)selector options:(NSKeyValueObservingOptions)options;
- (id)addObserverForObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(void (^)(NSDictionary *change))block;

- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer object:(id)object keyPath:(NSString *)keyPath;

@end
