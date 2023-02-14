import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iubenda_plugin/cache.dart';
import 'package:iubenda_plugin/iubenda_data.dart';

import 'iubenda_plugin_platform_interface.dart';

class IubendaPlugin {
  static final CacheClient _cacheClient = CacheClient();
  static final IubendaPlugin _iubendaPlugin = IubendaPlugin();


  Future<String?> getPlatformVersion() async {
    final String? version = await IubendaPluginPlatform.instance.getPlatformVersion();
    return version;
  }

  Future<bool> getUserConsent({required String siteId, required String cookiesId}) async {
    final iubendaData = IubendaData(siteId: siteId, cookiesId: cookiesId);
    final response = await IubendaPluginPlatform.instance.getUserConsent(iubendaData: iubendaData);
    final bool consent = response.consent;
    final bool isGooglePersonalised = response.isGooglePersonalised;
    _cacheClient.write(key: "consent", value: consent);
    _cacheClient.write(key: "is_google_personalised", value: isGooglePersonalised);
    return consent;
  }

  Future<bool> openPreferences() async {
    final siteId = _cacheClient.read(key: 'siteId') as String?;
    final cookiesId = _cacheClient.read(key: 'cookiesId') as String?;
    if (siteId != null && cookiesId != null) {
      final iubendaData = IubendaData(siteId: siteId, cookiesId: cookiesId, showPreferences: true);
      final response = await IubendaPluginPlatform.instance.getUserConsent(iubendaData: iubendaData);
      final bool consent = response.consent;
      final bool isGooglePersonalised = response.isGooglePersonalised;
      _cacheClient.write(key: "consent", value: consent);
      _cacheClient.write(key: "is_google_personalised", value: isGooglePersonalised);
      return consent;
    }
    return false;
  }

  static bool hasUserConsent() {
    return _cacheClient.read(key: 'consent') ?? false;
  }

  static bool isGooglePersonalised() {
    return _cacheClient.read(key: 'is_google_personalised') ?? false;
  }

  static Future<bool> checkConsent({required String siteId, required String cookiesId}) async {
    _cacheClient.write(key: "siteId", value: siteId);
    _cacheClient.write(key: "cookiesId", value: cookiesId);
    return await _iubendaPlugin.getUserConsent(siteId: siteId, cookiesId: cookiesId);
  }

  static Future<bool> openPreferencesWindow() async {
    return await _iubendaPlugin.openPreferences();
  }

}
