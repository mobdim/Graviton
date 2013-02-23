//
//  NSObject+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 3/20/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSObject+GravitonAdditions.h"

#import <objc/runtime.h>


@interface GXObjectAssociationWeakProxy : NSObject

@property (nonatomic, weak) id object;

@end


@interface NSObject (GravitonPrivateAdditions)

- (void)gx_performBlock:(void (^)(void))block;

@end


@implementation NSObject (GravitonAdditions)


#pragma mark -
#pragma mark Blocks

- (void)gx_performBlock:(void (^)(void))block {
    block();
}

- (void)gx_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block {
    [self performSelector:@selector(gx_performBlock:) withObject:[block copy] afterDelay:delay];
}


#pragma mark -
#pragma mark Methods

+ (void)gx_duplicateClassMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector {
    Method method = class_getInstanceMethod(self, newSelector);
    if (method == NULL) {
        Method oldMethod = class_getInstanceMethod(self, selector);
        if (oldMethod != NULL) {
            class_addMethod(self, selector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }
        else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The class \"%@\" does not have a class method with the selector \"%@\"", self, NSStringFromSelector(selector)] userInfo:nil];
        }
    }
}

+ (void)gx_duplicateInstanceMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector {
    Class metaclass = object_getClass(self);
    Method method = class_getClassMethod(self, newSelector);
    if (method == NULL) {
        Method oldMethod = class_getClassMethod(self, selector);
        if (oldMethod != NULL) {
            class_addMethod(metaclass, selector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }
        else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The class \"%@\" does not have an instance method with the selector \"%@\"", self, NSStringFromSelector(selector)] userInfo:nil];
        }
    }
}


#pragma mark -
#pragma mark Object Associations

- (id)gx_associatedObjectForKey:(id <NSCopying>)key {
    id value = objc_getAssociatedObject(self, (__bridge void *)key);
    if ([value isKindOfClass:[GXObjectAssociationWeakProxy class]]) {
        value = [value object];
    }
    return value;
}

- (void)gx_setAssociatedObject:(id)obj forKey:(id <NSCopying>)key policy:(GXAssociationPolicy)policy {
    id value = obj;
    objc_AssociationPolicy objcPolicy = OBJC_ASSOCIATION_ASSIGN;
    
    if (policy & GXAssociationPolicyAssign) {
        objcPolicy = OBJC_ASSOCIATION_ASSIGN;
    }
    else if (policy & GXAssociationPolicyStrong) {
        if (policy & GXAssociationPolicyNonatomic) {
            objcPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
        }
        else {
            objcPolicy = OBJC_ASSOCIATION_RETAIN;
        }
    }
    else if (policy & GXAssociationPolicyCopy) {
        if (policy & GXAssociationPolicyNonatomic) {
            objcPolicy = OBJC_ASSOCIATION_COPY_NONATOMIC;
        }
        else {
            objcPolicy = OBJC_ASSOCIATION_COPY;
        }
    }
    else if ((policy & GXAssociationPolicyWeak) && (value != nil)) {
        // Objective-C Associations don't support zeroing-weak references, so we use a proxy object that does.
        GXObjectAssociationWeakProxy *proxy = [[GXObjectAssociationWeakProxy alloc] init];
        proxy.object = value;
        value = proxy;
        
        if (policy & GXAssociationPolicyNonatomic) {
            objcPolicy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
        }
        else {
            objcPolicy = OBJC_ASSOCIATION_RETAIN;
        }
    }
    
    objc_setAssociatedObject(self, (__bridge void *)key, value, objcPolicy);
}


#pragma mark -
#pragma mark Key-Value Observation

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


@implementation GXObjectAssociationWeakProxy

@end
