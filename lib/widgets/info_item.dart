import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final String text;

  const InfoItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text),
    );
  }
}
