// ignore: avoid_classes_with_only_static_members
/// Validators and helper functions for authentication
class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  // Letters and numbers min 6 characters
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  /// Check if given [email] is valid
  static bool isValidEmail(String email) => _emailRegExp.hasMatch(email);

  /// Check if given [password] is valid
  static bool isValidPassword(String password) =>
      _passwordRegExp.hasMatch(password);

  /// Replace every character in a given [password] with "X"
  static String obscurePassword(String password) =>
      password.replaceAll(RegExp('.'), 'X');
}
