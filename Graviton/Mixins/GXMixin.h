//
//  GXMixin.h
//  Graviton
//
//  Created by Logan Collins on 11/1/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @class GXMixin
 * @abstract Allows appending common method implementations to a class
 * 
 * @discussion
 * Mixins are very similar to Objective-C categories, except they can be added
 * to multiple classes dynamically at runtime.
 *
 * Warning: Do not access or use instance variables in your mixin implementation.
 * Just like a category, no ivars are not created by the mixin and the storage will
 * not exist in the parent class.
 *
 * To use mixins, do the following:
 * 
 * 1. Define a protocol with your mixin interface, and have your parent classes conform to it.
 * 2. Create a subclass of GXMixin with your required method implementation.
 * 3. In each parent class's +initialize method, call -gx_addMixinClass:.
 * 
 * The protocol is to ensure that the compiler doesn't complain about missing methods
 * in the parent class. You can conform the mixin to it, but it isn't required.
 */
@interface GXMixin : NSObject

@end


/*!
 * @category NSObject(GXMixin)
 * @abstract Additions to enable mixins
 */
@interface NSObject (GXMixin)

/*!
 * @method gx_addMixin:
 * @abstract Adds the method implementations from a given mixin
 * 
 * @param mixinClass
 * The mixin class (must be a subclass of GXMixin)
 */
+ (void)gx_addMixin:(Class)mixinClass;

@end
