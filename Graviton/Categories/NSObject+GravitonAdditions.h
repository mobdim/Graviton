//
//  NSObject+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 3/20/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


/*!
 * @enum GXAssociationPolicy
 * @abstract Object association policies
 * 
 * @constant GXAssociationPolicyAssign              Unretained reference (equivalent to unsafe_unretained)
 * @constant GXAssociationPolicyWeak                Zeroing-weak reference (equivalent to weak)
 * @constant GXAssociationPolicyStrong              Strong reference to the object (equivalent to strong/retain)
 * @constant GXAssociationPolicyCopy                Copy the object (equivalent to copy)
 *
 * @constant GXAssociationPolicyNonatomic           Assign without using atomic guards (equivalent to nonatomic)
 */
typedef GRAVITON_ENUM(NSUInteger, GXAssociationPolicy) {
    GXAssociationPolicyAssign = (1 << 0),
    GXAssociationPolicyStrong = (1 << 1),
    GXAssociationPolicyCopy = (1 << 2),
    GXAssociationPolicyWeak = (1 << 3),
    
    GXAssociationPolicyNonatomic = (1 << 10),
};


@interface NSObject (GravitonAdditions)

/*!
 * @method gx_performAfterDelay:usingBlock:
 * @abstract Invokes a block object after a delay
 * 
 * @param delay
 * The time interval to wait
 * 
 * @param block
 * The block to perform
 * 
 * @discussion
 * This method is tied to the default run loop and is equivalent to -performSelector:withObject:afterDelay:.
 */
- (void)gx_performAfterDelay:(NSTimeInterval)delay usingBlock:(void (^)(void))block;


/*!
 * @method gx_duplicateClassMethodWithSelector:toSelector:
 * @abstract Creates a duplicate of a class method
 *
 * @param selector
 * The selector of the instance method to duplicate
 *
 * @param newSelector
 * The selector of the instance method to create
 *
 * @discussion
 * Using this method allows forwards-compatible addition of methods in a safe manner.
 * If an instance method with the selector already exists, this method does nothing.
 * If the receiver does not have a method with the selector, this method raises an exception.
 */
+ (void)gx_duplicateClassMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector;

/*!
 * @method gx_duplicateInstanceMethodWithSelector:toSelector:
 * @abstract Creates a duplicate of an instance method
 * 
 * @param selector
 * The selector of the instance method to duplicate
 *
 * @param newSelector
 * The selector of the instance method to create
 * 
 * @discussion
 * Using this method allows forwards-compatible addition of methods in a safe manner.
 * If an instance method with the selector already exists, this method does nothing.
 * If the receiver does not have a method with the selector, this method raises an exception.
 */
+ (void)gx_duplicateInstanceMethodWithSelector:(SEL)selector toSelector:(SEL)newSelector;


/*!
 * @method gx_associatedObjectForKey:
 * @abstract Gets an associated object on the receiver
 * 
 * @param key
 * The key used for the association
 * 
 * @result An object, or nil
 */
- (id)gx_associatedObjectForKey:(id <NSCopying>)key;

/*!
 * @method gx_setAssociatedObject:forKey:policy:
 * @abstract Sets an associated object on the receiver
 * 
 * @param obj
 * The object to add for the association
 * 
 * @param key
 * The key to use for the association
 * 
 * @param policy
 * The association policy to use
 * 
 * @discussion
 * Pass nil for `obj` to remove an association.
 * 
 * If key is nil, this method raises an NSInvalidArgumentException.
 */
- (void)gx_setAssociatedObject:(id)obj forKey:(id <NSCopying>)key policy:(GXAssociationPolicy)policy;


/*!
 * @method gx_addObserver:forKeyPaths:options:context:
 * @abstract Add a KVO observer for multiple key paths
 *
 * @param observer
 * The object for which to add observations
 *
 * @param keyPaths
 * The key paths for which to add observations
 *
 * @param context
 * The context to use for the observations
 *
 * @discussion
 * This is a convenience wrapper for adding a KVO observer for multiple key paths simultaneously
 */
- (void)gx_addObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths options:(NSKeyValueObservingOptions)options context:(void *)context;

/*!
 * @method gx_removeObserver:forKeyPaths:
 * @abstract Remove a KVO observer for multiple key paths
 *
 * @param observer
 * The object for which to remove observations
 *
 * @param keyPaths
 * The key paths for which to remove observations
 *
 * @discussion
 * This is a convenience wrapper for removing a KVO observer for multiple key paths simultaneously
 */
- (void)gx_removeObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths;

/*!
 * @method gx_removeObserver:forKeyPaths:context:
 * @abstract Remove a KVO observer for multiple key paths
 *
 * @param observer
 * The object for which to remove observations
 *
 * @param keyPaths
 * The key paths for which to remove observations
 *
 * @param context
 * The context used for the observations
 *
 * @discussion
 * This is a convenience wrapper for removing a KVO observer for multiple key paths simultaneously
 */
- (void)gx_removeObserver:(NSObject *)observer forKeyPaths:(NSSet *)keyPaths context:(void *)context;

@end
