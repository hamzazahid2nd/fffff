import 'package:augmntx/components/custom_components.dart';
import 'package:augmntx/widgets/app/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../handlers/state_handler.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key});
  static const routeName = '/web-view-screen';

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  final _scrollController = ScrollController();
  var loadingPercentage = 0;
  var args;
  var isClassVisible = true;

  @override
  void initState() {
    super.initState();
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(
      () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!appBarState.isWebViewScreenScrollingDown) {
            appBarState.setWebViewScreenAppbarAndScrollState(
              appBarState: false,
              scrollState: true,
            );
          }
        }

        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (appBarState.isWebViewScreenScrollingDown) {
            appBarState.setWebViewScreenAppbarAndScrollState(
              appBarState: true,
              scrollState: false,
            );
          }
        }
      },
    );

    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)?.settings.arguments;
      });
      final url = args['url'];
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
            if (isClassVisible) {
              runJavaScriptToHideNavbar();
            }
            setState(() {
              isClassVisible = false;
            });
          },
        ))
        ..loadRequest(Uri.parse(url));
    });
  }

  Future<void> runJavaScriptToHideNavbar() async {
    try {
      final result = await controller.runJavaScriptReturningResult('''
      var navbar = document.querySelector(".navbar");
      navbar.classList.add("navbar-expand-lg", "classic", "transparent", "navbar-light", "navbar-clone", "fixed", "navbar-stick");
      navbar.style.display = "none";
    ''');
      print('JavaScript execution result: $result');
    } catch (e) {
      print('Error executing JavaScript: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Consumer<StateHandler>(
            builder: (context, state, child) => CustomComponents.showAppBar(
              show: true,
              showActionButton: true,
              showLeadingButton: true,
            ),
          ),
          if (isClassVisible)
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          else
            Expanded(
              child: WebViewWidget(controller: controller),
            )
        ],
      ),
    );
  }
}
