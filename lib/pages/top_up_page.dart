import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sims/constant/currency_format.dart';
import 'package:sims/provider/dashboard_provider.dart';
import 'package:sims/provider/history_transaction_provider.dart';
import 'package:sims/provider/home_provider.dart';
import 'package:sims/provider/top_up_provider.dart';
import 'package:sims/widgets/balance_layout.dart';
import 'package:sims/widgets/dialog/dialog_alert_ask.dart';
import 'package:sims/widgets/dialog/dialog_alert_result.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red.dart';
import 'package:sims/widgets/progress_loading.dart';
import 'package:sims/widgets/text_field/top_up_text_field.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({
    super.key});

  static const String routeName = "/top_up";

  @override
  Widget build(BuildContext context) {
    var topUpController = TextEditingController();
    var listTopUp = [10000,20000,50000,100000,250000,500000];
    
    return Consumer<TopUpProvider>(builder: (context, provider, child) {
      if (!provider.hasCheck) {
        if (provider.token == "") {
          provider.checkToken();
        }
      } else {
        if (provider.token != "") {
          if (provider.dataBalance == null) {
            provider.getBalance();
          } else if (provider.successType != 0) {
            topUpController.text = "";
            var isSuccess = provider.successType == 1;
            var message = "gagal";
            if (isSuccess) {
              message = "berhasil";
            } else {}
            var amount =
                CurrencyFormat.convertToIdr(int.parse(provider.topUp), 0);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialogAlertResult(
                  context, provider, isSuccess, amount, message);
            });
          }
        }
      }
      return Scaffold(
          body: provider.loading
              ? ProgressLoading()
              : Container(
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      BalanceLayout(
                        balance: provider.balance,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "Silahkan masukan",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "nominal Top Up",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                      ),
                      TopUpTextField(
                          topUpController: topUpController, provider: provider),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: (listTopUp.length / 2).toInt(),
                            childAspectRatio: 2,
                          ),
                          itemCount: listTopUp.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if (WidgetsBinding
                                        .instance.window.viewInsets.bottom >
                                    0.0) {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                }
                                provider.setTopUp(listTopUp[index].toString());
                                var newValue = CurrencyFormat.convertToIdr2(
                                    listTopUp[index], 0);
                                  // topUpController.text = newValue;
                                topUpController.value = TextEditingValue(
                                  text: newValue,
                                  selection: TextSelection.collapsed(
                                      offset: newValue.length),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                ),
                                child: Center(
                                    child: Text(
                                        CurrencyFormat.convertToIdr(
                                            listTopUp[index], 0),
                                        textAlign: TextAlign.center)),
                              ),
                            );
                          }),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: ElevatedButtonRed(
                          activeText: "Top Up",
                          onPressed: provider.canClickTopUp
                              ? () {
                                  if (WidgetsBinding
                                          .instance.window.viewInsets.bottom >
                                      0.0) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  }
                                  try {
                                    var parseInt = int.parse(provider.topUp);
                                    if (parseInt < 10000) {
                                      // provider.setErrorMessage(
                                      //           "Minimum nominal Top Up Rp 10.000");
                                      var desc =
                                          "Minimum nominal Top Up Rp 10.000";
                                      var amount =
                                          CurrencyFormat.convertToIdr(
                                              parseInt, 0);
                                      showDialogAlertAsk(
                                          context, provider, desc, amount);
                                    } else {
                                      if (parseInt > 1000000) {
                                        // provider.setErrorMessage("Maksimum nominal Top Up Rp 1.000.000");
                                        var desc =
                                            "Maksimum nominal Top Up Rp 1.000.000";
                                        var amount =
                                            CurrencyFormat.convertToIdr(
                                                parseInt, 0);
                                        showDialogAlertAsk(
                                            context, provider, desc, amount);
                                      } else {
                                        // provider.postTopUp();
                                        var desc =
                                            "Anda yakin untuk Top Up sebesar";
                                        var amount =
                                            CurrencyFormat.convertToIdr(
                                                parseInt, 0);
                                        showDialogAlertAsk(
                                            context, provider, desc, amount,
                                            isNext: true);
                                      }
                                    }
                                  } catch (e) {}
                                }
                              : null,
                          isActive: provider.canClickTopUp,
                        ),
                      ),
                    ],
                  ),
                ));
    });
  }

  showDialogAlertAsk(BuildContext context, TopUpProvider provider, String desc, String amount, {bool isNext = false}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return DialogAlertAsk(
          desc: desc,
          isNext : isNext,
          negativeAction: (){
            Navigator.of(context, rootNavigator: true).pop();
          },
          positiveAction: () {
            provider.postTopUp();
            Navigator.of(context, rootNavigator: true).pop();
          },
          positiveActionText: "Ya, lanjutkan Top Up",
          desc2: amount + " ?",
        );
      }
    );
  }

  showDialogAlertResult(BuildContext context,TopUpProvider provider, bool isSuccess, String amount, String message){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) {
          return DialogAlertResult(
            desc: "Top up sebesar",
            desc2: amount,
            message: message,
            isSuccess: isSuccess,
            action: (){
              provider.resetDataTopUp();
              Navigator.of(context, rootNavigator: true).pop();

              var prov = Provider.of<DashboardProvider>(context, listen: false);
              prov.changeCurrentPage(0);

              var prov2 = Provider.of<HomeProvider>(context, listen: false);
              prov2.getBalance();
              var prov3 = Provider.of<HistoryTransactionProvider>(context,
                  listen: false);
              prov3.getBalance();
              prov3.getHistory();
            },
            actionText: "Kembali ke Beranda",
          );
      });
  }
}
