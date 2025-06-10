import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

class Utls {
  static final Random _random = Random();

  // -----------------------------------------------------

  static String uniqueFirestoreId() {
    const idLength = 20;
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final stringBuffer = StringBuffer();
    const maxRandom = alphabet.length;

    for (var i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }

  // -----------------------------------------------------

  static String uniqueFileName(String name, String directoryPath) {
    var nameIndex = 1;
    final fileName = name;
    var tryDirName = fileName;

    var destFile = p.join(directoryPath, tryDirName);
    while (File(destFile).existsSync() || Directory(destFile).existsSync()) {
      // test-1.xyz
      final baseName = p.basenameWithoutExtension(fileName);
      final extension = p.extension(fileName);

      tryDirName = '$baseName-$nameIndex$extension';
      destFile = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFile;
  }

  // -----------------------------------------------------

  static String uniqueDirName(String name, String directoryPath) {
    var nameIndex = 1;
    final dirName = p.basenameWithoutExtension(name);
    var tryDirName = dirName;

    var destFolder = p.join(directoryPath, tryDirName);
    while (
        File(destFolder).existsSync() || Directory(destFolder).existsSync()) {
      tryDirName = '$dirName-$nameIndex';
      destFolder = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFolder;
  }

  // -----------------------------------------------------

  // 4 -> 04,
  static String twoDigits(num n) {
    if (n >= 10 || n <= -10) {
      return '$n';
    }

    if (n < 0) {
      return '-0${n.abs()}';
    }

    return '0$n';
  }

  // -----------------------------------------------------

  static bool isNotEmpty(dynamic input) {
    if (input == null) {
      return false;
    }

    if (input is String) {
      return input.isNotEmpty;
    }

    // iterable includes List
    if (input is Iterable) {
      return input.isNotEmpty;
    }

    if (input is Map) {
      return input.isNotEmpty;
    }

    print('### isNotEmpty called on ${input.runtimeType}');

    return false;
  }

  // -----------------------------------------------------

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }

  // -----------------------------------------------------

  static String stringHash(String input) {
    final bytes = utf8.encode(input);

    return sha1.convert(bytes).toString();
  }

  // -----------------------------------------------------

  static String arrayHash(List<String> inputs) {
    return stringHash(inputs.join());
  }

  // -----------------------------------------------------
  // for JsonSerializable with dates

  static DateTime? dateTimeFromEpochUs(int? us) =>
      us == null ? null : DateTime.fromMillisecondsSinceEpoch(us);

  static int? dateTimeToEpochUs(DateTime? dateTime) =>
      dateTime?.millisecondsSinceEpoch;

  // -----------------------------------------------------

  static String keyFromString(String? input) {
    return stringHash(input ?? 'null');
  }

  // -----------------------------------------------------

  static bool isNewTab(String url) {
    // Chrome
    if (url == 'chrome://newtab/') {
      return true;
    }

    // Safari & Firefox
    if (url.endsWith('new_tab_page.html')) {
      return true;
    }

    return false;
  }
}
