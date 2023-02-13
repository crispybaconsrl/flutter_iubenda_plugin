import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iubenda_plugin/iubenda_data.dart';
import 'package:iubenda_plugin/iubenda_plugin_method_channel.dart';

void main() {
  MethodChannelIubendaPlugin platform = MethodChannelIubendaPlugin();
  const MethodChannel channel = MethodChannel('iubenda_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == "check_consent") {
        return true;
      }

      if (methodCall.method == "getPlatformVersion") {
        return '42';
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('check_consent', () async {
    expect(await platform.getUserConsent(iubendaData: IubendaData(siteId: "*******", cookiesId: "*******")), true);
  });
}
