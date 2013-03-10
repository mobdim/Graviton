//
//  GXFileWatcher.h
//  Graviton
//
//  Created by Logan Collins on 3/9/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


typedef GRAVITON_ENUM(NSUInteger, GXFileEventType) {
    GXFileEventTypeItemCreated = 0,
    GXFileEventTypeItemRemoved,
    GXFileEventTypeItemRenamed,
    GXFileEventTypeItemModified,
    GXFileEventTypeItemOwnerGXipChanged,
    GXFileEventTypeItemExtendedAttributesModified,
};


@interface GXFileEvent : NSObject

@property (copy, readonly) NSString *path;
@property (readonly) GXFileEventType type;

@end


@protocol GXFileWatcherDelegate;


@interface GXFileWatcher : NSObject

- (id)initWithPath:(NSString *)path;

@property (copy, readonly) NSString *path;

@property (weak) id <GXFileWatcherDelegate> delegate;
@property (weak) NSOperationQueue *delegateQueue;

@property (readonly, getter=isWatching) BOOL watching;
- (void)start;
- (void)stop;

@end


@protocol GXFileWatcherDelegate <NSObject>

@optional

- (void)fileWatcherDidStart:(GXFileWatcher *)watcher;
- (void)fileWatcherDidStop:(GXFileWatcher *)watcher;

- (void)fileWatcher:(GXFileWatcher *)watcher didObserveEvents:(NSArray *)events;

@end
