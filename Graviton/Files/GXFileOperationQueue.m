//
//  GXFileOperationQueue.m
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXFileOperationQueue.h"
#import "GXFileOperationQueue_Private.h"

#if !TARGET_OS_IPHONE
#import <AppKit/NSWorkspace.h>
#endif


@implementation GXFileOperationQueue {
    NSOperationQueue *_operationQueue;
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
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setName:@"com.sunflowersw.graviton.file-operation-queue"];
    }
    return self;
}

- (NSUInteger)operationCount {
    return [_operationQueue operationCount];
}

- (void)cancelAllOperations {
    [_operationQueue cancelAllOperations];
}


#pragma mark -
#pragma mark Operations

- (void)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler {
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if (currentQueue == nil) {
        currentQueue = [NSOperationQueue mainQueue];
    }
    
    [_operationQueue addOperationWithBlock:^{
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        __block NSFileManager *fileManager = [[NSFileManager alloc] init];
        __block NSError *error = nil;
        
        [coordinator coordinateWritingItemAtURL:destURL options:NSFileCoordinatorWritingForReplacing error:&error byAccessor:^(NSURL *newURL) {
            if (options & GXFileOperationOptionOverwrite) {
                [fileManager removeItemAtURL:newURL error:nil];
            }
            
            [coordinator itemAtURL:srcURL willMoveToURL:newURL];
            
            if ([fileManager moveItemAtURL:srcURL toURL:newURL error:&error]) {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(nil);
                    }];
                }
            }
            else {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(error);
                    }];
                }
            }
            
            [coordinator itemAtURL:srcURL didMoveToURL:newURL];
        }];
    }];
}

- (void)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if (currentQueue == nil) {
        currentQueue = [NSOperationQueue mainQueue];
    }
    
    [_operationQueue addOperationWithBlock:^{
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        __block NSError *error = nil;
        
        [coordinator coordinateWritingItemAtURL:destURL options:NSFileCoordinatorWritingForReplacing error:&error byAccessor:^(NSURL *newURL) {
            if (options & GXFileOperationOptionOverwrite) {
                [fileManager removeItemAtURL:destURL error:nil];
            }
            
            if ([fileManager moveItemAtURL:srcURL toURL:destURL error:&error]) {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(nil);
                    }];
                }
            }
            else {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(error);
                    }];
                }
            }
        }];
    }];
}

#if !TARGET_OS_IPHONE

- (void)recycleItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if (currentQueue == nil) {
        currentQueue = [NSOperationQueue mainQueue];
    }
    
    [_operationQueue addOperationWithBlock:^{
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        __block NSError *error = nil;
        
        [coordinator coordinateWritingItemAtURL:srcURL options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL *newURL) {
            NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
            [workspace recycleURLs:[NSArray arrayWithObject:srcURL] completionHandler:^(NSDictionary *newURLs, NSError *error) {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(error);
                    }];
                }
            }];
        }];
    }];
}

#endif

- (void)removeItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *))handler {
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    if (currentQueue == nil) {
        currentQueue = [NSOperationQueue mainQueue];
    }
    
    [_operationQueue addOperationWithBlock:^{
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        __block NSError *error = nil;
        
        [coordinator coordinateWritingItemAtURL:srcURL options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL *newURL) {
            if ([fileManager removeItemAtURL:newURL error:&error]) {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(nil);
                    }];
                }
            }
            else {
                if (handler != nil) {
                    [currentQueue addOperationWithBlock:^{
                        handler(error);
                    }];
                }
            }
        }];
    }];
}

@end
