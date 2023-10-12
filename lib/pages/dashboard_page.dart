import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims/pages/history_transaction_page.dart';
import 'package:sims/pages/home_page.dart';
import 'package:sims/pages/profile_page.dart';
import 'package:sims/pages/top_up_page.dart';
import 'package:sims/provider/dashboard_provider.dart';
import 'package:sims/widgets/toolbar/toolbar_default.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const String routeName = "/dashboard";

  Widget build(BuildContext context) {
    
    var currentIndex = 0;

    Map<int, GlobalKey> navigatorKeys = {
      0: GlobalKey(),
      1: GlobalKey(),
      2: GlobalKey(),
      3: GlobalKey(),
    };

    var menus = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.money),
        label: 'Top Up',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.credit_card),
        label: 'Transaction',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Akun',
      ),
    ];

    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if(provider.isChange){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("page:"+provider.currentPage.toString());
            currentIndex = provider.currentPage;
            provider.afterChange();
          });
        }
        return Scaffold(
        appBar: currentIndex == 0
            ? null
            : ToolbarDefault(title: menus[currentIndex].label!,provider: provider,),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(currentIndex != index){
                    currentIndex = index;
                    provider.changeCurrentPage(index);
                  }
              });
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            enableFeedback: false,
            items: menus),
        body: SafeArea(
            child: WillPopScope(
          onWillPop: () async {
            // return !await navigatorKeys[_pageIndex].currentState.context;
            return !await Navigator.maybePop(
                navigatorKeys[currentIndex]!.currentState!.context);
            // Navigator.pop(navigatorKeys[_pageIndex].currentState.context);
          },
          child: IndexedStack(
            index: currentIndex,
            children: <Widget>[
              HomePage(),
              TopUpPage(),
              HistoryTransactionPage(),
              ProfilePage(),
            ],
          ),
        )),
      );
    });
  }
}