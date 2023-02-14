import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:iubenda_plugin/iubenda_data.dart';

import 'iubenda_plugin_platform_interface.dart';

/// An implementation of [IubendaPluginPlatform] that uses method channels.
class MethodChannelIubendaPlugin extends IubendaPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('iubenda_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<IubendaResponse> getUserConsent({required IubendaData iubendaData}) async {
    final consent = await methodChannel.invokeMethod('check_consent', iubendaData.toJson());
    final map = jsonDecode(consent);
    final iubendaResponse = IubendaResponse(consent: map['consent'], isGooglePersonalised: map['google_ads']);
    return iubendaResponse;
  }
}
