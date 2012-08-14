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
    GXAssociationPolicyAssign = 0,
    GXAssociationPolicyRetainNonatomic = 1,
    GXAssociationPolicyCopyNonatomic = 3,
    GXAssociationPolicyRetain = 01401,
    GXAssociationPolicyCopy = 01403,
};


@interface NSObject (GravitonAdditions)

- (void)gx_performBlock:(void (^)(void))block;
- (void)gx_performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

- (id)gx_associatedObjectForKey:(id <NSCopying>)key;
- (void)gx_setAssociatedObject:(id)obj forKey:(id <NSCopying>)key policy:(GXAssociationPolicy)policy;

@end
