//
//  NSData+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 11/27/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


@interface NSData (GravitonAdditions)

/*!
 * @group Digests
 */

// MD5
- (NSData *)gx_MD5Digest;

// SHA-1
- (NSData *)gx_SHA1Digest;

// SHA-2
- (NSData *)gx_SHA224Digest;
- (NSData *)gx_SHA256Digest;
- (NSData *)gx_SHA384Digest;
- (NSData *)gx_SHA512Digest;

@end
