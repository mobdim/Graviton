//
//  GXBlockObservation.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXObservation_Private.h>


@interface GXBlockObservation : GXObservation

+ (GXBlockObservation *)observationWithObject:(id)object
                                         keyPath:(NSString *)keyPath
                                         options:(NSKeyValueObservingOptions)options
                                           block:(void (^)(NSDictionary *change))block;

- (id)initWithObject:(id)object
             keyPath:(NSString *)keyPath
             options:(NSKeyValueObservingOptions)options
               block:(void (^)(NSDictionary *change))block;

@property (weak) id object;
@property (copy) NSString *keyPath;
@property (assign) NSKeyValueObservingOptions options;
@property (copy) void (^block)(NSDictionary *change);

@end
