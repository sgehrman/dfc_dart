import 'dart:convert';

class StrUtls {
  static String printMap(Map map) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(map);

    print(prettyprint);

    return prettyprint;
  }

  static String printList(List<Map> list) {
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
}
