import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/services/services.dart';

class SplashProvider extends ChangeNotifier{

  int _counter = 1;

  bool loading = true;

  bool hasCheck = false;

  bool toLogin = false;

  bool afterChangePage = false;

  String _token = "";

  String get token => _token;

  Services services = Services();

  void setAfterChangePage(){
    afterChangePage = true;
    notifyListeners();
  }

  void setCounter(){
    print("setCounter : {$_counter}");
    if (_counter < 5) {
      print("addCounter : {$_counter}");
      addCounter();
    }else if(_counter == 5){
      print("stop count : {$_counter}");
    }
  }

  void addCounter(){
    Future.delayed(const Duration(milliseconds: 500), () {
      _counter++;
      print("count : {$_counter}");
      if (_counter < 5) {
        addCounter();
        // notifyListeners();
      }else if (_counter == 5) {
        notifyListeners();
      }
    });
  }

  int get counter => _counter;

  void checkToken() async{
    hasCheck = true;
    var sessionManager = SessionManager();
    await sessionManager.containsKey(Constant.VAR_EMAIL).then((value){
      if(value){
        sessionManager.containsKey(Constant.VAR_TOKEN).then((val){
          if(val){
            sessionManager.get(Constant.VAR_TOKEN).then((data){
              _token = data;
              // print(_token);
              notifyListeners();
              getProfile(_token);
            });
          }else{
            sessionManager.get(Constant.VAR_EMAIL).then((email){
              sessionManager.get(Constant.VAR_PASSWORD).then((password){
                login(email, password);
              });
            });
          }
        });
      }else{
        toLogin = true;
        loading = false;
        notifyListeners();
      }
    });
  }

  login(String _email, String _password) async {
    var data = await services.postLoginRequest(_email, _password);
    // loading = false;
    if (data.data != null) {
      _token = data.data!.token!;
      var sessionManager = SessionManager();
      await sessionManager.set(Constant.VAR_TOKEN, _token);
      await sessionManager.set(Constant.VAR_EMAIL, _email);
      await sessionManager.set(Constant.VAR_PASSWORD, _password);
      await SessionManager().update().then((value) => {
        getProfile(token)
      });
    }else{
      toLogin = true;
      loading = false;
      notifyListeners();
    }
  }

  getProfile(String token) async {
    var data = await services.getProfile(token);
    loading = false;
    if (data.data != null) {
      var sessionManager = SessionManager();
      sessionManager.set(Constant.VAR_USER, data.data!).then((value){
        notifyListeners();
      });
      SessionManager().update();
    } else {
      toLogin = true;
      notifyListeners();
    }
  }
}