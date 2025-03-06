import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {

  late WebViewController controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
    ..setNavigationDelegate(NavigationDelegate(
      onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      },
      onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      },
      onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }
    ))
    ..loadRequest(Uri.parse("https://www.youtube.com/"))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "WebView",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if(await controller.canGoBack()) {
                controller.goBack();
              }
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () async {
              if(await controller.canGoForward()) {
                controller.goForward();
              }
            },
            icon: Icon(Icons.arrow_forward_ios),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              controller.reload();
            },
            icon: Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          loadingPercentage < 100 ?
              LinearProgressIndicator(
                value: loadingPercentage/100,
                color: Colors.blue,
              ) : Container()
        ]
      ),
    );
  }
}

