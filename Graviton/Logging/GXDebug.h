//
//  GXDebug.h
//  Graviton
//
//  Created by Logan Collins on 9/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


GRAVITON_EXTERN BOOL GXDebugLoggingIsEnabled();
GRAVITON_EXTERN void GXDebugLoggingSetEnabled(BOOL enabled);


#ifdef DEBUG

#define GXDebugLog(...) NSLog(@"DEBUG: %@", [NSString stringWithFormat:__VA_ARGS__]);
#define GXMethodDebugLog(...) NSLog(@"DEBUG: %@:%@, %@", [self class], NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__]);

#else

#define GXDebugLog(...) \
if (GXDebugLoggingEnabled()) { \
NSLog(@"DEBUG: %@", [NSString stringWithFormat:__VA_ARGS__]); \
}

#define GXMethodDebugLog(...) \
if (GXDebugLoggingEnabled()) { \
NSLog(@"DEBUG: %@:%@, %@", [self class], NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__]); \
}

#endif
