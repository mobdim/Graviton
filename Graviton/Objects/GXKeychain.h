//
//  GXKeychain.h
//  Graviton
//
//  Created by Logan Collins on 1/27/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface GXKeychain : NSObject

+ (GXKeychain *)defaultKeychain;

#if !TARGET_OS_IPHONE
+ (GXKeychain *)keychainWithPath:(NSString *)path;
- (id)initWithKeychainRef:(SecKeychainRef)keychainRef;
#endif

// Attributes
- (NSDictionary *)attributesOfFirstItemMatchingQuery:(NSDictionary *)query error:(NSError **)outError;
- (NSArray *)attributesOfItemsMatchingQuery:(NSDictionary *)query error:(NSError **)outError;

// Data
- (NSData *)dataForFirstItemMatchingQuery:(NSDictionary *)query error:(NSError **)outError;
- (NSArray *)dataForItemsMatchingQuery:(NSDictionary *)query error:(NSError **)outError;

// Persistent references
- (NSData *)persistentReferenceForFirstItemMatchingQuery:(NSDictionary *)query error:(NSError **)outError;
- (NSArray *)persistentReferencesForItemsMatchingQuery:(NSDictionary *)query error:(NSError **)outError;

// Updating
- (NSData *)createItemWithData:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError;

- (BOOL)updateItemWithPersistentReference:(NSData *)persistentReference data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError;
- (BOOL)updateAllItemsMatchingQuery:(NSDictionary *)query data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError;

- (BOOL)createOrUpdateAllItemsMatchingQuery:(NSDictionary *)query data:(NSData *)data attributes:(NSDictionary *)attributes error:(NSError **)outError;

- (BOOL)removeItemWithPersistentReference:(NSData *)persistentReference error:(NSError **)outError;
- (BOOL)removeAllItemsMatchingQuery:(NSDictionary *)query error:(NSError **)outError;

@end


// Convenience methods for kSecClassGenericPassword items
@interface GXKeychain (GXKeychainPasswords)

- (NSString *)passwordForAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query error:(NSError **)outError;
- (BOOL)setPassword:(NSString *)password forAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query attributes:(NSDictionary *)attributes error:(NSError **)outError;
- (BOOL)removePasswordForAccount:(NSString *)account service:(NSString *)service query:(NSDictionary *)query error:(NSError **)outError;

@end


// Convenience methods for kSecClassInternetPassword items
@interface GXKeychain (GXKeychainInternetPasswords)

- (NSString *)internetPasswordForAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query error:(NSError **)outError;
- (BOOL)setInternetPassword:(NSString *)password forAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query attributes:(NSDictionary *)attributes error:(NSError **)outError;
- (BOOL)removeInternetPasswordForAccount:(NSString *)account server:(NSString *)server protocol:(CFTypeRef)protocol query:(NSDictionary *)query error:(NSError **)outError;

@end


extern NSString * const GXKeychainErrorDomain;

