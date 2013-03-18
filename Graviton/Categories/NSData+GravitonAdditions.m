//
//  NSData+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 11/27/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "NSData+GravitonAdditions.h"

#import <CommonCrypto/CommonCrypto.h>


NSString * const GXCryptographyErrorDomain = @"GXCryptographyErrorDomain";


static void GXAdjustKeyLengths(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData);


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


#pragma mark -
#pragma mark Cryptography

- (NSError *)gx_errorFromCCCryptorStatus:(CCCryptorStatus)status {
    NSString *description = nil;
    NSString *failureReason = nil;
    
    switch (status) {
        case kCCSuccess: {
            description = NSLocalizedString(@"Success", nil);
            break;
        }
        case kCCParamError: {
            description = NSLocalizedString(@"Parameter Error", nil);
            failureReason = NSLocalizedString(@"Illegal parameter supplied to cryptographic function", nil);
            break;
        }
        case kCCBufferTooSmall: {
            description = NSLocalizedString(@"Buffer Too Small", nil);
            failureReason = NSLocalizedString(@"Insufficient buffer space provided for the specified operation", nil);
            break;
        }
        case kCCMemoryFailure: {
            description = NSLocalizedString(@"Memory Failure", nil);
            failureReason = NSLocalizedString(@"Failed to allocate enough memory", @"Memory Failure");
            break;
        }
        case kCCAlignmentError: {
            description = NSLocalizedString(@"Alignment Error", nil);
            failureReason = NSLocalizedString(@"The input size was not aligned correctly", nil);
            break;
        }
        case kCCDecodeError: {
            description = NSLocalizedString(@"Decode Error", nil);
            failureReason = NSLocalizedString(@"The input data did not decode or decrypt correctly", nil);
            break;
        }
        case kCCUnimplemented: {
            description = NSLocalizedString(@"Unimplemented Function", nil);
            failureReason = NSLocalizedString(@"The cryptographic function is not implemented for the current algorithm", nil);
            break;
        }
        default: {
            description = NSLocalizedString(@"Unknown Error", nil);
            break;
        }
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (description != nil) {
        userInfo[NSLocalizedDescriptionKey] = description;
    }
    if (failureReason != nil) {
        userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
    }
    
    return [NSError errorWithDomain:GXCryptographyErrorDomain code:status userInfo:userInfo];
}

- (NSData *)gx_runCryptor:(CCCryptorRef)cryptor error:(NSError **)outError {
    CCCryptorStatus status = kCCSuccess;
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[self length], true);
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    
    status = CCCryptorUpdate(cryptor, [self bytes], (size_t)[self length], buf, bufsize, &bufused);
    if (status != kCCSuccess) {
        free(buf);
        if (outError != NULL) {
            *outError = [self gx_errorFromCCCryptorStatus:status];
        }
        return nil;
    }
    
    bytesTotal += bufused;
    
    // Need to update buf ptr past used bytes when calling CCCryptorFinal()
    status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (status != kCCSuccess) {
        free(buf);
        if (outError != NULL) {
            *outError = [self gx_errorFromCCCryptorStatus:status];
        }
        return nil;
    }
    
    bytesTotal += bufused;
    
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}

- (NSData *)gx_encryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(NSError **)outError {
    NSParameterAssert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData *keyData, *ivData;
    if ([key isKindOfClass:[NSData class]]) {
        keyData = (NSMutableData *)[key mutableCopy];
    }
    else {
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    if ([iv isKindOfClass:[NSString class]]) {
        ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    else {
        ivData = (NSMutableData *)[iv mutableCopy];
    }
    
    // Ensure correct lengths for key and iv data, based on algorithms
    GXAdjustKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCEncrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
    
    if (status != kCCSuccess) {
        if (outError != NULL) {
            *outError = [self gx_errorFromCCCryptorStatus:status];
        }
        return nil;
    }
    
    NSData *result = [self gx_runCryptor:cryptor error:outError];
    
    CCCryptorRelease(cryptor);
    
    return result;
}

- (NSData *)gx_decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(id)key initializationVector:(id)iv options:(CCOptions)options error:(NSError **)outError {
    NSParameterAssert([key isKindOfClass:[NSData class]] || [key isKindOfClass:[NSString class]]);
    NSParameterAssert(iv == nil || [iv isKindOfClass:[NSData class]] || [iv isKindOfClass:[NSString class]]);
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData *keyData, *ivData;
    if ([key isKindOfClass:[NSData class]]) {
        keyData = (NSMutableData *)[key mutableCopy];
    }
    else {
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    
    if ([iv isKindOfClass:[NSString class]]) {
        ivData = [[iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    }
    else {
        ivData = (NSMutableData *)[iv mutableCopy];
    }
    
    // Ensure correct lengths for key and iv data, based on algorithms
    GXAdjustKeyLengths(algorithm, keyData, ivData);
    
    status = CCCryptorCreate(kCCDecrypt, algorithm, options, [keyData bytes], [keyData length], [ivData bytes], &cryptor);
    
    if (status != kCCSuccess) {
        if (outError != NULL) {
            *outError = [self gx_errorFromCCCryptorStatus:status];
        }
        return nil;
    }
    
    NSData *result = [self gx_runCryptor:cryptor error:outError];
    
    CCCryptorRelease(cryptor);
    
    return result;
}

- (NSData *)gx_encryptedAES256DataUsingKey:(id)key error:(NSError **)outError {
    return [self gx_encryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:key initializationVector:nil options:kCCOptionPKCS7Padding error:outError];
}

- (NSData *)gx_decryptedAES256DataUsingKey:(id)key error:(NSError **)outError {
    return [self gx_decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:key initializationVector:nil options:kCCOptionPKCS7Padding error:outError];
}

@end


static void GXAdjustKeyLengths(CCAlgorithm algorithm, NSMutableData *keyData, NSMutableData *ivData) {
    NSUInteger keyLength = [keyData length];
    switch (algorithm) {
        case kCCAlgorithmAES128: {
            if (keyLength < 16) {
                [keyData setLength:16];
            }
            else if (keyLength < 24) {
                [keyData setLength:24];
            }
            else {
                [keyData setLength:32];
            }
            break;
        }
        case kCCAlgorithmDES: {
            [keyData setLength:8];
            break;
        }
        case kCCAlgorithm3DES: {
            [keyData setLength:24];
            break;
        }
        case kCCAlgorithmCAST: {
            if (keyLength < 5) {
                [keyData setLength:5];
            }
            else if (keyLength > 16) {
                [keyData setLength:16];
            }
            break;
        }
        case kCCAlgorithmRC4: {
            if (keyLength > 512) {
                [keyData setLength:512];
            }
            break;
        }
        default: {
            break;
        }
    }
    [ivData setLength:[keyData length]];
}

