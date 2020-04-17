import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import './Global.dart' as global;
import './main.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final flutterWebview = new FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;
  String token;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebview.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebview.close();
    _onUrlChanged = flutterWebview.onUrlChanged.listen((String url) {
      String token = url.split("&")[0].split("#")[1].split("=")[1];
      String username = url.split("&")[4].split("=")[1];
      global.username = username;
      global.accessToken = token;
      global.isLoggedin = true;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => MyProfile()));
      flutterWebview.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnectivity();
    if (global.hasInternet == false)
      return RaisedButton(
        color: Colors.yellow[800],
        onPressed: (){navigateHome(context);},
        child: Text('Oops, seems like internet went on holiday! Please check that you are connected and try again', style: global.bigFont ? Theme.of(context).textTheme.display2 : Theme.of(context).textTheme.body2, textAlign: TextAlign.center)
      );
    String loginUrl = "https://api.imgur.com/oauth2/authorize?client_id=9860d2d2c873582&response_type=token&state=APPLICATION_STATE";
    return new WebviewScaffold(
      url: loginUrl,
    );
   }
}