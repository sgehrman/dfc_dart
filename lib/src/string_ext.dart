extension StrExts on String {
  // case insensitive compare
  bool equals(String? other) {
    if (other == null) {
      return false;
    }

    return toLowerCase() == other.toLowerCase();
  }
}
