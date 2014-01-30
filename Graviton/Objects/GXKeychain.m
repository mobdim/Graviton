//
//  GXKeychain.m
//  Graviton
//
//  Created by Logan Collins on 1/27/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import "GXKeychain.h"


NSString * const GXKeychainErrorDomain = @"GXKeychainErrorDomain";


@implementation GXKeychain {
#if TARGET_OS_IPHONE
    CFTypeRef _keychainRef;
#else
    SecKeychainRef _keychainRef;
#endif
}

+ (GXKeychain *)defaultKeychain {
    static GXKeychain *defaultKeychain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultKeychain = [[self alloc] init];
    });
    return defaultKeychain;
}

#if !TARGET_OS_IPHONE

+ (GXKeychain *)keychainWithPath:(NSString *)path {
    GXKeychain *keychain = nil;
    SecKeychainRef keychainRef = NULL;
    OSStatus status = SecKeychainOpen([path fileSystemRepresentation], &keychainRef);
    if (status == noErr) {
        keychain = [[self alloc] initWithKeychainRef:keychainRef];
        CFRelease(keychainRef);
    }
    return keychain;
}

- (id)init {
    return [self initWithKeychainRef:NULL];
}

- (id)initWithKeychainRef:(SecKeychainRef)keychainRef {
    self = [super init];
    if (self) {
        if (keychainRef != NULL) {
            _keychainRef = (SecKeychainRef)CFRetain(keychainRef);
        }
    }
    return self;
}

#endif

- (void)dealloc {
    if (_keychainRef != NULL) {
        CFRelease(_keychainRef);
    }
}


#pragma mark -
#pragma mark Attributes

- (NSDictionary *)attributesOfFirstItemMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)outError {
	OSStatus status = noErr;
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[attributeQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [attributeQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFDictionaryRef attributeResult = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != NULL) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
	return CFBridgingRelease(attributeResult);
}

- (NSArray *)attributesOfItemsMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)outError {
	OSStatus status = noErr;
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	[attributeQuery setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [attributeQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFArrayRef attributeResults = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResults);
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != NULL) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
	return CFBridgingRelease(attributeResults);
}


#pragma mark -
#pragma mark Data

- (NSData *)dataForFirstItemMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)outError {
	OSStatus status = noErr;
	
	NSMutableDictionary *dataQuery = [query mutableCopy];
	[dataQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	[dataQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [dataQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFDataRef resultsRef = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)dataQuery, (CFTypeRef *)&resultsRef);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			if (outError != nil) {
				*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
			}
		}
		return nil;
	}
	
	return CFBridgingRelease(resultsRef);
}

- (NSArray *)dataForItemsMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)outError {
	OSStatus status = noErr;
	
	NSMutableDictionary *dataQuery = [query mutableCopy];
	[dataQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	[dataQuery setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [dataQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFArrayRef resultsRef = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)dataQuery, (CFTypeRef *)&resultsRef);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			if (outError != nil) {
				*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
			}
		}
		return nil;
	}
	
	return CFBridgingRelease(resultsRef);
}


#pragma mark -
#pragma mark Persistent References

- (NSData *)persistentReferenceForFirstItemMatchingQuery:(NSDictionary *)query error:(NSError **)outError {
	OSStatus status = noErr;
	
	NSMutableDictionary *dataQuery = [query mutableCopy];
	[dataQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnPersistentRef];
	[dataQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [dataQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFDataRef resultsRef = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)dataQuery, (CFTypeRef *)&resultsRef);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			if (outError != nil) {
				*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
			}
		}
		return nil;
	}
	
	return CFBridgingRelease(resultsRef);
}

- (NSArray *)persistentReferencesForItemsMatchingQuery:(NSDictionary *)query error:(NSError **)outError {
	OSStatus status = noErr;
	
	NSMutableDictionary *dataQuery = [query mutableCopy];
	[dataQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnPersistentRef];
	[dataQuery setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [dataQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	CFArrayRef resultsRef = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)dataQuery, (CFTypeRef *)&resultsRef);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			if (outError != nil) {
				*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
			}
		}
		return nil;
	}
	
	return CFBridgingRelease(resultsRef);
}


#pragma mark -
#pragma mark Updating

- (NSData *)createItemWithData:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError {
	OSStatus status = noErr;
	
	// Create a new entry
	NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionaryWithDictionary:attributes];
	if (data != nil) {
		[attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];
	}
    
    if (_keychainRef != NULL) {
        [attributesToUpdate setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	[attributesToUpdate setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnPersistentRef];
	
	CFTypeRef resultRef = NULL;
	status = SecItemAdd((__bridge CFDictionaryRef)attributesToUpdate, &resultRef);
	
	if (status != noErr) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return nil;
	}
	
	return CFBridgingRelease(resultRef);
}

