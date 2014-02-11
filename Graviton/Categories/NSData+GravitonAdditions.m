//
//  NSData+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 11/27/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSData+GravitonAdditions.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSData (GravitonAdditions)


#pragma mark -
#pragma mark Digests

- (NSData *)gx_MD5Digest {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)gx_SHA1Digest {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)gx_SHA224Digest {
    unsigned char digest[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
}

- (NSData *)gx_SHA256Digest {
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)gx_SHA384Digest {
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
}

- (NSData *)gx_SHA512Digest {
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512([self bytes], (CC_LONG)[self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
}

@end
