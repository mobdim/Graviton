//
//  GXReachability.m
//  Graviton
//
//  Created by Logan Collins on 1/18/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "GXReachability.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


NSString * const GXReachabilityStatusDidChangeNotification = @"GXReachabilityStatusDidChangeNotification";


static void GXReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void * info);


@implementation GXReachability {
    SCNetworkReachabilityRef _reachabilityRef;
    BOOL _notificationsEnabled;
    NSUInteger _notificationCount;
}

+ (GXReachability *)reachability {
    return [[self alloc] init];
}

+ (GXReachability *)reachabilityWithHost:(NSString *)host {
    GXReachability *reachability = nil;
    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
    if (reachabilityRef != NULL) {
        reachability = [[GXReachability alloc] initWithReachabilityRef:reachabilityRef];
        CFRelease(reachabilityRef);
    }
    return reachability;
}

- (id)init {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    GXReachability *reachability = nil;
    SCNetworkReachabilityRef reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr *)(&zeroAddress));
    if (reachabilityRef != NULL) {
        reachability = [self initWithReachabilityRef:reachabilityRef];
        CFRelease(reachabilityRef);
    }
    else {
        return nil;
    }
    
    return reachability;
}

- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef {
    self = [super init];
    if (self) {
        _reachabilityRef = CFRetain(reachabilityRef);
        _notificationCount = 0;
    }
    return self;
}

- (void)dealloc {
    if (_notificationsEnabled) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    if (_reachabilityRef != NULL) {
        CFRelease(_reachabilityRef);
    }
}

- (BOOL)isReachable {
    BOOL reachable = NO;
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        if (flags & kSCNetworkReachabilityFlagsReachable) {
            reachable = YES;
        }
    }
    return reachable;
}

#if TARGET_OS_IPHONE

- (BOOL)requiresCellularAccess {
    BOOL requiresCellularAccess = NO;
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(_reachabilityRef, &flags)) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            requiresCellularAccess = YES;
        }
    }
    return requiresCellularAccess;
}

#endif

- (void)enableNotifications {
    if (_notificationCount == 0) {
        _notificationsEnabled = YES;
        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        SCNetworkReachabilitySetCallback(_reachabilityRef, GXReachabilityCallback, &context);
        SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    _notificationCount++;
}

- (void)disableNotifications {
    if (_notificationCount == 0) {
        return;
    }
    _notificationCount--;
    if (_notificationCount == 0) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        _notificationsEnabled = NO;
    }
}

- (void)handleReachabilityCallbackWithFlags:(SCNetworkReachabilityFlags)flags {
    [[NSNotificationCenter defaultCenter] postNotificationName:GXReachabilityStatusDidChangeNotification object:self];
}

@end


static void GXReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void * info) {
    GXReachability *reachability = (__bridge GXReachability *)info;
    [reachability handleReachabilityCallbackWithFlags:flags];
}
