 
//   Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//




#ifndef GTM_HTTPFETCHER_ENABLE_LOGGING
# define GTM_HTTPFETCHER_ENABLE_LOGGING 1
#endif // GTM_HTTPFETCHER_ENABLE_LOGGING
#ifndef GTM_HTTPFETCHER_ENABLE_INPUTSTREAM_LOGGING
# define GTM_HTTPFETCHER_ENABLE_INPUTSTREAM_LOGGING 0
#endif // GTM_HTTPFETCHER_ENABLE_INPUTSTREAM_LOGGING



#ifndef _GTMDevLog

#ifdef DEBUG
 #define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
 #define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

@class NSString;
extern void _GTMUnittestDevLog(NSString *format, ...);

#ifndef _GTMDevAssert
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                    \
  do {                                                                   \
    if (!(condition)) {                                                  \
      [[NSAssertionHandler currentHandler]                               \
          handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__] \
                             file:[NSString stringWithCString:__FILE__]  \
                       lineNumber:__LINE__                               \
                      description:__VA_ARGS__];                          \
    }                                                                    \
  } while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert


#ifndef _GTMCompileAssert

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
  typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert



#include <TargetConditionals.h>
#if TARGET_OS_IPHONE // iPhone SDK
  // For iPhone specific stuff
  #define GTM_IPHONE_SDK 1
#else
  // For MacOS specific stuff
  #define GTM_MACOS_SDK 1
#endif

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
 // NSInteger/NSUInteger and Max/Mins
 #ifndef NSINTEGER_DEFINED
  #if __LP64__ || NS_BUILD_32_LIKE_64
   typedef long NSInteger;
   typedef unsigned long NSUInteger;
  #else
   typedef int NSInteger;
   typedef unsigned int NSUInteger;
  #endif
  #define NSIntegerMax    LONG_MAX
  #define NSIntegerMin    LONG_MIN
  #define NSUIntegerMax   ULONG_MAX
  #define NSINTEGER_DEFINED 1
 #endif  // NSINTEGER_DEFINED
 // CGFloat
 #ifndef CGFLOAT_DEFINED
  #if defined(__LP64__) && __LP64__
   // This really is an untested path (64bit on Tiger?)
   typedef double CGFloat;
   #define CGFLOAT_MIN DBL_MIN
   #define CGFLOAT_MAX DBL_MAX
   #define CGFLOAT_IS_DOUBLE 1
  #else /* !defined(__LP64__) || !__LP64__ */
   typedef float CGFloat;
   #define CGFLOAT_MIN FLT_MIN
   #define CGFLOAT_MAX FLT_MAX
   #define CGFLOAT_IS_DOUBLE 0
  #endif /* !defined(__LP64__) || !__LP64__ */
  #define CGFLOAT_DEFINED 1
 #endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
