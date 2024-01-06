import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Pastille extends StatelessWidget {
  final String lettre;
  final Color color;
  PastAnim animation;

  Pastille(
      {super.key,
      required this.lettre,
      required this.color,
      required this.animation});

  TextStyle style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 50,
      decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    double smallWidth = MediaQuery.of(context).size.width * 0.07;
    Widget pastille = Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: smallWidth, maxWidth: smallWidth),
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

    switch (animation) {
      case PastAnim.appear:
        animation = PastAnim.none;
        return pastille
            .animate()
            .scale(duration: 1000.ms, curve: Curves.easeInOutBack);
      case PastAnim.validated:
        animation = PastAnim.none;
        return pastille
            .animate()
            .shimmer(duration: 500.ms, color: Colors.amber)
            .then(delay: 100.milliseconds)
            .animate(effects: List.empty());
      case PastAnim.refused:
        return pastille.animate(onComplete: (ctrl) {
          animation = PastAnim.none;
          ctrl.reset();
        }).shake(duration: 1000.ms);
      case PastAnim.none:
        return pastille;
    }
  }
}

enum PastAnim { appear, validated, refused, none }
