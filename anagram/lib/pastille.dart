import 'package:flutter/material.dart';

class Pastille extends StatelessWidget {
  final String lettre;
  const Pastille({super.key, required this.lettre});

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 50);
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Center(
          child: Text(
        lettre,
        style: style,
      )),
    );
  }
}
