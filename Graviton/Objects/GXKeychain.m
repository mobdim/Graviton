//
//  GXKeychain.m
//  Graviton
//
//  Created by Logan Collins on 1/27/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import "GXKeychain.h"


NSString * const GXKeychainErrorDomain = @"GXKeychainErrorDomain";

NSString * const GXKeychainOptionAccessGroup = @"AccessGroup";
NSString * const GXKeychainOptionSynchronizable = @"Synchronizable";


@implementation GXKeychain

+ (GXKeychain *)defaultKeychain {
    static GXKeychain *defaultKeychain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultKeychain = [[self alloc] init];
    });
    return defaultKeychain;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark -
#pragma mark Data

- (NSData *)dataForUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	NSParameterAssert(serviceName != nil);
	
	OSStatus status = noErr;
	
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	
	// Set up a query dictionary with the base query attributes
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
								  serviceName, (__bridge id)kSecAttrService,
                                  (__bridge id)kSecAttrSynchronizableAny, (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	
	CFDictionaryRef attributeResult = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
	
    if (attributeResult != NULL) {
        CFRelease(attributeResult);
    }
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != NULL) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
	// We have an existing item, now query for the password data associated with it
	CFDataRef resultDataCF = NULL;
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
	status = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultDataCF);
	
	NSData *resultData = CFBridgingRelease(resultDataCF);
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != nil) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
	return resultData;
}

