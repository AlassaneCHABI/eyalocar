import 'package:eyav2/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';




class Confidentialite extends StatefulWidget {

   Confidentialite({Key? key});

  @override
  State<Confidentialite> createState() => _ConfidentialiteState();
}

class _ConfidentialiteState extends State<Confidentialite> {
  var _isLoading = false;
  late WebViewController _controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://eyalocar.com/politique-confidentialite'));
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Politique de confidentialité'),
          centerTitle: true,

        ),
        drawer: DrawerMenuWidget(),
        bottomNavigationBar: bottomNvigator(),

      body:WebViewWidget(controller: _controller),
    );
  }


}
