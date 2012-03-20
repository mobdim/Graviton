//
//  NSObject+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 3/20/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (GravitonAdditions)

- (void)gx_performBlock:(void (^)(void))block;
- (void)gx_performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

@end
