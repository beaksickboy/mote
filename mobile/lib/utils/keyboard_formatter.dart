import 'package:flutter/services.dart';

/// Blacklist key will be replace with ""
/// Use with inputFormatter props in TextField
class KeyboardFormatter {
  static BlacklistingTextInputFormatter positiveInteger() {
    return BlacklistingTextInputFormatter(RegExp('[.,-]'));
  }

  static BlacklistingTextInputFormatter positiveNumber() {
    return BlacklistingTextInputFormatter(RegExp('[,-]'));
  }

  static BlacklistingTextInputFormatter blackList(
      String blackListCharacters) {
    return BlacklistingTextInputFormatter(RegExp('[$blackListCharacters]'));
  }

  static TextInputFormatter uppercase() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text?.toUpperCase());
    });
  }

  static TextInputFormatter lowercase() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return newValue.copyWith(text: newValue.text?.toLowerCase());
    });
  }

  static TextInputFormatter allowOneDecimal() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final allMatch = '.'.allMatches(newValue.text);
      return allMatch.length <= 1 ? newValue : oldValue;
    });
  }


}
