//
//  NSObject+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 3/20/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


typedef GRAVITON_ENUM(NSUInteger, GXAssociationPolicy) {
    GXAssociationPolicyAssign = (1 << 0),       // Unretained reference (equivalent to unsafe_unretained)
    GXAssociationPolicyStrong = (1 << 1),       // Strong reference to the object (equivalent to strong)
    GXAssociationPolicyCopy = (1 << 2),         // Copy the object (equivalent to copy)
    GXAssociationPolicyWeak = (1 << 3),         // Zeroing-weak reference (equivalent to weak)
    
    GXAssociationPolicyNonatomic = (1 << 10),   // Assign without using atomic guards (equivalent to nonatomic)
};


typedef void (^GXKeyValueObservingBlock)(id object, NSString *keyPath, NSDictionary *change);


@interface NSObject (GravitonAdditions)

- (void)gx_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block;

+ (BOOL)gx_hasClassMethodWithSelector:(SEL)selector;
+ (BOOL)gx_hasInstanceMethodWithSelector:(SEL)selector;

+ (void)gx_duplicateClassMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector;
+ (void)gx_duplicateInstanceMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector;

- (id)gx_associatedObjectForKey:(id <NSCopying>)key;
- (void)gx_setAssociatedObject:(id)obj forKey:(id <NSCopying>)key policy:(GXAssociationPolicy)policy;

- (void)gx_addObserver:(id)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(GXKeyValueObservingBlock)block;
- (void)gx_removeObserver:(id)observer forKeyPath:(NSString *)keyPath;

@end
