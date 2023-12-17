import 'package:flutter/material.dart';

class Pastille extends StatelessWidget {
  final String lettre;
  const Pastille({super.key, required this.lettre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      color: Colors.blue,
    );
  }
}