- (BOOL)setData:(NSData *)data forUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	NSParameterAssert(serviceName != nil);
	
	OSStatus status = noErr;
	
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	NSNumber *synchronizable = [options objectForKey:GXKeychainOptionSynchronizable];
	
	// Set up a query dictionary with the base query attributes
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
								  serviceName, (__bridge id)kSecAttrService,
                                  (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	
	CFDictionaryRef attributeResult = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
	
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	if (attributeResult != nil) {
		// Update the existing item
        NSMutableDictionary *updateQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											(__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
											serviceName, (__bridge id)kSecAttrService,
											serviceName, (__bridge id)kSecAttrLabel,
                                            (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
											nil];
		
		if (username != nil) {
			[updateQuery setObject:username forKey:(__bridge id)kSecAttrAccount];
		}
        if (accessGroup != nil) {
            [updateQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
        
        status = SecItemUpdate((__bridge CFDictionaryRef)updateQuery, (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData]);
	}
	else {
		// Create a new entry
		NSMutableDictionary *addQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
										 serviceName, (__bridge id)kSecAttrService,
										 serviceName, (__bridge id)kSecAttrLabel,
										 data, (__bridge id)kSecValueData,
										 (__bridge id)kSecAttrAccessibleWhenUnlocked, (__bridge id)kSecAttrAccessible,
										 (synchronizable != nil ? synchronizable : [NSNumber numberWithBool:NO]), (__bridge id)kSecAttrSynchronizable,
										 nil];
		
		if (username != nil) {
			[addQuery setObject:username forKey:(__bridge id)kSecAttrAccount];
		}
		if (accessGroup != nil) {
			[addQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
		}
		
		status = SecItemAdd((__bridge CFDictionaryRef)addQuery, NULL);
	}
    
    if (attributeResult != NULL) {
        CFRelease(attributeResult);
    }
	
	if (status != noErr) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

- (BOOL)removeDataForUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	NSNumber *synchronizable = [options objectForKey:GXKeychainOptionSynchronizable];
	
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
								  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                                  (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (serviceName != nil) {
		[query setObject:serviceName forKey:(__bridge id)kSecAttrService];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != noErr) {
		if (outError != nil) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}


#pragma mark -
#pragma mark Passwords

- (NSString *)passwordForUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	NSData *data = [self dataForUsername:username service:serviceName options:options error:outError];
	if (data == nil) {
		return nil;
	}
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return string;
}

- (BOOL)setPassword:(NSString *)password forUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
	return [self setData:data forUsername:username service:serviceName options:options error:outError];
}

- (BOOL)removePasswordForUsername:(NSString *)username service:(NSString *)serviceName options:(NSDictionary *)options error:(NSError **)outError {
	return [self removeDataForUsername:username service:serviceName options:options error:outError];
}


#pragma mark -
#pragma mark Internet Passwords

- (NSString *)internetPasswordForUsername:(NSString *)username server:(NSString *)server protocol:(CFTypeRef)protocol options:(NSDictionary *)options error:(NSError **)outError {
	NSParameterAssert(server != nil);
	NSParameterAssert(protocol != NULL);
	
	OSStatus status = noErr;
	
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	NSNumber *synchronizable = [options objectForKey:GXKeychainOptionSynchronizable];
	
	// Set up a query dictionary with the base query attributes
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassInternetPassword, (__bridge id)kSecClass,
								  server, (__bridge id)kSecAttrServer,
                                  protocol, (__bridge id)kSecAttrProtocol,
                                  (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	
	CFDictionaryRef attributeResult = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
	
    if (attributeResult != NULL) {
        CFRelease(attributeResult);
    }
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != NULL) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
	// We have an existing item, now query for the password data associated with it
	CFDataRef resultDataCF = NULL;
	NSMutableDictionary *passwordQuery = [query mutableCopy];
	[passwordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
	status = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultDataCF);
	
	NSData *resultData = CFBridgingRelease(resultDataCF);
	
	if (status != noErr) {
        if (status != errSecItemNotFound) {
            if (outError != nil) {
                *outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
            }
        }
		return nil;
	}
	
    NSString *string = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	return string;
}

- (BOOL)setInternetPassword:(NSString *)password forUsername:(NSString *)username server:(NSString *)server protocol:(CFTypeRef)protocol options:(NSDictionary *)options error:(NSError **)outError {
	NSParameterAssert(server != nil);
	NSParameterAssert(protocol != NULL);
	
	OSStatus status = noErr;
	
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	NSNumber *synchronizable = [options objectForKey:GXKeychainOptionSynchronizable];
	
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
	
	// Set up a query dictionary with the base query attributes
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassInternetPassword, (__bridge id)kSecClass,
								  server, (__bridge id)kSecAttrServer,
                                  protocol, (__bridge id)kSecAttrProtocol,
                                  (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	// First do a query for attributes
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
	
	CFDictionaryRef attributeResult = NULL;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult);
	
	if (status != noErr && status != errSecItemNotFound) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	if (attributeResult != nil) {
		// Update the existing item
        NSMutableDictionary *updateQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											(__bridge id)kSecClassInternetPassword, (__bridge id)kSecClass,
											server, (__bridge id)kSecAttrServer,
											server, (__bridge id)kSecAttrLabel,
											protocol, (__bridge id)kSecAttrProtocol,
											(__bridge id)kSecAttrAccessibleWhenUnlocked, (__bridge id)kSecAttrAccessible,
											(synchronizable != nil ? synchronizable : [NSNumber numberWithBool:NO]), (__bridge id)kSecAttrSynchronizable,
											nil];
        
		if (username != nil) {
			[query setObject:username forKey:(__bridge id)kSecAttrAccount];
		}
        if (accessGroup != nil) {
            [updateQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
        }
        
        status = SecItemUpdate((__bridge CFDictionaryRef)updateQuery, (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData]);
	}
	else {
		// Create a new entry
		NSMutableDictionary *addQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 (__bridge id)kSecClassInternetPassword, (__bridge id)kSecClass,
										 server, (__bridge id)kSecAttrServer,
										 server, (__bridge id)kSecAttrLabel,
										 protocol, (__bridge id)kSecAttrProtocol,
										 data, (__bridge id)kSecValueData,
										 (__bridge id)kSecAttrAccessibleWhenUnlocked, (__bridge id)kSecAttrAccessible,
										 (synchronizable != nil ? synchronizable : [NSNumber numberWithBool:NO]), (__bridge id)kSecAttrSynchronizable,
										 nil];
		
		if (username != nil) {
			[addQuery setObject:username forKey:(__bridge id)kSecAttrAccount];
		}
		if (accessGroup != nil) {
			[addQuery setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
		}
		
		status = SecItemAdd((__bridge CFDictionaryRef)addQuery, NULL);
	}
    
    if (attributeResult != NULL) {
        CFRelease(attributeResult);
    }
	
	if (status != noErr) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

- (BOOL)removeInternetPasswordForUsername:(NSString *)username server:(NSString *)server protocol:(CFTypeRef)protocol options:(NSDictionary *)options error:(NSError **)outError {
	NSParameterAssert(server != nil);
	NSParameterAssert(protocol != NULL);
	
	NSString *accessGroup = [options objectForKey:GXKeychainOptionAccessGroup];
	NSNumber *synchronizable = [options objectForKey:GXKeychainOptionSynchronizable];
	
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  (__bridge id)kSecClassInternetPassword, (__bridge id)kSecClass,
								  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
								  server, (__bridge id)kSecAttrServer,
                                  protocol, (__bridge id)kSecAttrProtocol,
                                  (synchronizable != nil ? synchronizable : (__bridge id)kSecAttrSynchronizableAny), (__bridge id)kSecAttrSynchronizable,
								  nil];
	
	if (username != nil) {
		[query setObject:username forKey:(__bridge id)kSecAttrAccount];
	}
	if (accessGroup != nil) {
		[query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
	}
	
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != noErr) {
		if (outError != nil) {
			*outError = [NSError errorWithDomain:GXKeychainErrorDomain code:status userInfo:nil];
		}
		return NO;
	}
	
	return YES;
}

@end
