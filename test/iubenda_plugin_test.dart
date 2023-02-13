import 'package:flutter_test/flutter_test.dart';
import 'package:iubenda_plugin/iubenda_data.dart';
import 'package:iubenda_plugin/iubenda_plugin.dart';
import 'package:iubenda_plugin/iubenda_plugin_platform_interface.dart';
import 'package:iubenda_plugin/iubenda_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIubendaPluginPlatform
    with MockPlatformInterfaceMixin
    implements IubendaPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> getUserConsent({required IubendaData iubendaData}) => Future.value(true);

}

void main() {
  final IubendaPluginPlatform initialPlatform = IubendaPluginPlatform.instance;

  test('$MethodChannelIubendaPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIubendaPlugin>());
  });

  test('getPlatformVersion', () async {
    IubendaPlugin iubendaPlugin = IubendaPlugin();
    MockIubendaPluginPlatform fakePlatform = MockIubendaPluginPlatform();
    IubendaPluginPlatform.instance = fakePlatform;

    expect(await iubendaPlugin.getPlatformVersion(), '42');
  });

  test('check_consent', () async {
    IubendaPlugin iubendaPlugin = IubendaPlugin();
    MockIubendaPluginPlatform fakePlatform = MockIubendaPluginPlatform();
    IubendaPluginPlatform.instance = fakePlatform;

    expect(await iubendaPlugin.getUserConsent(siteId: "*****", cookiesId: "******"), true);
  });
}
