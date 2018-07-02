#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SAFileDownloader.h"
#import "SAFileItem.h"
#import "SAFileQueue.h"
#import "SAFileListDownloader.h"
#import "SANetwork.h"

FOUNDATION_EXPORT double SANetworkingVersionNumber;
FOUNDATION_EXPORT const unsigned char SANetworkingVersionString[];

