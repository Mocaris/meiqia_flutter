#import "MeiqiaFlutterPlugin.h"
#if __has_include(<meiqia_flutter/meiqia_flutter-Swift.h>)
#import <meiqia_flutter/meiqia_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "meiqia_flutter-Swift.h"
#endif

@implementation MeiqiaFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMeiqiaFlutterPlugin registerWithRegistrar:registrar];
}
@end
