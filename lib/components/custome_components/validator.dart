import 'package:email_validator/email_validator.dart';

mixin Validator {
  static bool isEmail(String email) => EmailValidator.validate(email);

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!isEmail(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    } else if (value.length < 4) {
      return 'Name must be at least 4 characters';
    }
    return null;
  }

  String? mobileValidator(String? value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }
}
