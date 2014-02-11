//
//  GXReachability.h
//  Graviton
//
//  Created by Logan Collins on 1/18/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


@interface GXReachability : NSObject

+ (GXReachability *)reachability;
+ (GXReachability *)reachabilityWithHost:(NSString *)host;

@property (readonly, getter=isReachable) BOOL reachable;
#if TARGET_OS_IPHONE
@property (readonly) BOOL requiresCellularAccess;
#endif

- (void)enableNotifications;
- (void)disableNotifications;

@end


GRAVITON_EXTERN NSString * const GXReachabilityStatusDidChangeNotification;
