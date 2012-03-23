//
//  GXFileOperationQueue.m
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXFileOperationQueue.h"
#import "GXFileOperationQueue_Private.h"

#if TARGET_OS_MAC
#import <AppKit/NSWorkspace.h>
#endif


@implementation GXFileOperationQueue {
    NSUInteger _operationCount;
    dispatch_queue_t _operationQueue;
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
        _operationQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSUInteger)operationCount {
    return _operationCount;
}

- (void)incrementOperationCount {
    @synchronized(self) {
        _operationCount++;
    }
}

- (void)decrementOperationCount {
    @synchronized(self) {
        _operationCount--;
    }
}


#pragma mark -
#pragma mark Accessors

- (dispatch_queue_t)operationQueue {
    return _operationQueue;
}

- (void)setOperationQueue:(dispatch_queue_t)operationQueue {
    if (_operationQueue != NULL) {
        dispatch_release(_operationQueue);
    }
    if (operationQueue != NULL) {
        dispatch_retain(operationQueue);
    }
    _operationQueue = operationQueue;
}


#pragma mark -
#pragma mark Operations

- (void)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler {
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_async(_operationQueue, ^{
        [self incrementOperationCount];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        if ([fileManager moveItemAtURL:srcURL toURL:destURL error:&error]) {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(nil);
                });
            }
        }
        else {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(error);
                });
            }
        }
        [self decrementOperationCount];
    });
}

- (void)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_async(_operationQueue, ^{
        [self incrementOperationCount];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        if ([fileManager moveItemAtURL:srcURL toURL:destURL error:&error]) {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(nil);
                });
            }
        }
        else {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(error);
                });
            }
        }
        [self decrementOperationCount];
    });
}

#if TARGET_OS_MAC

- (void)recycleItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_async(_operationQueue, ^{
        [self incrementOperationCount];
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        [workspace recycleURLs:[NSArray arrayWithObject:srcURL] completionHandler:^(NSDictionary *newURLs, NSError *error) {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(error);
                });
            }
        }];
        [self decrementOperationCount];
    });
}

#endif

- (void)removeItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_async(_operationQueue, ^{
        [self incrementOperationCount];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error = nil;
        if ([fileManager removeItemAtURL:srcURL error:&error]) {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(nil);
                });
            }
        }
        else {
            if (handler != nil) {
                dispatch_async(currentQueue, ^{
                    handler(error);
                });
            }
        }
        [self decrementOperationCount];
    });
}

@end
