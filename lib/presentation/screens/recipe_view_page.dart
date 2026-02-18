import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeViewPage extends StatefulWidget {
  final String url;

  const RecipeViewPage({super.key, required this.url});

  @override
  State<RecipeViewPage> createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}