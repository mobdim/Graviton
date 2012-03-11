//
//  GXFileOperationQueue.h
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * @enum GXFileOperationOptions
 * @abstract Bitmask values for file operation options
 * 
 * @constant GXFileOperationOptionOverwrite                     Overwrite destination files
 */
enum {
    GXFileOperationOptionOverwrite = 0x01,
};
typedef NSUInteger GXFileOperationOptions;


@class GXFileOperation;


/*!
 * @class GXFileOperationQueue
 * @abstract Coordinates multiple queued asynchronous file operations
 */
@interface GXFileOperationQueue : NSObject

/*!
 * @method defaultQueue
 * @abstract The default file operation queue
 * 
 * @result GXFileOperationQueue
 */
+ (GXFileOperationQueue *)defaultQueue;


/*!
 * @property operationCount
 * @abstract The number of currently active operations
 * 
 * @result An NSUInteger value
 */
@property (assign, readonly) NSUInteger operationCount;

/*!
 * @property operationQueue
 * @abstract The dispatch queue on which to execute operations
 * 
 * @result A dispatch_queue object
 */
@property (assign) dispatch_queue_t operationQueue;


/*!
 * @method moveItemAtURL:toURL:options:completionHandler:
 * @abstract Moves an item to a new URL
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
- (void)moveItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler;

/*!
 * @method copyItemAtURL:toURL:options:completionHandler:
 * @abstract Copies an item to a new URL
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
- (void)copyItemAtURL:(NSURL *)srcURL toURL:(NSURL *)destURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler;

/*!
 * @method recycleItemAtURL:options:completionHandler:
 * @abstract Moves an item to the Trash
 * 
 * @param srcURL
 * The source URL
 * 
 * @param options
 * The file operation options
 * 
 * @result An GXFileOperation object
 */
- (void)recycleItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler;

/*!
 * @method removeItemAtURL:options:completionHandler:
 * @abstract Deletes an item
 * 
 * @param srcURL
 * The source URL
 * 
 * @param options
 * The file operation options
 * 
 * @result An GXFileOperation object
 */
- (void)removeItemAtURL:(NSURL *)srcURL options:(GXFileOperationOptions)options completionHandler:(void (^)(NSError *error))handler;

@end
