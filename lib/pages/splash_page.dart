import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims/pages/dashboard_page.dart';
import 'package:sims/pages/login_page.dart';
import 'package:sims/provider/splash_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  
  static const String routeName = "/splash";


  void pushToLogin(BuildContext context) {
    print("Push to login 0");
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  void pushToMain(BuildContext context){
    print("Push to Main");
    Navigator.pushReplacementNamed(context, DashboardPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashProvider>(
        builder: (context, provider, child){
        if (!provider.afterChangePage) {
          if (!provider.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.setAfterChangePage();
              if(provider.toLogin){
                pushToLogin(context);
              }else{
                pushToMain(context);
              }
            });
          }else{
            if(!provider.hasCheck){
              provider.checkToken();
            }
          }
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/Logo.png',
                width: 200,
                height: 200,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'SIMS PPOB',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Mohammad Toriq',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
