//
//  GXBlockKVOObservation.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXKVOObservation.h>


@interface GXBlockKVOObservation : GXKVOObservation

+ (GXBlockKVOObservation *)observationWithObject:(id)object
                                         keyPath:(NSString *)keyPath
                                         options:(NSKeyValueObservingOptions)options
                                           block:(void (^)(NSDictionary *change))block;

@property (weak, readonly) id object;
@property (copy, readonly) NSString *keyPath;
@property (assign, readonly) NSKeyValueObservingOptions options;
@property (copy, readonly) void (^block)(NSDictionary *change);

@end
