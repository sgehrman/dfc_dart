import 'package:dfc_dart/src/utils.dart';

extension StrExts on String {
  // case insensitive compare
  bool equals(String? other) {
    if (other == null) {
      return false;
    }

    return toLowerCase() == other.toLowerCase();
  }

  String removeTrailing(String trailing) {
    // don't remove last '/' if path is '/'
    if (this != trailing) {
      if (Utls.isNotEmpty(trailing)) {
        if (endsWith(trailing)) {
          return substring(0, length - trailing.length);
        }
      }
    }

    return this;
  }
}
