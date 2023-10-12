
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/response_balance.dart';
import 'package:sims/model/response_history_transaction.dart';
import 'package:sims/services/services.dart';

class HistoryTransactionProvider extends ChangeNotifier {

  String _token = "";

  String _balance = "0";

  int _offset = 0;

  int _limit = 5;

  bool loading = false;

  bool hasCheck = false;

  Services services = Services();

  ResponseHistoryTransaction? data;

  ResponseBalance? dataBalance;

  String get balance => _balance;

  String get token => _token;

  int get offset => _offset;
  
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

  showMore(){
    _offset += _limit;
    print("showMore : "+ _offset.toString());
    notifyListeners();
    getHistory();
  }

  resetData() {
    print("resetData");
    _offset = 0;
    notifyListeners();
    getHistory();
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

  getHistory() async {
    loading = true;
    notifyListeners();
    print("getHistory : "+ _offset.toString());
    data = await services.getHistoryTransactions(_token, offset: _offset, limit: _limit);
    loading = false;
    if (data != null) {
      if (data!.data != null) {

      }
    }
    notifyListeners();
  }

}