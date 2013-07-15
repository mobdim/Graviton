//
//  GXFileWatcher.m
//  Graviton
//
//  Created by Logan Collins on 3/9/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "GXFileWatcher.h"


static void GXFileWatcherCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]);


@interface GXFileWatcher ()

@property (copy, readwrite) NSString *path;
@property (readwrite, getter=isWatching) BOOL watching;

@end


@interface GXFileEvent ()

@property (copy, readwrite) NSString *path;
@property (readwrite) GXFileEventType type;

@property FSEventStreamEventId eventID;
@property FSEventStreamEventFlags eventFlags;

@end


@implementation GXFileWatcher {
    FSEventStreamRef _eventStreamRef;
    dispatch_queue_t _eventQueue;
}

- (id)initWithPath:(NSString *)path {
    NSParameterAssert(path != nil);
    
    self = [super init];
    if (self) {
        self.path = path;
        
        _eventQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


#pragma mark -
#pragma mark Watching

- (void)start {
    if (self.watching) {
        return;
    }
    
    NSArray *paths = @[self.path];
    FSEventStreamContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
    _eventStreamRef = FSEventStreamCreate(NULL, GXFileWatcherCallback, &context, (__bridge CFArrayRef)paths, kFSEventStreamEventIdSinceNow, 5.0, (kFSEventStreamCreateFlagUseCFTypes|kFSEventStreamCreateFlagWatchRoot|kFSEventStreamCreateFlagIgnoreSelf|kFSEventStreamCreateFlagFileEvents));
    FSEventStreamSetDispatchQueue(_eventStreamRef, _eventQueue);
    FSEventStreamStart(_eventStreamRef);
    
    self.watching = YES;
    
    NSOperationQueue *operationQueue = self.delegateQueue;
    if (operationQueue == nil) {
        operationQueue = [NSOperationQueue mainQueue];
    }
    
    [operationQueue addOperationWithBlock:^{
        if ([self.delegate respondsToSelector:@selector(fileWatcherDidStart:)]) {
            [self.delegate fileWatcherDidStart:self];
        }
    }];
}

- (void)stop {
    if (!self.watching) {
        return;
    }
    
    FSEventStreamStop(_eventStreamRef);
    FSEventStreamInvalidate(_eventStreamRef);
    CFRelease(_eventStreamRef), _eventStreamRef = NULL;
    
    self.watching = NO;
    
    NSOperationQueue *operationQueue = self.delegateQueue;
    if (operationQueue == nil) {
        operationQueue = [NSOperationQueue mainQueue];
    }
    
    [operationQueue addOperationWithBlock:^{
        if ([self.delegate respondsToSelector:@selector(fileWatcherDidStop:)]) {
            [self.delegate fileWatcherDidStop:self];
        }
    }];
}

- (void)processEvents:(NSArray *)events {
    if ([self.delegate respondsToSelector:@selector(fileWatcher:didObserveEvents:)]) {
        NSOperationQueue *operationQueue = self.delegateQueue;
        if (operationQueue == nil) {
            operationQueue = [NSOperationQueue mainQueue];
        }
        
        [operationQueue addOperationWithBlock:^{
            [self.delegate fileWatcher:self didObserveEvents:events];
        }];
    }
}

@end


@implementation GXFileEvent

@end


static void GXFileWatcherCallback(ConstFSEventStreamRef streamRef, void *clientCallBackInfo, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[]) {
    CFArrayRef paths = (CFArrayRef)eventPaths;
    GXFileWatcher *watcher = (__bridge GXFileWatcher *)clientCallBackInfo;
    
    NSMutableArray *events = [NSMutableArray arrayWithCapacity:numEvents];
    for (NSUInteger i=0; i<numEvents; i++) {
        NSString *path = (__bridge NSString *)CFArrayGetValueAtIndex(paths, i);
        FSEventStreamEventFlags flags = eventFlags[i];
        FSEventStreamEventId eventID = eventIds[i];
        
        if ((flags & kFSEventStreamEventFlagUserDropped)
            || (flags & kFSEventStreamEventFlagKernelDropped)) {
            // Ignore dropped events
            continue;
        }
        
        GXFileEventType type = kFSEventStreamEventFlagNone;
        
        if (flags & kFSEventStreamEventFlagItemCreated) {
            type = GXFileEventTypeItemCreated;
        }
        else if (flags & kFSEventStreamEventFlagItemRemoved) {
            type = GXFileEventTypeItemRemoved;
        }
        else if (flags & kFSEventStreamEventFlagItemRenamed) {
            type = GXFileEventTypeItemRenamed;
        }
        else if (flags & kFSEventStreamEventFlagItemModified) {
            type = GXFileEventTypeItemModified;
        }
        else if (flags & kFSEventStreamEventFlagItemChangeOwner) {
            type = GXFileEventTypeItemOwnershipChanged;
        }
        else if (flags & kFSEventStreamEventFlagItemXattrMod) {
            type = GXFileEventTypeItemExtendedAttributesModified;
        }
        
        if (type != kFSEventStreamEventFlagNone) {
            GXFileEvent *event = [[GXFileEvent alloc] init];
            event.path = path;
            event.eventID = eventID;
            event.eventFlags = flags;
            event.type = type;
            [events addObject:event];
        }
    }
    
    [watcher processEvents:events];
}