- (BOOL)updateItemWithPersistentReference:(NSData *)persistentReference data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError {
	NSParameterAssert(persistentReference != nil);
	
	OSStatus status = noErr;
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:@[persistentReference] forKey:(__bridge id)kSecMatchItemList];
	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
	[query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [query setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	// Update the existing item
	NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionaryWithDictionary:attributes];
	if (data != nil) {
		[attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];
	}
	
	status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
	
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

- (BOOL)updateAllItemsMatchingQuery:(NSDictionary *)query data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError {
    NSParameterAssert(query != nil);
    
	OSStatus status = noErr;
    
    NSMutableDictionary *attributeQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    if (_keychainRef != NULL) {
        [attributeQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	// Update the existing item
	NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionaryWithDictionary:attributes];
	if (data != nil) {
		[attributesToUpdate setObject:data forKey:(__bridge id)kSecValueData];
	}
	
	status = SecItemUpdate((__bridge CFDictionaryRef)attributeQuery, (__bridge CFDictionaryRef)attributesToUpdate);
	
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

- (BOOL)createOrUpdateAllItemsMatchingQuery:(NSDictionary *)query data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError {
    BOOL success = NO;
    
    NSError *error = nil;
    NSDictionary *queryAttributes = [self attributesOfFirstItemMatchingQuery:query error:&error];
    if (queryAttributes != nil) {
        success = [self updateAllItemsMatchingQuery:query data:data attributes:attributes error:&error];
    }
    else if (error == nil) {
        success = ([self createItemWithData:data attributes:attributes error:&error] != nil);
    }
    
    if (outError != NULL) {
        *outError = error;
    }
    
    return success;
}

- (BOOL)removeItemWithPersistentReference:(NSData *)persistentReference error:(NSError **)outError {
	OSStatus status = noErr;
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:@[persistentReference] forKey:(__bridge id)kSecMatchItemList];
	[query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnRef];
	[query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    if (_keychainRef != NULL) {
        [query setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != nil) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

- (BOOL)removeAllItemsMatchingQuery:(NSDictionary *)query error:(NSError *__autoreleasing *)outError {
	OSStatus status = noErr;
    
    NSMutableDictionary *attributeQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    if (_keychainRef != NULL) {
        [attributeQuery setObject:(__bridge id)_keychainRef forKey:(__bridge id)kSecUseKeychain];
    }
	
	status = SecItemDelete((__bridge CFDictionaryRef)attributeQuery);
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != nil) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

@end


@implementation GXKeychain (GXKeychainPasswords)

- (NSString *)passwordForAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query error:(NSError **)outError {
    NSParameterAssert(service != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassGenericPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:service forKey:kSecAttrService];
    
    NSData *data = [self dataForFirstItemMatchingQuery:dataQuery error:outError];
    if (data != nil) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}

- (BOOL)setPassword:(NSString *)password forAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query attributes:(NSDictionary *)attributes error:(NSError **)outError {
    NSParameterAssert(service != nil);
    NSParameterAssert(password != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassGenericPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:service forKey:kSecAttrService];
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    return [self createOrUpdateAllItemsMatchingQuery:dataQuery data:data attributes:attributes error:outError];
}

- (BOOL)removePasswordForAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query error:(NSError **)outError {
    NSParameterAssert(service != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassGenericPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:service forKey:kSecAttrService];
    
    return [self removeAllItemsMatchingQuery:dataQuery error:outError];
}

@end


@implementation GXKeychain (GXKeychainInternetPasswords)

- (NSString *)internetPasswordForAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query error:(NSError **)outError {
    NSParameterAssert(server != nil);
    NSParameterAssert(protocol != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassInternetPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:server forKey:kSecAttrServer];
    [dataQuery setObject:(__bridge id)protocol forKey:kSecAttrProtocol];
    
    NSData *data = [self dataForFirstItemMatchingQuery:dataQuery error:outError];
    if (data != nil) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}

- (BOOL)setInternetPassword:(NSString *)password forAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query attributes:(NSDictionary *)attributes error:(NSError **)outError {
    NSParameterAssert(server != nil);
    NSParameterAssert(protocol != nil);
    NSParameterAssert(password != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassInternetPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:server forKey:kSecAttrServer];
    [dataQuery setObject:(__bridge id)protocol forKey:kSecAttrProtocol];
    
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    return [self createOrUpdateAllItemsMatchingQuery:dataQuery data:data attributes:attributes error:outError];
}

- (BOOL)removeInternetPasswordForAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query error:(NSError **)outError {
    NSParameterAssert(server != nil);
    NSParameterAssert(protocol != nil);
    
    NSMutableDictionary *dataQuery = [NSMutableDictionary dictionaryWithDictionary:query];
    [dataQuery setObject:kSecClassInternetPassword forKey:kSecClass];
    if (account != nil) {
        [dataQuery setObject:account forKey:kSecAttrAccount];
    }
    [dataQuery setObject:server forKey:kSecAttrServer];
    [dataQuery setObject:(__bridge id)protocol forKey:kSecAttrProtocol];
    
    return [self removeAllItemsMatchingQuery:dataQuery error:outError];
}

@end
