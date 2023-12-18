import 'package:flutter/material.dart';

class Pastille extends StatelessWidget {
  final String lettre;
  final Color color;

  Pastille({super.key, required this.lettre, required this.color}) {
    print('key ' + key.toString());
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 50,
        decoration: TextDecoration.none);
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          lettre,
          style: style,
        ),
      ),
    );
  }
}
