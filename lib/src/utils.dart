import 'dart:io';
import 'dart:math';

import 'package:path/path.dart' as p;

class Utls {
  static final Random _random = Random();

  static String uniqueFirestoreId() {
    const int idLength = 20;
    const String alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = alphabet.length;

    for (int i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }

  static String uniqueFileName(String name, String directoryPath) {
    int nameIndex = 1;
    final String fileName = name;
    String tryDirName = fileName;

    String destFile = p.join(directoryPath, tryDirName);
    while (File(destFile).existsSync() || Directory(destFile).existsSync()) {
      // test-1.xyz
      final String baseName = p.basenameWithoutExtension(fileName);
      final String extension = p.extension(fileName);

      tryDirName = '$baseName-$nameIndex$extension';
      destFile = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFile;
  }

  static String uniqueDirName(String name, String directoryPath) {
    int nameIndex = 1;
    final String dirName = p.basenameWithoutExtension(name);
    String tryDirName = dirName;

    String destFolder = p.join(directoryPath, tryDirName);
    while (
        File(destFolder).existsSync() || Directory(destFolder).existsSync()) {
      tryDirName = '$dirName-$nameIndex';
      destFolder = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFolder;
  }

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

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }

  // removes null value, empty strings, empty lists, empty maps
  static dynamic removeNulls(dynamic params) {
    if (params is Map) {
      final result = <dynamic, dynamic>{};

      params.forEach((dynamic key, dynamic value) {
        final dynamic val = removeNulls(value);
        if (val != null) {
          result[key] = val;
        }
      });

      if (isNotEmpty(result)) {
        return result;
      }

      return null;
    } else if (params is List) {
      final result = <dynamic>[];

      for (final val in params) {
        final dynamic v = removeNulls(val);
        if (v != null) {
          result.add(v);
        }
      }

      if (isNotEmpty(result)) {
        return result;
      }

      return null;
    } else if (params is String) {
      if (isNotEmpty(params)) {
        return params;
      }

      return null;
    }

    return params;
  }
}
