import 'package:flutter/material.dart';

ValueNotifier<List<String>> pickerStockNotifier =
    ValueNotifier<List<String>>([]);

ValueNotifier<int> selectedLineNotifier = ValueNotifier<int>(0);

ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

ValueNotifier<GameAction> playerChoiceNotifier =
    ValueNotifier<GameAction>(GameAction.wait);

// Valeurs possibles à transmettre lors d'une action de jeu
enum GameAction { valid, cancel, wait }
