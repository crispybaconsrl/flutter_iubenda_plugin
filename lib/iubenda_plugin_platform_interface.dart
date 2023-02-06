import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'iubenda_plugin_method_channel.dart';

abstract class IubendaPluginPlatform extends PlatformInterface {
  /// Constructs a IubendaPluginPlatform.
  IubendaPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static IubendaPluginPlatform _instance = MethodChannelIubendaPlugin();

  /// The default instance of [IubendaPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelIubendaPlugin].
  static IubendaPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IubendaPluginPlatform] when
  /// they register themselves.
  static set instance(IubendaPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> getUserConsent() {
    throw UnimplementedError('getUserConsent() has not been implemented.');
  }
}
