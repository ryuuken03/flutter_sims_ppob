import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/response_login.dart';
import 'package:sims/services/services.dart';

class LoginProvider extends ChangeNotifier {
  String _email = "";

  String _password = "";

  bool _isValid = false;

  bool _hidePassword = true;

  bool _hideKeyboard = true;

  String _emailMessage = "";

  String _passwordMessage = "";

  String? _token;

  String? _responseMessage;

  void changeHidePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  void checkValidity(String email, String password) {
    _email = email;
    _password = password;
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
    if (_password.trim().length == 0) {
      _isValid = false;
      _passwordMessage = "Password tidak Boleh Kosong";
    } else {
      _passwordMessage = "";
    }
    notifyListeners();
  }

  bool get isValid => _isValid;

  bool get hidePassword => _hidePassword;

  bool get hideKeyboard => _hideKeyboard;

  String get emailMessage => _emailMessage;

  String get passwordMessage => _passwordMessage;

  String? get token => _token;

  String? get responseMessage => _responseMessage;
  
  ResponseLogin? data;

  bool loading = false;

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

  login() async {
    loading = true;
    data = await services.postLoginRequest(_email, _password);
    if (data != null) {
      // _responseMessage = data?.message;
      if (data?.data != null) {
        var sessionManager = SessionManager();
        await sessionManager.set(Constant.VAR_TOKEN, data?.data?.token);
        await sessionManager.set(Constant.VAR_EMAIL, _email);
        await sessionManager.set(Constant.VAR_PASSWORD, _password);
        await SessionManager().update();
        // loading = false;
        getProfile(data!.data!.token!);
      }else{
        _responseMessage = data?.message;
        loading = false;
      }
    }else{
      _responseMessage = "gagal terhubung api";
      loading = false;
    }
    notifyListeners();
  }

  getProfile(String token) async {
    var data = await services.getProfile(token);
    loading = false;
    if (data.data != null) {
      var sessionManager = SessionManager();
      await sessionManager.set(Constant.VAR_USER, data.data!).then((value) {
        notifyListeners();
      });
      await SessionManager().update();
    } else {
      notifyListeners();
    }
  }
}
