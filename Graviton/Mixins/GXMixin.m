//
//  GXMixin.m
//  Graviton
//
//  Created by Logan Collins on 11/1/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXMixin.h"

#import <objc/runtime.h>


@implementation GXMixin

@end


@implementation NSObject (GXMixin)

+ (void)gx_addMixinClass:(Class)mixinClass {
    if (![mixinClass isSubclassOfClass:[GXMixin class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Mixin class must be a subclass of GXMixin" userInfo:nil];
    }
    
    [self gx_mixinMethodsFromClass:mixinClass];
}

+ (void)gx_mixinMethodsFromClass:(Class)mixinClass {
    Class mixinMetaclass = object_getClass(mixinClass);
    Class metaclass = object_getClass(self);
    
    // Mixin instance methods
    unsigned int instanceMethodCount = 0;
    Method * instanceMethodsList = class_copyMethodList(mixinClass, &instanceMethodCount);
    if (instanceMethodsList != NULL) {
        for (unsigned int i=0; i<instanceMethodCount; i++) {
            Method method = instanceMethodsList[i];
            
            SEL selector = method_getName(method);
            IMP implementation = method_getImplementation(method);
            const char * types = method_getTypeEncoding(method);
            
            class_addMethod(self, selector, implementation, types);
        }
        free(instanceMethodsList);
    }
    
    // Mixin class methods
    unsigned int classMethodCount = 0;
    Method * classMethodsList = class_copyMethodList(mixinMetaclass, &classMethodCount);
    if (classMethodsList != NULL) {
        for (unsigned int i=0; i<classMethodCount; i++) {
            Method method = classMethodsList[i];
            
            SEL selector = method_getName(method);
            IMP implementation = method_getImplementation(method);
            const char * types = method_getTypeEncoding(method);
            
            class_addMethod(metaclass, selector, implementation, types);
        }
        free(classMethodsList);
    }
    
    // Mixin properties
    unsigned int propertyCount = 0;
    objc_property_t * propertyList = class_copyPropertyList(mixinClass, &propertyCount);
    if (propertyList != NULL) {
        for (unsigned int i=0; i<propertyCount; i++) {
            objc_property_t property = propertyList[i];
            
            const char * name = property_getName(property);
            unsigned int attributeCount = 0;
            objc_property_attribute_t * attributeList = property_copyAttributeList(property, &attributeCount);
            
            class_addProperty(self, name, attributeList, attributeCount);
            
            if (attributeList != NULL) {
                free(attributeList);
            }
        }
        free(propertyList);
    }
    
    Class superclass = [mixinClass superclass];
    if (superclass != [GXMixin class]) {
        [self gx_mixinMethodsFromClass:superclass];
    }
}

@end
