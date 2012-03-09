//
//  GXFileOperation.m
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXFileOperation.h"
#import "GXFileOperation_Private.h"


static void GXFileOperationCallback(FSFileOperationRef fileOp, const FSRef *currentItem, FSFileOperationStage stage, OSStatus error, CFDictionaryRef statusDictionary, void *info);


@implementation GXFileOperation {
    FSFileOperationRef _fileOperation;
}

@synthesize type=_type;
@synthesize sourceURL=_sourceURL;
@synthesize destinationURL=_destinationURL;
@synthesize options=_options;
@synthesize completionBlock=_completionBlock;

@synthesize state=_state;

@synthesize totalNumberOfBytes=_totalNumberOfBytes;
@synthesize bytesCompleted=_bytesCompleted;
@synthesize bytesRemaining=_bytesRemaining;
@synthesize totalNumberOfItems=_totalNumberOfItems;
@synthesize itemsCompleted=_itemsCompleted;
@synthesize itemsRemaining=_itemsRemaining;
@synthesize totalUserVisibleItems=_totalUserVisibleItems;
@synthesize userVisibleItemsCompleted=_userVisibleItemsCompleted;
@synthesize userVisibleItemsRemaining=_userVisibleItemsRemaining;
@synthesize throughput=_throughput;

+ (GXFileOperation *)moveOperationWithSourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options {
    return [[self alloc] initWithType:GXFileOperationTypeMove sourceURL:srcURL destinationURL:destURL options:options];
}

+ (GXFileOperation *)copyOperationWithSourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options {
    return [[self alloc] initWithType:GXFileOperationTypeCopy sourceURL:srcURL destinationURL:destURL options:options];
}

+ (GXFileOperation *)moveToTrashOperationWithSourceURL:(NSURL *)srcURL options:(GXFileOperationOptions)options {
    return [[self alloc] initWithType:GXFileOperationTypeMoveToTrash sourceURL:srcURL destinationURL:nil options:options];
}

- (id)initWithType:(GXFileOperationType)type sourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options {
    self = [super init];
    if (self) {
        self.type = type;
        self.sourceURL = srcURL;
        self.destinationURL = destURL;
        self.options = options;
        
        _fileOperation = FSFileOperationCreate(NULL);
    }
    return self;
}

- (void)dealloc {
    CFRelease(_fileOperation);
}

- (void)start {
    if (self.state != GXFileOperationStateNotStarted) {
        @throw [NSException exceptionWithName:@"GXFileOperationAlreadyStartedException" reason:@"A file operation cannot be started more than once." userInfo:nil];
    }
    
    self.state = GXFileOperationStateStarted;
    
    const UInt8 *srcPath = (const UInt8 *)[[[self sourceURL] path] UTF8String];
    const UInt8 *destPath = (const UInt8 *)[[[self destinationURL] path] UTF8String];
    FSRef srcRef, destRef;
    
    FSPathMakeRef(srcPath, &srcRef, NULL);
    FSPathMakeRef(destPath, &srcRef, NULL);
    
    FSFileOperationClientContext context = {
        0,
        (__bridge void *)self,
        NULL,
        NULL,
        NULL
    };
    
    if (self.type == GXFileOperationTypeMove) {
        FSMoveObjectAsync(_fileOperation, &srcRef, &destRef, NULL, (OptionBits)self.options, GXFileOperationCallback, 1.0, &context);
    }
    else if (self.type == GXFileOperationTypeCopy) {
        FSCopyObjectAsync(_fileOperation, &srcRef, &destRef, NULL, (OptionBits)self.options, GXFileOperationCallback, 1.0, &context);
    }
    else if (self.type == GXFileOperationTypeMoveToTrash) {
        FSMoveObjectToTrashAsync(_fileOperation, &srcRef, (OptionBits)self.options, GXFileOperationCallback, 1.0, &context);
    }
}

- (void)cancel {
    self.state = GXFileOperationStateCancelled;
    FSFileOperationCancel(_fileOperation);
    if (self.completionBlock != nil) {
        self.completionBlock();
    }
}

- (void)updateStatusWithCurrentItem:(const FSRef *)currentItem stage:(FSFileOperationStage)stage error:(OSStatus)error statusDictionary:(NSDictionary *)dictionary {
    if (self.state == GXFileOperationStateCancelled) {
        return;
    }
    
    if (stage == kFSOperationStageUndefined) {
        self.state = GXFileOperationStateStarted;
    }
    else if (stage == kFSOperationStagePreflighting) {
        self.state = GXFileOperationStatePreflighting;
    }
    else if (stage == kFSOperationStageRunning) {
        self.state = GXFileOperationStateRunning;
    }
    else if (stage == kFSOperationStageComplete) {
        self.state = GXFileOperationStateFinished;
        if (self.completionBlock != nil) {
            self.completionBlock();
        }
    }
    
    self.totalNumberOfBytes = [dictionary objectForKey:(__bridge NSString *)kFSOperationTotalBytesKey];
    self.bytesCompleted = [dictionary objectForKey:(__bridge NSString *)kFSOperationBytesCompleteKey];
    self.bytesRemaining = [dictionary objectForKey:(__bridge NSString *)kFSOperationBytesRemainingKey];
    
    self.totalNumberOfItems = [dictionary objectForKey:(__bridge NSString *)kFSOperationTotalObjectsKey];
    self.itemsCompleted = [dictionary objectForKey:(__bridge NSString *)kFSOperationObjectsCompleteKey];
    self.itemsRemaining = [dictionary objectForKey:(__bridge NSString *)kFSOperationObjectsRemainingKey];
    
    self.totalUserVisibleItems = [dictionary objectForKey:(__bridge NSString *)kFSOperationTotalUserVisibleObjectsKey];
    self.userVisibleItemsCompleted = [dictionary objectForKey:(__bridge NSString *)kFSOperationUserVisibleObjectsCompleteKey];
    self.userVisibleItemsRemaining = [dictionary objectForKey:(__bridge NSString *)kFSOperationUserVisibleObjectsRemainingKey];
    
    self.throughput = [dictionary objectForKey:(__bridge NSString *)kFSOperationThroughputKey];
}

@end


static void GXFileOperationCallback(FSFileOperationRef fileOp, const FSRef *currentItem, FSFileOperationStage stage, OSStatus error, CFDictionaryRef statusDictionary, void *info) {
    [(__bridge GXFileOperation *)info updateStatusWithCurrentItem:currentItem stage:stage error:error statusDictionary:(__bridge NSDictionary *)statusDictionary];
}

