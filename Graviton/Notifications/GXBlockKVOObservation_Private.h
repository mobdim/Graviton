//
//  GXBlockKVOObservation_Private.h
//  Graviton
//
//  Created by Logan Collins on 4/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXBlockKVOObservation.h>


@interface GXBlockKVOObservation ()

- (id)initWithObject:(id)object
             keyPath:(NSString *)keyPath
             options:(NSKeyValueObservingOptions)options
               block:(void (^)(NSDictionary *change))block;

@property (weak, readwrite) id object;
@property (copy, readwrite) NSString *keyPath;
@property (assign, readwrite) NSKeyValueObservingOptions options;
@property (copy, readwrite) void (^block)(NSDictionary *change);

@end
