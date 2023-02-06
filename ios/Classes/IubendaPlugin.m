#import "IubendaPlugin.h"
#if __has_include(<iubenda_plugin/iubenda_plugin-Swift.h>)
#import <iubenda_plugin/iubenda_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "iubenda_plugin-Swift.h"
#endif

@implementation IubendaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIubendaPlugin registerWithRegistrar:registrar];
}
@end
