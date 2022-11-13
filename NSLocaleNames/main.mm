//
//  main.mm
//  NSLocaleNames
//
//  Created by Olli Wang on 2022/11/13.
//

#include <cstdio>

#import <Foundation/Foundation.h>

namespace {

bool GenerateFiles(const char *output) {
  NSURL *outputURL = [NSURL
      fileURLWithPath:[NSString stringWithUTF8String:output]
      isDirectory:YES];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager createDirectoryAtURL:outputURL
             withIntermediateDirectories:YES
                              attributes:nil
                                   error:nil]) {
    fprintf(stderr, " !! Failed to create the output folder.\n");
    return false;
  }

  NSArray *locales = [[NSLocale availableLocaleIdentifiers]
      sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  for (NSString *localeID in locales) {
    NSURL *localeFolder = [outputURL URLByAppendingPathComponent:localeID
                                                     isDirectory:NO];
    NSLocale *preferredLocale = [NSLocale localeWithLocaleIdentifier:localeID];

    std::FILE *file = std::fopen(localeFolder.path.UTF8String, "w");
    if (file == nullptr) {
      return false;
    }
    for (NSString *localeID in locales) {
      NSString *name = [preferredLocale
          localizedStringForLocaleIdentifier:localeID];
      std::fprintf(file, "%s: %s\n", localeID.UTF8String, name.UTF8String);
    }
    std::fclose(file);
  }
  return true;
}

}  // namespace

int main(int argc, const char *argv[]) {
  if (argc != 2) {
    return 1;
  }

  @autoreleasepool {
    if (GenerateFiles(argv[1])) {
      return 0;
    }
  }
  return 1;
}
