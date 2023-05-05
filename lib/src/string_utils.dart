import 'dart:convert';

class StrUtls {
  static String printMap(Map<dynamic, dynamic> map) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(map);

    print(prettyprint);

    return prettyprint;
  }

  static String printList(List<Map<dynamic, dynamic>> list) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(list);

    print(prettyprint);

    return prettyprint;
  }

  // returns '' if null
  static String trim(String? inString) {
    if (inString == null) {
      return '';
    }

    return inString.trim();
  }

  // copied from:
  // https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/lib/src/utilities/strings.dart.
  static bool isBlank(String? str) {
    if (str == null || str.isEmpty) {
      return true;
    }

    return str.codeUnits.every(isSpace);
  }

  static bool isDigit(int c) {
    return c >= 0x30 && c <= 0x39;
  }

  static String digitsOnly(String str) {
    final List<int> digits = [];

    final chars = str.codeUnits;
    for (final c in chars) {
      if (isDigit(c)) {
        digits.add(c);
      }
    }

    if (digits.isNotEmpty) {
      return String.fromCharCodes(digits);
    }

    return '';
  }

  static String lettersOnly(String str) {
    final List<int> letters = [];

    final chars = str.codeUnits;
    for (final c in chars) {
      if (isLetter(c)) {
        letters.add(c);
      }
    }

    if (letters.isNotEmpty) {
      return String.fromCharCodes(letters);
    }

    return '';
  }

  static bool isEOL(int c) {
    return c == 0x0D || c == 0x0A;
  }

  static bool isLetter(int c) {
    return (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
  }

  static bool isLetterOrDigit(int c) {
    return isLetter(c) || isDigit(c);
  }

  static bool isSpace(int c) => c == 0x20 || c == 0x09;

  static bool isWhitespace(int c) {
    return isSpace(c) || isEOL(c);
  }

  static String? removeEnd(String? str, String? remove) {
    if (str == null || str.isEmpty || remove == null || remove.isEmpty) {
      return str;
    }
    if (str.endsWith(remove)) {
      return str.substring(0, str.length - remove.length);
    }

    return str;
  }

  static String repeat(String s, int n) {
    final sb = StringBuffer();
    for (var i = 0; i < n; i++) {
      sb.write(s);
    }

    return sb.toString();
  }

  /// If the [text] length is above the [limit], replace the middle with `...`.
  static String shorten(String text, int limit) {
    if (text.length > limit) {
      final headLength = limit ~/ 2 - 1;
      final tailLength = limit - headLength - 3;

      return '${text.substring(0, headLength)}...${text.substring(text.length - tailLength)}';
    }

    return text;
  }
}
