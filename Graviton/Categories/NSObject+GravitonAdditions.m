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

@property (weak) id object;

@end


@interface GXKeyValueObservingProxy : NSObject

- (id)initWithObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(GXKeyValueObservingBlock)block;

@property (weak) id object;
@property (copy) NSString *keyPath;
@property NSKeyValueObservingOptions options;
@property (copy) GXKeyValueObservingBlock block;

- (void)registerObservation;
- (void)unregisterObservation;

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

+ (BOOL)gx_hasClassMethodWithSelector:(SEL)selector {
	Class metaclass = object_getClass(self);
	unsigned int methodCount;
	Method *methods = class_copyMethodList(metaclass, &methodCount);
	if (methods != nil) {
		for (unsigned int i=0; i<methodCount; i++) {
			Method method = methods[i];
			if (method_getName(method) == selector) {
				return YES;
			}
		}
		free(methods);
	}
	return NO;
}

+ (BOOL)gx_hasInstanceMethodWithSelector:(SEL)selector {
	unsigned int methodCount;
	Method *methods = class_copyMethodList(self, &methodCount);
	if (methods != nil) {
		for (unsigned int i=0; i<methodCount; i++) {
			Method method = methods[i];
			if (method_getName(method) == selector) {
				return YES;
			}
		}
		free(methods);
	}
	return NO;
}

+ (void)gx_duplicateClassMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector {
    if (![self gx_hasClassMethodWithSelector:newSelector]) {
        Method oldMethod = class_getClassMethod(self, selector);
        Class metaclass = object_getClass(self);
        if (oldMethod != NULL) {
            class_addMethod(metaclass, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }
        else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The class \"%@\" does not have a class method with the selector \"%@\"", self, NSStringFromSelector(selector)] userInfo:nil];
        }
    }
}

+ (void)gx_duplicateInstanceMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector {
    if (![self gx_hasInstanceMethodWithSelector:newSelector]) {
        Method oldMethod = class_getInstanceMethod(self, selector);
        if (oldMethod != NULL) {
            class_addMethod(self, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
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
#pragma mark Key Value Observation

static NSString * GXObjectKVOObservationsKey = @"GXObjectKVOObservations";

- (void)gx_addObserver:(id)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(GXKeyValueObservingBlock)block {
    NSParameterAssert(observer != nil);
    NSParameterAssert(keyPath != nil);
    NSParameterAssert(block != nil);
    
    NSMapTable *observationsByObserver = [self gx_associatedObjectForKey:GXObjectKVOObservationsKey];
    if (observationsByObserver == nil) {
        observationsByObserver = [NSMapTable weakToStrongObjectsMapTable];
        [self gx_setAssociatedObject:observationsByObserver forKey:GXObjectKVOObservationsKey policy:GXAssociationPolicyStrong];
    }
    
    NSMutableDictionary *observations = [observationsByObserver objectForKey:observer];
    if (observations == nil) {
        observations = [NSMutableDictionary dictionary];
        [observationsByObserver setObject:observations forKey:observer];
    }
    
    if ([observations objectForKey:keyPath] != nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Observer %@ is already registered for the key path \"%@\" of object %@", observer, keyPath, self] userInfo:nil];
    }
    
    GXKeyValueObservingProxy *proxy = [[GXKeyValueObservingProxy alloc] initWithObject:self keyPath:keyPath options:options block:block];
    [observations setObject:proxy forKey:keyPath];
    
    [proxy registerObservation];
}

- (void)gx_removeObserver:(id)observer forKeyPath:(NSString *)keyPath {
    NSParameterAssert(observer != nil);
    
    NSMapTable *observationsByObserver = [self gx_associatedObjectForKey:GXObjectKVOObservationsKey];
    if (observationsByObserver == nil) {
        observationsByObserver = [NSMapTable weakToStrongObjectsMapTable];
        [self gx_setAssociatedObject:observationsByObserver forKey:GXObjectKVOObservationsKey policy:GXAssociationPolicyStrong];
    }
    
    NSMutableDictionary *observations = [observationsByObserver objectForKey:observer];
    if (observations == nil) {
        observations = [NSMutableDictionary dictionary];
        [observationsByObserver setObject:observations forKey:observer];
    }
    
    if (keyPath != nil) {
        // Remove keypath observation
        if ([observations objectForKey:keyPath] == nil) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Observer %@ is not registered for the key path \"%@\" of object %@", observer, keyPath, self] userInfo:nil];
        }
        
//        GXKeyValueObservingProxy *proxy = [observations objectForKey:keyPath];
//        [proxy unregisterObservation];
        [observations removeObjectForKey:keyPath];
    }
    else {
        // Remove all observations
//        for (NSString *keyPath in observations) {
//            GXKeyValueObservingProxy *proxy = [observations objectForKey:keyPath];
//            [proxy unregisterObservation];
//        }
        [observations removeAllObjects];
    }
}

@end


@implementation GXObjectAssociationWeakProxy

@end


@implementation GXKeyValueObservingProxy

- (id)initWithObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(GXKeyValueObservingBlock)block {
    self = [super init];
    if (self) {
        self.object = object;
        self.keyPath = keyPath;
        self.options = options;
        self.block = block;
    }
    return self;
}

- (void)dealloc {
    [self unregisterObservation];
}

- (void)registerObservation {
    [self.object addObserver:self forKeyPath:self.keyPath options:self.options context:NULL];
}

- (void)unregisterObservation {
    [self.object removeObserver:self forKeyPath:self.keyPath context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    self.block(object, keyPath, change);
}

@end
