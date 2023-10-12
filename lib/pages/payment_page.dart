import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:sims/constant/currency_format.dart';
import 'package:sims/model/service.dart';
import 'package:sims/provider/history_transaction_provider.dart';
import 'package:sims/provider/home_provider.dart';
import 'package:sims/provider/payment_provider.dart';
import 'package:sims/provider/top_up_provider.dart';
import 'package:sims/widgets/balance_layout.dart';
import 'package:sims/widgets/dialog/dialog_alert_ask.dart';
import 'package:sims/widgets/dialog/dialog_alert_result.dart';
import 'package:sims/widgets/elevated_button/elevated_button_red.dart';
import 'package:sims/widgets/progress_loading.dart';
import 'package:sims/widgets/toolbar/toolbar_default.dart';
import 'package:sims/widgets/text_field/top_up_text_field.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({required this.data, super.key});

  static const String routeName = "/payment";

  final Service data;

  @override
  Widget build(BuildContext context) {
    TextEditingController textFieldController = TextEditingController();
    return Consumer<PaymentProvider>(builder: (context, provider, child) {
      textFieldController.text =
          CurrencyFormat.convertToIdr2(data.service_tariff, 0);
      if (!provider.hasCheck) {
        if (provider.token == "") {
          provider.checkToken();
        }
      } else {
        if (provider.token != "") {
          if (provider.dataBalance == null) {
            provider.getBalance();
          } else if (provider.successType != 0) {
            var isSuccess = provider.successType == 1;
            var message = "gagal";
            if (isSuccess) {
              message = "berhasil";
            } else {}
            var amount = CurrencyFormat.convertToIdr(data.service_tariff, 0);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              var desc = "pembayaran " + data.service_name! + " sebesar ";
              showDialogAlertResult(
                  context, provider, isSuccess, desc, amount, message);
            });
          }
        }
      }
      return Scaffold(
          appBar: ToolbarDefault(title: "Pembayaran"),
          body: provider.loading
              ? ProgressLoading()
              : Container(
                  padding: EdgeInsets.all(15),
                  child: ListView(scrollDirection: Axis.vertical, children: [
                    BalanceLayout(
                      balance: provider.balance,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Text(
                        "Pembayaran",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: data.service_icon!,
                          fit: BoxFit.cover,
                          width: 30,
                          height: 30,
                          filterQuality: FilterQuality.medium,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            data.service_name!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    TopUpTextField(
                        topUpController: textFieldController, enable: false),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(0, 250, 0, 20),
                      child: ElevatedButtonRed(
                        activeText: "Bayar",
                        onPressed: provider.balance != "0"
                              ? () {
                                  try {
                                    var balance = int.parse(provider.balance);
                                    if(balance < data.service_tariff){
                                      var desc =
                                          "Saldo anda tidak mencukupi untuk pembayaran !";
                                      var amount = CurrencyFormat.convertToIdr(
                                          data.service_tariff, 0);
                                      showDialogAlertAsk(context, provider,
                                          data, desc, amount);
                                    }else{
                                      var desc = "Anda yakin untuk Pembayaran sebesar";
                                      var amount = CurrencyFormat.convertToIdr(data.service_tariff,0);
                                      showDialogAlertAsk(context, provider, data, desc, amount, isNext: true);
                                    }
                                  } catch (e) {
                                  }
                                }
                              :
                          null,
                        isActive: provider.balance != "0",
                      ),
                    ),
                  ]),
                ));
    });
  }

  showDialogAlertAsk(BuildContext context, PaymentProvider provider,
      Service data, String desc, String amount,
      {bool isNext = false}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogAlertAsk(
            desc: desc,
            isNext: isNext,
            negativeAction: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            positiveAction: () {
              provider.payment(data.service_code!);
              Navigator.of(context, rootNavigator: true).pop();
            },
            positiveActionText: "Ya, lanjutkan Pembayaran",
            desc2: amount + " ?",
          );
        });
  }

  showDialogAlertResult(BuildContext context, PaymentProvider provider,
      bool isSuccess, String desc, String amount, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogAlertResult(
            desc: "Top up sebesar",
            desc2: amount,
            message: message,
            isSuccess: isSuccess,
            action: () async {
              var prov = Provider.of<HomeProvider>(context, listen: false);
              prov.getBalance();
              var prov2 = Provider.of<TopUpProvider>(context, listen: false);
              prov2.getBalance();
              var prov3 = Provider.of<HistoryTransactionProvider>(context,
                  listen: false);
              prov3.getBalance();
              prov3.getHistory();
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.of(context, rootNavigator: true).maybePop();
            },
            actionText: "Kembali ke Beranda",
          );
        });
  }
}
