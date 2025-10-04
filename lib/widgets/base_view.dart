import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'cycling_drawer.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showBackButton;
  final bool showDrawer;

  const BaseView({
    super.key, 
    required this.title, 
    required this.body,
    this.showBackButton = true,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              )
            : showDrawer
                ? null // Deja que Flutter maneje automáticamente el icono del drawer
                : const SizedBox(),
      ),
      drawer: showDrawer ? const CyclingDrawer() : null,
      body: body,
    );
  }
}
