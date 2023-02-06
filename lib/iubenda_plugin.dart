import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iubenda_plugin/cache.dart';

import 'iubenda_plugin_platform_interface.dart';

class IubendaPlugin {
  static final CacheClient _cacheClient = CacheClient();
  static final IubendaPlugin _iubendaPlugin = IubendaPlugin();


  Future<String?> getPlatformVersion() async {
    final String? version = await IubendaPluginPlatform.instance.getPlatformVersion();
    return version;
  }

  Future<bool> getUserConsent() async {
    final bool consent = await IubendaPluginPlatform.instance.getUserConsent();
    return consent;
  }

  static bool hasUserConsent() {
    return _cacheClient.read(key: 'consent') ?? false;
  }

  static void checkConsent() async {
    final consent = await _iubendaPlugin.getUserConsent();
    _cacheClient.write(key: "consent", value: consent);
  }
}
