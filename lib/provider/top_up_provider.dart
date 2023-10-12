import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/response_balance.dart';
import 'package:sims/services/services.dart';

class TopUpProvider extends ChangeNotifier {

  String _token = "";

  String _balance = "0";

  String topUp = "0";

  bool canClickTopUp = false;

  bool loading = false;

  bool hasCheck = false;

  int successType = 0;

  Services services = Services();

  ResponseBalance? data;

  ResponseBalance? dataBalance;

  String get balance => _balance;

  String get token => _token;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  void setErrorMessage(String message){
    _errorMessage = message;
    successType = -1;
    notifyListeners();
  }

  void setTopUp(String _topUp){
    topUp = _topUp;
    if(topUp != ""){
      if(topUp != "0"){
        canClickTopUp = true;
      } else {
        canClickTopUp = false;
      }
    } else {
      canClickTopUp = false;
    }
    notifyListeners();
  }
  
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

  getBalance() async {
    // checkToken();
    loading = true;
    notifyListeners();
    dataBalance = await services.getBalance(_token);
    loading = false;
    if (dataBalance?.data != null) {
      _balance = dataBalance!.data!.balance.toString();
    }

    notifyListeners();
  }

  void resetDataTopUp(){
    data = null;
    _errorMessage = "";
    successType = 0;
  }

  postTopUp() async {
    loading = true;
    data = await services.postTopUp(_token,int.parse(topUp));
    if (data != null) {
      if (data!.data != null) {
        _balance = data!.data!.balance.toString();
        successType = 1;
      }else{
        _errorMessage = data!.message!;
        successType = -1;
      }
    }else{
      _errorMessage = "gagal";
      successType = -1;
    }
    loading = false;
    notifyListeners();
  }
}