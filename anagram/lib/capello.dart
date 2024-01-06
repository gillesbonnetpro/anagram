import 'dart:convert';
import 'dart:io';

import 'package:anagram/notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Capello {
  static final Capello _singleton = Capello._internal();

  factory Capello() {
    return _singleton;
  }

  Capello._internal();

  Map<int, List<String>> dico = {};
  List<String> _pickerStock = [];
  Map<int, String> plato = {};

  Future<String?> initiate() {
    pickerStockNotifier.addListener(() {
      _pickerStock = pickerStockNotifier.value;
      //    print('stock : $_pickerStock');
    });

    //String path = './assets/res/myODS.txt';
    String path = './assets/res/agODS.txt';
    Future<String> futureContent = rootBundle.loadString(path);

    /* File file = File('./assets/res/agODS.txt');
    String agODS = ''; */

    return futureContent.then((wordList) {
      print('fichier lu. début répartition');
      print('nb mots ${wordList.length}');
      LineSplitter ls = const LineSplitter();
      List<String> list = ls.convert(wordList);

      for (String word in list) {
        if (word.length > 2 &&
            word.length < 13 &&
            RegExp(r'^[a-zA-Z]+$').hasMatch(word)) {
          if (dico[word.length] == null) {
            dico[word.length] = [];
          }
          /*     if (!agODS.contains(word)) {
            agODS += '$word\n';
          } */

          dico[word.length]!.add(word.toLowerCase());
        }
      }
      // file.writeAsString(agODS).then((value) => 'écrit $agODS');
      return 'Anna Gram';
    });
  }

// vérifie si le mot existe
  bool checkWord(int lineId, String candidate) {
    int nbLetters = candidate.length;
    if (nbLetters < 3) {
      return false;
    } else {
      print('recherche de mots : lng ${nbLetters} pour $candidate');
      print('recherche parmi ${dico[nbLetters]!.length}');
      bool isOk;
      List<String> around;

      candidate = candidate.toLowerCase();

      isOk = dico[nbLetters] == null
          ? false
          : dico[nbLetters]!.contains(candidate);

      if (!isOk) {
        around = [...dico[nbLetters]!];
        around.removeWhere((element) => element[0] != candidate[0]);
        print('initiales : $around');
      } else {
        // update plato pour le calcul des scores
        plato[lineId] = candidate;
        updateScore();
      }
      return isOk;
    }
  }

  // cherche si un mot avec une lettre de + est possible
  String searchOpti(String basis) {
    if (basis.length > 2) {
      List<String> basisLetters = [];
      List<String> solutionLetters = [];
      Map<String, List<String>> solution = {};

      // éclatement mot de base en tableau de lettres
      for (String letter in basis.characters) {
        basisLetters.add(letter);
      }

      // recherche parmi tous les mots de longueur +1
      for (var mot in dico[(basis.length + 1)]!) {
        mot = mot.toLowerCase();
        //print('test du mot $mot');
        List<String> diff = [];
        List<String> motTest = mot.split('');

        // si le mot du dico contient une lettre du mot validé
        // on la retire du mot du dico
        // sinon on l'ajoute en tant que différence
        for (var lettre in basisLetters) {
          if (motTest.contains(lettre)) {
            motTest.removeAt(motTest.indexOf(lettre));
          } else {
            diff.add(lettre);
          }
        }

        /* motTest.addAll(diff);
        if (motTest.length == 1 &&
            _pickerStock.contains(motTest.first.toLowerCase())) {
          print(
              '$basis et $mot sont séparés de ${motTest} - pioche : ${_pickerStock.contains(motTest.first.toLowerCase())}');
        } */

        // cumul des différences de lettres entre les 2 mots;
        diff.addAll(motTest);
        //print('diff $mot / $basis : $diff');

        // si une seule différence, on retient cette solution
        if (diff.length == 1 && _pickerStock.contains(diff.first)) {
          if (solution[diff.first] == null) {
            solution[diff.first] = [];
          }
          if (!solution[diff.first]!.contains(mot)) {
            print('je retiens le mot $mot pour la lettre ${diff.first}');
            solution[diff.first]!.add(mot);
          }
        }
      }

      // tous les mots sont passés en revue, on retourne
      // la lettre la plus fréquente
      solution.forEach((key, value) {
        print('lettre $key : ${value.length} mots');
      });

      // retour selon situation
      if (solution.isEmpty) {
        return 'XXX';
      } else {
        solutionLetters = solution.keys.toList();

        solutionLetters
            .sort((a, b) => solution[b]!.length - solution[a]!.length);

        print(solutionLetters.isEmpty
            ? 'pas de solution'
            : 'je retourne la lettre ${solutionLetters.first}');

        return solutionLetters.first;
      }
    } else {
      return 'XXX';
    }
  }

  // retourn le score à afficher
  void updateScore() {
    print('update score');
    int score = 0;

    plato.forEach((key, value) {
      score += value.length * value.length;
    });

    print('nouveau score de $score');
    scoreNotifier.value = score;
  }
}
