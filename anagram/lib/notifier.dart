import 'package:flutter/material.dart';

ValueNotifier<int> selectedLine = ValueNotifier<int>(0);

ValueNotifier<GameAction> playerChoice =
    ValueNotifier<GameAction>(GameAction.wait);

// Valeurs possibles à transmettre lors d'une action de jeu
enum GameAction { valid, cancel, wait }
