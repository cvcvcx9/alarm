import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginViewScreenState();
}
class _LoginViewScreenState extends State<LoginScreen> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initUriListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
void _initUriListener() {
    var _appLinks = AppLinks();
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'cvcvcx9' && uri.host == 'callback') {
        _handleLink(uri);
      }
    }, onError: (err) {
      // 오류 처리
      print(err.toString());
    });
  }
void _handleLink(Uri uri) {
    print(uri);
    final accessToken = uri.queryParameters['access_token'];
    final refreshToken = uri.queryParameters['refresh_token'];

    if (accessToken != null && refreshToken != null) {
      _saveTokens(accessToken, refreshToken);
    }
  }
   void _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);

    print('Tokens saved:');
    print('access_token: $accessToken');
    print('refresh_token: $refreshToken');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => _launchUrlLite(context),
              child: Text('Open OAuth URL'),
            ),
            ElevatedButton(
              onPressed: _getTokens,
              child: Text('안녕'),
            ),
          ],
        ),
      ),
    );
  }
   Future<void> _launchUrlLite(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await lite.launchUrl(
        Uri.parse('http://10.0.2.2.nip.io:8080/oauth2/authorization/google'),
        options: lite.LaunchOptions(
          barColor: theme.colorScheme.surface,
          onBarColor: theme.colorScheme.onSurface,
          barFixingEnabled: false,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');
    var refreshToken = prefs.getString('refresh_token');

    print('All SharedPreferences keys and values:');
    prefs.getKeys().forEach((key) {
      print('$key: ${prefs.get(key)}');
    });

    if (accessToken != null && refreshToken != null) {
      print("access_token: $accessToken");
      print("refresh_token: $refreshToken");
    } else {
      print("Tokens not found.");
    }
  }
}