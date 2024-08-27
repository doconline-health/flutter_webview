import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }

}

class _MyHomePageState extends State<MyHomePage> {
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri('https://abc.com')),

          initialSettings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              javaScriptEnabled: true,
              useHybridComposition: true,
              allowsInlineMediaPlayback: true,
              allowsAirPlayForMediaPlayback: true,
              allowFileAccess: true
          ),

        onWebViewCreated: (controller) {
          webViewController = controller;
        },

        onPermissionRequest: (InAppWebViewController controller, PermissionRequest request) async {
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT
          );
        },

        onLoadStart: (InAppWebViewController controller, Uri? url) {
          print("Loading started: $url");
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          print("Loading stopped: $url");
        },
        onLoadError: (controller, url, code, message) {
          print("Load Error: $message");
        },
      ),
    );
  }

  void requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }
    var statusMicrophone = await Permission.microphone.status;
    if (!statusMicrophone.isGranted) {
      await Permission.microphone.request();
    }
  }
}


