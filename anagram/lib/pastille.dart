import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Pastille extends StatelessWidget {
  final String lettre;
  final Color color;
  bool animated;

  Pastille(
      {super.key,
      required this.lettre,
      required this.color,
      required this.animated});

  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 50,
      decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    Widget pastille = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              lettre,
              style: style,
            ),
          ),
        ),
      ),
    );

    if (animated) {
      animated = false;
      return pastille
          .animate()
          .scale(duration: 1000.ms, curve: Curves.easeInOutBack)
          .fadeIn(duration: 400.ms);
    } else {
      return pastille;
    }
  }
}
