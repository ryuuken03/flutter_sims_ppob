import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/response_balance.dart';
import 'package:sims/model/response_transaction.dart';
import 'package:sims/services/services.dart';

class PaymentProvider extends ChangeNotifier{
  
  String _token = "";

  String _balance = "0";

  int successType = 0;

  bool loading = false;

  bool hasCheck = false;

  Services services = Services();

  ResponseTransaction? data;

  ResponseBalance? dataBalance;

  String get balance => _balance;

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

  getBalance() async {
    loading = true;
    notifyListeners();
    dataBalance = await services.getBalance(_token);
    loading = false;
    if (dataBalance?.data != null) {
      _balance = dataBalance!.data!.balance.toString();
    }

    notifyListeners();
  }

  payment(String service_code) async {
    loading = true;
    notifyListeners();
    data = await services.postPayment(_token,service_code);
    loading = false;
    if (data != null) {
      if (data!.data != null) {
        successType = 1;
      } else {
        successType = -1;
      }
    } else {
      successType = -1;
    }
    notifyListeners();
  }
}