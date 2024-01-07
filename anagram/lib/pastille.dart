import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Pastille extends StatefulWidget {
  final String lettre;
  final Color color;
  PastAnim animation;

  Pastille({
    super.key,
    required this.lettre,
    required this.color,
    required this.animation,
  });

  @override
  State<Pastille> createState() => _PastilleState();
}

class _PastilleState extends State<Pastille> {
  @override
  Widget build(BuildContext context) {
    Widget pastille = RegExp(r'^[a-zA-Z]+$').hasMatch(widget.lettre)
        ? Image(
            image: AssetImage('assets/res/lettres/${widget.lettre}.png'),
          )
        : Text(widget.lettre);

    switch (widget.animation) {
      case PastAnim.appear:
        widget.animation = PastAnim.none;
        return pastille
            .animate()
            .scale(duration: 1000.ms, curve: Curves.easeInOutBack);
      case PastAnim.validated:
        widget.animation = PastAnim.none;
        return pastille
            .animate()
            .shimmer(duration: 500.ms, color: Colors.amber)
            .then(delay: 100.milliseconds)
            .animate(effects: List.empty());
      case PastAnim.refused:
        return pastille.animate(onComplete: (ctrl) {
          widget.animation = PastAnim.none;
          ctrl.reset();
        }).shake(duration: 1000.ms);
      case PastAnim.none:
        return pastille;
    }
  }
}

enum PastAnim { appear, validated, refused, none }
