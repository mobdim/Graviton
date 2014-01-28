//
//  GXKeychain.h
//  Graviton
//
//  Created by Logan Collins on 1/27/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


@interface GXKeychain : NSObject

+ (GXKeychain *)defaultKeychain;

// Data
- (NSData *)dataForUsername:(NSString *)username
					service:(NSString *)serviceName
					options:(NSDictionary *)options
					  error:(NSError **)outError;

- (BOOL)setData:(NSData *)data
	forUsername:(NSString *)username
		service:(NSString *)serviceName
		options:(NSDictionary *)options
		  error:(NSError **)outError;

- (BOOL)removeDataForUsername:(NSString *)username
					  service:(NSString *)serviceName
					  options:(NSDictionary *)options
						error:(NSError **)outError;


// Passwords
- (NSString *)passwordForUsername:(NSString *)username
                          service:(NSString *)serviceName
						  options:(NSDictionary *)options
                            error:(NSError **)outError;

- (BOOL)setPassword:(NSString *)password
        forUsername:(NSString *)username
            service:(NSString *)serviceName
			options:(NSDictionary *)options
              error:(NSError **)outError;

- (BOOL)removePasswordForUsername:(NSString *)username
						  service:(NSString *)serviceName
						  options:(NSDictionary *)options
							error:(NSError **)outError;


// Internet Passwords
- (NSString *)internetPasswordForUsername:(NSString *)username
                                   server:(NSString *)server
                                 protocol:(CFTypeRef)protocol
								  options:(NSDictionary *)options
                                    error:(NSError **)outError;

- (BOOL)setInternetPassword:(NSString *)password
                forUsername:(NSString *)username
                     server:(NSString *)server
                   protocol:(CFTypeRef)protocol
					options:(NSDictionary *)options
                      error:(NSError **)outError;

- (BOOL)removeInternetPasswordForUsername:(NSString *)username
								   server:(NSString *)server
                                 protocol:(CFTypeRef)protocol
								  options:(NSDictionary *)options
									error:(NSError **)outError;

@end


GRAVITON_EXTERN NSString * const GXKeychainErrorDomain;

GRAVITON_EXTERN NSString * const GXKeychainOptionAccessGroup;       // NSString
GRAVITON_EXTERN NSString * const GXKeychainOptionSynchronizable;    // NSNumber -> BOOL

