//
//  GXFileOperation_Private.h
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXFileOperation.h"


@interface GXFileOperation ()

- (id)initWithType:(GXFileOperationType)type sourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options;

@property (assign, readwrite) GXFileOperationType type;
@property (copy, readwrite) NSURL *sourceURL;
@property (copy, readwrite) NSURL *destinationURL;
@property (assign, readwrite) GXFileOperationOptions options;
@property (assign, readwrite) GXFileOperationState state;

@property (copy, readwrite) NSNumber *totalNumberOfBytes;
@property (copy, readwrite) NSNumber *bytesCompleted;
@property (copy, readwrite) NSNumber *bytesRemaining;

@property (copy, readwrite) NSNumber *totalNumberOfItems;
@property (copy, readwrite) NSNumber *itemsCompleted;
@property (copy, readwrite) NSNumber *itemsRemaining;

@property (copy, readwrite) NSNumber *totalUserVisibleItems;
@property (copy, readwrite) NSNumber *userVisibleItemsCompleted;
@property (copy, readwrite) NSNumber *userVisibleItemsRemaining;

@property (copy, readwrite) NSNumber *throughput;

- (void)updateStatusWithCurrentItem:(const FSRef *)currentItem stage:(FSFileOperationStage)stage error:(OSStatus)error statusDictionary:(NSDictionary *)dictionary;

@end
