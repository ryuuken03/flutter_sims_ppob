import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/profile.dart';
import 'package:sims/services/services.dart';

class ProfileProvider extends ChangeNotifier {

  bool isLogout = false;

  int successType = 0;
  
  String _token = "";

  String _first_name = "";

  String _last_name = "";

  String? _responseMessage;

  String _firstNameMessage = "";

  String _lastNameMessage = "";

  Profile? data;

  bool _isValid = false;

  bool loading = false;

  bool hasCheck = false;

  bool _isEdit = false;

  Services services = Services();

  String get token => _token;

  String? get responseMessage => _responseMessage;

  String get firstNameMessage => _firstNameMessage;

  String get lastNameMessage => _lastNameMessage;

  bool get isValid => _isValid;

  bool get isEdit => _isEdit;
  
  void checkToken() async {
    hasCheck = true;
    if(_token == ""){
      var sessionManager = SessionManager();
      sessionManager.get(Constant.VAR_TOKEN).then((data) {
        _token = data;
        notifyListeners();
      });
    }
  }

  void changeEdit(){
    _isEdit = !_isEdit;
    notifyListeners();
  }

  void removeResponseMessage(){
    _responseMessage = null;
    notifyListeners();
  }

  void checkValidity(String first_name, String last_name) {
    _first_name = first_name;
    _last_name = last_name;
    _isValid = true;

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
    notifyListeners();
  }

  getProfile() async {
    loading = true;
    var sessionManager = SessionManager();
    await sessionManager.get(Constant.VAR_USER).then((user) {
      data = Profile.fromJson(user);
      notifyListeners();
    });
    loading = false;
    notifyListeners();
  }
  void resetStatusType(){
    successType = 0;
    notifyListeners();
  }

  updateProfile() async {
    loading = true;
    var resData = await services.putProfileUpdate(_token,
      _first_name, _last_name);
    if (resData.data != null) {
      if (resData.status == 0) {
        successType = 1;
        data = resData.data;
        var sessionManager = SessionManager();
        await sessionManager.set(Constant.VAR_USER, data);
        await SessionManager().update();
        changeEdit();
      } else {
        _responseMessage = resData.message;
        successType = -1;
      }
    } else {
      _responseMessage = "gagal terhubung api";
      successType = -1;
    }
    loading = false;
    notifyListeners();
  }

  imageProfile(File imageFile) async {
    loading = true;
    await services.putProfileImage(_token, imageFile).then((resData){
      if (resData.data != null) {
        if (resData.status == 0) {
          print("successType = 1");
          successType = 1;
          data = resData.data;
          loading = false;
          var sessionManager = SessionManager();
          sessionManager.set(Constant.VAR_USER, data);
          SessionManager().update();
          notifyListeners();
        } else {
          _responseMessage = resData.message;
          successType = -1;
          loading = false;
          notifyListeners();
        }
      } else {
        _responseMessage = "gagal terhubung api";
        successType = -1;
        loading = false;
        notifyListeners();
      }
    });
    
  }

  logout() async {
    loading = true;
    notifyListeners();
    await SessionManager().destroy().then((value){
      loading = false;
      isLogout = true;
      notifyListeners();
    });
  }

  login() {
    isLogout = false;
    notifyListeners();
  }
  
}