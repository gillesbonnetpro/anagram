import 'package:flutter/services.dart' show rootBundle;

class Capello {
  static final Capello _singleton = Capello._internal();

  factory Capello() {
    return _singleton;
  }

  Capello._internal();

  Future<String> starter() {
    return Future.value('OK !!');
  }

  Future<String> loadAsset() async {
    rootBundle.loadString('assets/res/ODS231219.txt').then((value) {
      return 'dico lu';
    }).catchError((error) {
      return '$error';
    });
    return 'error';
  }
}
