
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

#import <Foundation/Foundation.h>
#import <regex.h>
#import "GTMDefines.h"

enum {

  kGTMRegexOptionIgnoreCase            = 0x01,
    // Ignore case in matching, ie: 'a' matches 'a' or 'A'

  kGTMRegexOptionSupressNewlineSupport = 0x02,
    // By default (without this option), regular expressions are implicitly
    // processed on a line by line basis, where "lines" are delimited by newline
    // characters. In this mode '.' (dot) does NOT match newline characters, and
    // '^' and '$' match at the beginning and end of the string as well as
    // around newline characters. This behavior matches the default behavior for
    // regular expressions in other languages including Perl and Python. For
    // example,
    //     foo.*bar
    // would match
    //     fooAAAbar
    // but would NOT match
    //     fooAAA\nbar
    // With the kGTMRegexOptionSupressNewlineSupport option, newlines are treated
    // just like any other character which means that '.' will match them. In
    // this mode, ^ and $ only match the beginning and end of the input string
    // and do NOT match around the newline characters. For example,
    //     foo.*bar
    // would match
    //     fooAAAbar
    // and would also match
    //     fooAAA\nbar

};
typedef NSUInteger GTMRegexOptions;


#undef _EXTERN
#undef _INITIALIZE_AS
#ifdef GTMREGEX_DEFINE_GLOBALS
#define _EXTERN 
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

_EXTERN NSString* kGTMRegexErrorDomain _INITIALIZE_AS(@"com.google.mactoolbox.RegexDomain");

enum {
  kGTMRegexPatternParseFailedError = -100
};

_EXTERN NSString* kGTMRegexPatternErrorPattern _INITIALIZE_AS(@"pattern");
_EXTERN NSString* kGTMRegexPatternErrorErrorString _INITIALIZE_AS(@"patternError");

@interface GTMRegex : NSObject {
 @private
  NSString *pattern_;
  GTMRegexOptions options_;
  regex_t regexData_;
}

+ (id)regexWithPattern:(NSString *)pattern;

+ (id)regexWithPattern:(NSString *)pattern options:(GTMRegexOptions)options;

+ (id)regexWithPattern:(NSString *)pattern
               options:(GTMRegexOptions)options
             withError:(NSError **)outErrorOrNULL;

+ (NSString *)escapedPatternForString:(NSString *)str;

- (id)initWithPattern:(NSString *)pattern;

- (id)initWithPattern:(NSString *)pattern options:(GTMRegexOptions)options;

- (id)initWithPattern:(NSString *)pattern
              options:(GTMRegexOptions)options
            withError:(NSError **)outErrorOrNULL;

- (NSUInteger)subPatternCount;

- (BOOL)matchesString:(NSString *)str;

- (NSArray *)subPatternsOfString:(NSString *)str;

- (NSString *)firstSubStringMatchedInString:(NSString *)str;

- (BOOL)matchesSubStringInString:(NSString *)str;

- (NSEnumerator *)segmentEnumeratorForString:(NSString *)str;

- (NSEnumerator *)matchSegmentEnumeratorForString:(NSString *)str;

- (NSString *)stringByReplacingMatchesInString:(NSString *)str
                               withReplacement:(NSString *)replacementPattern;

@end

@interface GTMRegexStringSegment : NSObject {
 @private
  NSData *utf8StrBuf_;
  regmatch_t *regMatches_;  // STRONG: ie-we call free
  NSUInteger numRegMatches_;
  BOOL isMatch_;
}

- (BOOL)isMatch;

- (NSString *)string;

- (NSString *)subPatternString:(NSUInteger)index;

@end

@interface NSString (GTMRegexAdditions)

- (BOOL)gtm_matchesPattern:(NSString *)pattern;

- (NSArray *)gtm_subPatternsOfPattern:(NSString *)pattern;

- (NSString *)gtm_firstSubStringMatchedByPattern:(NSString *)pattern;

- (BOOL)gtm_subStringMatchesPattern:(NSString *)pattern;

- (NSArray *)gtm_allSubstringsMatchedByPattern:(NSString *)pattern;

- (NSEnumerator *)gtm_segmentEnumeratorForPattern:(NSString *)pattern;

- (NSEnumerator *)gtm_matchSegmentEnumeratorForPattern:(NSString *)pattern;

- (NSString *)gtm_stringByReplacingMatchesOfPattern:(NSString *)pattern
                                    withReplacement:(NSString *)replacementPattern;

@end
