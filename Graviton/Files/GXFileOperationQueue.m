//
//  GXFileOperationQueue.m
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXFileOperationQueue.h"
#import "GXFileOperation_Private.h"

#import "GXFileOperation.h"


@implementation GXFileOperationQueue {
    NSMutableArray *_operations;
}

+ (GXFileOperationQueue *)defaultQueue {
    static GXFileOperationQueue *defaultQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultQueue = [[self alloc] init];
    });
    return defaultQueue;
}

- (id)init {
    self = [super init];
    if (self) {
        _operations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[GXFileOperation class]] && [keyPath isEqualToString:@"state"]) {
        if ([object state] == GXFileOperationStateCancelled
            || [object state] == GXFileOperationStateFinished) {
            [_operations removeObject:object];
        }
    }
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (NSArray *)operations {
    return [_operations copy];
}

- (void)cancelAllOperations {
    for (GXFileOperation *operation in [self operations]) {
        [operation cancel];
    }
}

- (void)addOperation:(GXFileOperation *)operation {
    if (![_operations containsObject:operation]) {
        [operation addObserver:self forKeyPath:@"state" options:(NSKeyValueObservingOptionNew) context:nil];
        
        NSIndexSet *changedIndexes = [NSIndexSet indexSetWithIndex:[_operations count]];
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:changedIndexes forKey:@"operations"];
        [_operations addObject:operation];
        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:changedIndexes forKey:@"operations"];
        
        [operation start];
    }
}

@end
