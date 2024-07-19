import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _WebViewScreenState();
}
class _WebViewScreenState extends State<LoginScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('http://10.0.2.2:8080/oauth2/authorization/google'),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("타이틀임"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}