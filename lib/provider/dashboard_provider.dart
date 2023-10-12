import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/services/services.dart';

class DashboardProvider extends ChangeNotifier{
  String _token = "";

  bool loading = false;

  bool isChange = false;

  bool hasCheck = false;

  int currentPage = 0;

  Services services = Services();

  String get token => _token;

  void checkToken() async {
    hasCheck = true;
    if (_token == "") {
      var sessionManager = SessionManager();
      sessionManager.get(Constant.VAR_TOKEN).then((data) {
        _token = data;
        notifyListeners();
      });
    }
  }
  void changeCurrentPage(int _currentPage){
    currentPage = _currentPage;
    isChange = true;
    notifyListeners();
  }

  void afterChange(){
    isChange = false;
    notifyListeners();
  }
}