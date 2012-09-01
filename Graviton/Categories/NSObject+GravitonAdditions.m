//
//  NSObject+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 3/20/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSObject+GravitonAdditions.h"

#import <objc/runtime.h>


@interface NSObject (GravitonPrivateAdditions)

- (void)gx_performBlock:(void (^)(void))block;

@end


@implementation NSObject (GravitonAdditions)

- (void)gx_performBlock:(void (^)(void))block {
    block();
}

- (void)gx_performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block {
    [self performSelector:@selector(gx_performBlock:) withObject:[block copy] afterDelay:delay];
}

- (id)gx_associatedObjectForKey:(id <NSCopying>)key {
    return objc_getAssociatedObject(self, (__bridge void *)key);
}

- (void)gx_setAssociatedObject:(id)obj forKey:(id <NSCopying>)key policy:(GXAssociationPolicy)policy {
    objc_setAssociatedObject(self, (__bridge void *)key, obj, (objc_AssociationPolicy)policy);
}

- (void)gx_addObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context {
    for (NSString *keyPath in keyPaths) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)gx_removeObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths {
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:observer forKeyPath:keyPath];
    }
}

- (void)gx_removeObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths context:(void *)context {
    for (NSString *keyPath in keyPaths) {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    }
}

@end
