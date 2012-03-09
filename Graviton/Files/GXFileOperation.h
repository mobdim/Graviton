//
//  GXFileOperation.h
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @enum GXFileOperationType
 * @abstract Types of file operations
 * 
 * @constant GXFileOperationTypeMove            Move an item to a new destination
 * @constant GXFileOperationTypeCopy            Copy an item to a new destination
 * @constant GXFileOperationTypeMoveToTrash     Move an item to the Trash
 */
enum {
    GXFileOperationTypeMove = 0,
    GXFileOperationTypeCopy,
    GXFileOperationTypeMoveToTrash,
};
typedef NSUInteger GXFileOperationType;


/*!
 * @enum GXFileOperationOptions
 * @abstract Bitmask values for file operation options
 * 
 * @constant GXFileOperationOptionDefault                       The default set of options
 * @constant GXFileOperationOptionOverwrite                     Overwrite destination files
 * @constant GXFileOperationOptionSkipSourcePermissionErrors    Skip errors about source permissions
 * @constant GXFileOperationOptionDoNotMoveAcrossVolumes        Do not move files if the destination is another volume
 * @constant GXFileOperationOptionSkipPreflight                 Skip the preflight step
 */
enum {
    GXFileOperationOptionDefault = 0,
    GXFileOperationOptionOverwrite = 0x01,
    GXFileOperationOptionSkipSourcePermissionErrors = 0x02,
    GXFileOperationOptionDoNotMoveAcrossVolumes = 0x04,
    GXFileOperationOptionSkipPreflight = 0x08,
};
typedef NSUInteger GXFileOperationOptions;


/*!
 * @enum GXFileOperationState
 * @abstract States of a file operation
 * 
 * @constant GXFileOperationStateNotStarted     The operation has not yet started
 * @constant GXFileOperationStateStarted        The operation has been enqueued
 * @constant GXFileOperationStatePreflighting   The operation is in preflight
 * @constant GXFileOperationStateRunning        The operation is running
 * @constant GXFileOperationStateFinished       The operation has finished
 * @constant GXFileOperationStateCancelled      The operation has been cancelled
 */
enum {
    GXFileOperationStateNotStarted = 0,
    GXFileOperationStateStarted,
    GXFileOperationStatePreflighting,
    GXFileOperationStateRunning,
    GXFileOperationStateFinished,
    GXFileOperationStateCancelled,
};
typedef NSUInteger GXFileOperationState;


/*!
 * @class GXFileOperation
 * @abstract Represents the manipulation of a file or directory
 */
@interface GXFileOperation : NSObject

/*!
 * @method moveOperationWithSourceURL:destinationURL:options:
 * @abstract Creates a new move operation
 * 
 * @param srcURL
 * The source URL
 * 
 * @param destURL
 * The destination URL
 * 
 * @param options
 * The file operation options
 * 
 * @result An GXFileOperation object
 */
+ (GXFileOperation *)moveOperationWithSourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options;

/*!
 * @method copyOperationWithSourceURL:destinationURL:options:
 * @abstract Creates a new copy operation
 * 
 * @param srcURL
 * The source URL
 * 
 * @param destURL
 * The destination URL
 * 
 * @param options
 * The file operation options
 * 
 * @result An GXFileOperation object
 */
+ (GXFileOperation *)copyOperationWithSourceURL:(NSURL *)srcURL destinationURL:(NSURL *)destURL options:(GXFileOperationOptions)options;

/*!
 * @method moveToTrashOperationWithSourceURL:options:
 * @abstract Creates a new move to trash operation
 * 
 * @param srcURL
 * The source URL
 * 
 * @param options
 * The file operation options
 * 
 * @result An GXFileOperation object
 */
+ (GXFileOperation *)moveToTrashOperationWithSourceURL:(NSURL *)srcURL options:(GXFileOperationOptions)options;


/*!
 * @property type
 * @abstract The operation type
 * 
 * @result An GXFileOperationType value
 */
@property (assign, readonly) GXFileOperationType type;

/*!
 * @property sourceURL
 * @abstract The source URL
 * 
 * @result An NSURL object
 */
@property (copy, readonly) NSURL *sourceURL;

/*!
 * @property destinationURL
 * @abstract The destination URL
 * 
 * @result An NSURL object, or nil
 */
@property (copy, readonly) NSURL *destinationURL;

/*!
 * @property options
 * @abstract The file operation options
 * 
 * @result An GXFileOperationOptions bitmask value
 */
@property (assign, readonly) GXFileOperationOptions options;

/*!
 * @property completionBlock
 * @abstract The block invoked when the operation is completed
 * 
 * @result A block object
 */
@property (copy) void (^completionBlock)(void);

/*!
 * @property state
 * @abstract The current state
 * 
 * @result An GXFileOperationState value
 */
@property (assign, readonly) GXFileOperationState state;


/*!
 * @property totalNumberOfBytes
 * @abstract The total number of bytes being acted upon
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *totalNumberOfBytes;

/*!
 * @property bytesCompleted
 * @abstract The total number of bytes completed
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *bytesCompleted;

/*!
 * @property bytesRemaining
 * @abstract The total number of bytes remaining
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *bytesRemaining;

/*!
 * @property totalNumberOfItems
 * @abstract The total number of items being acted upon
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *totalNumberOfItems;

/*!
 * @property itemsCompleted
 * @abstract The total number of items completed
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *itemsCompleted;

/*!
 * @property itemsRemaining
 * @abstract The total number of items remaining
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *itemsRemaining;

/*!
 * @property totalUserVisibleItems
 * @abstract The total number of user-visible items being acted upon
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *totalUserVisibleItems;

/*!
 * @property userVisibleItemsCompleted
 * @abstract The total number of user-visible items completed
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *userVisibleItemsCompleted;

/*!
 * @property userVisibleItemsRemaining
 * @abstract The total number of user-visible items remaining
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *userVisibleItemsRemaining;

/*!
 * @property throughput
 * @abstract The current file operation throughput, in bytes per second
 * 
 * @result An NSNumber object
 */
@property (copy, readonly) NSNumber *throughput;


/*!
 * @method start
 * @abstract Begins the file operation
 */
- (void)start;

/*!
 * @method cancel
 * @abstract Cancels the file operation if it has been started
 */
- (void)cancel;

@end
