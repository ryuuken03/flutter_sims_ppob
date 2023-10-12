import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/model/profile.dart';
import 'package:sims/model/response_balance.dart';
import 'package:sims/model/response_banner.dart';
import 'package:sims/model/response_services.dart';
import 'package:sims/services/services.dart';

class HomeProvider extends ChangeNotifier {

  String _balanceHide = "••••••";

  String _balance = "0";

  bool showBalance = false;
  
  String _token = "";

  Profile? data;

  ResponseServices? dataServices;

  ResponseBanner? dataBanners;

  ResponseBalance? dataBalance;

  bool hasCheck = false;

  bool loading = false;

  bool loadingBalance = false;

  Services services = Services();

  String get balance => showBalance ? _balance : _balanceHide;

  String get balanceHide => _balanceHide;

  String get token => _token;
  
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

  void changeShowBalance(){
    showBalance = !showBalance;
    
    notifyListeners();
  }

  getProfile() async {
    // checkToken();
    loading = true;
    // data = await services.getProfile(_token);
    // loading = false;
    // if (data != null) {
    //   if (data?.data != null) {
        
    //   }
    // }
    var sessionManager = SessionManager();
    await sessionManager.get(Constant.VAR_USER).then((user) {
      data = Profile.fromJson(user);
      loading = false;
      notifyListeners();
    });
    loading = false;
    notifyListeners();
  }

  getBalance() async {
    // checkToken();
    loadingBalance = true;
    notifyListeners();
    dataBalance = await services.getBalance(_token);
    loadingBalance = false;
    if (dataBalance?.data != null) {
      _balance = dataBalance!.data!.balance.toString();
    }
    
    notifyListeners();
  }
  
  getServices() async {
    // checkToken();
    loading = true;
    dataServices = await services.getServices(_token);
    loading = false;
    if (dataServices != null) {
      if (dataServices!.data != null) {
        
      }
    }
    notifyListeners();
  }
  getBanner() async {
    // checkToken();
    loading = true;
    dataBanners = await services.getBanners(_token);
    loading = false;
    if (dataBanners != null) {
      if (dataBanners!.data != null) {}
    }
    notifyListeners();
  }
  
}