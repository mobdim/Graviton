//
//  GXDebug.m
//  Graviton
//
//  Created by Logan Collins on 9/3/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "GXDebug.h"


#if !DEBUG
static BOOL GXDebugLoggingEnabled = NO;
#endif


BOOL GXDebugLoggingIsEnabled() {
#if DEBUG
    return YES;
#else
    return GXDebugLoggingEnabled;
#endif
}

void GXDebugLoggingSetEnabled(BOOL enabled) {
#if DEBUG
    // no-op
#else
    GXDebugLoggingEnabled = enabled;
#endif
}

