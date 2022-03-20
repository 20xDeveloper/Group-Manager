import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './ScreenArguments.dart';


class InfoCardDetails extends StatefulWidget {
  static const routeName = "/news/details";

  @override
  _InfoCardDetailsState createState() => _InfoCardDetailsState();
}

class _InfoCardDetailsState extends State<InfoCardDetails> {

 num _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
   final ScreenArguments args = ModalRoute.of(context).settings.arguments;


    return  Scaffold(
        appBar: AppBar(
            title: Text(args.webURL),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: IndexedStack(
          index: _stackToView, // this is where i left off. I need to have an event handler to change this to 0 when the page is loaded. Here is a link that will help you do that: https://stackoverflow.com/questions/54698124/flutter-how-to-show-a-circularprogressindicator-before-webview-loads-de-page as long as it works It's good.
          children: <Widget>[
            WebView(
              initialUrl: args.webURL,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: _handleLoad,
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}