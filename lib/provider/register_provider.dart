import 'package:flutter/material.dart';
import 'package:sims/model/response_general..dart';
import 'package:sims/services/services.dart';

class RegisterProvider extends ChangeNotifier {
  String _first_name = "";

  String _last_name = "";

  String _email = "";

  String _password = "";

  String _confirm_password = "";

  bool _isValid = false;

  bool _hidePassword = true;

  bool _hideConfirmPassword = true;

  bool _hideKeyboard = true;

  String _emailMessage = "";

  String _firstNameMessage = "";

  String _lastNameMessage = "";

  String _passwordMessage = "";

  String _confirmPasswordMessage = "";

  String? _responseMessage;

  void changeHidePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void changeHideConfirmPassword() {
    _hideConfirmPassword = !_hideConfirmPassword;
    notifyListeners();
  }

  void checkValidity(String email, String first_name, String last_name, String password, String confirm_password) {
    _email = email;
    _first_name = first_name;
    _last_name = last_name;
    _password = password;
    _confirm_password = confirm_password;
    _isValid = true;
    if (_email.trim().length == 0) {
      _isValid = false;
      _emailMessage = "Email tidak Boleh Kosong";
    }
    // else if(!RegExp(Regex.email).hasMatch(_email)) {
    //   _isValid = false;
    //   _emailMessage = "Format Email tidak sesuai";
    // }
    else {
      _emailMessage = "";
    }

    if (_first_name.trim().length == 0) {
      _isValid = false;
      _firstNameMessage = "Nama depan tidak Boleh Kosong";
    } else {
      _firstNameMessage = "";
    }
    if (_last_name.trim().length == 0) {
      _isValid = false;
      _lastNameMessage = "Nama belakang tidak Boleh Kosong";
    } else {
      _lastNameMessage = "";
    }

    if (_password.trim().length == 0) {
      _isValid = false;
      _passwordMessage = "Password tidak Boleh Kosong";
    } else {
      _passwordMessage = "";
    }

    if (_confirm_password.trim().length == 0) {
      _isValid = false;
      _confirmPasswordMessage = "Konfirmasi Password tidak Boleh Kosong";
    } else if (_password != _confirm_password) {
      _isValid = false;
      _confirmPasswordMessage = "password tidak sama";
    } else {
      _confirmPasswordMessage = "";
    }
    notifyListeners();
  }

  bool get isValid => _isValid;

  bool get hidePassword => _hidePassword;

  bool get hideConfirmPassword => _hideConfirmPassword;

  bool get hideKeyboard => _hideKeyboard;

  String get emailMessage => _emailMessage;

  String get firstNameMessage => _firstNameMessage;

  String get lastNameMessage => _lastNameMessage;

  String get passwordMessage => _passwordMessage;

  String get confirmPasswordMessage => _confirmPasswordMessage;

  String? get responseMessage => _responseMessage;
  
  ResponseGeneral? data;

  bool loading = false;

  int successType = 0;

  bool afterChangePage = false;

  Services services = Services();

  void removeResponseMessage() {
    _responseMessage = null;
    notifyListeners();
  }

  void setAfterChangePage() {
    afterChangePage = true;
    notifyListeners();
  }

  register() async {
    loading = true;
    data = await services.postRegisterRequest(_email, _first_name,_last_name,_password);
    if (data != null) {
      if (data?.status == 0) {
        successType = 1;
      }else{
        _responseMessage = data?.message;
        successType = -1;
      }
    }else{
      _responseMessage = "gagal terhubung api";
      successType = -1;
    }
    loading = false;
    notifyListeners();
  }
}
