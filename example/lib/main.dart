import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iubenda_plugin/iubenda_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  // final _iubendaPlugin = IubendaPlugin();

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    chechConsent();
  }

  chechConsent() {
    Future.delayed(const Duration(seconds: 5), () {
      IubendaPlugin.checkConsent(siteId: "2938102", cookiesId: "87278796");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     platformVersion =
  //         await _iubendaPlugin.getPlatformVersion() ?? 'Unknown platform version';
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldMessenger(
        key: _messangerKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Running on: $_platformVersion\n'),
                Builder(
                  builder: (context) {
                    return TextButton(
                        onPressed: () {
                          _navigateToNextScreen(context);
                        },
                        child: Text('consent'),
                    );
                  }
                ),
                // IubendaPlugin.build(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                final consent = IubendaPlugin.hasUserConsent();
                print("consent is $consent");
              },
              child: Text('consent'),
            ),
            TextButton(
              onPressed: () {
                final consent = IubendaPlugin.openPreferencesWindow();
              },
              child: Text('show consent'),
            ),
          ],
        ),
      ),
    );
  }
}
