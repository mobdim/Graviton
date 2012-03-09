//
//  GXFileOperationQueue.h
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GXFileOperation;


/*!
 * @class GXFileOperationQueue
 * @abstract Coordinates multiple asynchronous file operations
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
 * @property fileOperations
 * @abstract All currently active operations
 * 
 * @result An NSArray of SHFileOperation objects
 */
@property (copy, readonly) NSArray *operations;

/*!
 * @method cancelAllOperations
 * @abstract Cancels all active file operations
 */
- (void)cancelAllOperations;

/*!
 * @method addOperation:
 * @abstract Adds an operation to the queue
 * 
 * @discussion
 * This method calls -start on the operation.
 * 
 * @param operation
 * The operation to add
 */
- (void)addOperation:(GXFileOperation *)operation;

@end
