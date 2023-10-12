import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sims/constant/constant.dart';
import 'package:sims/constant/currency_format.dart';
import 'package:sims/constant/mydate_format.dart';
import 'package:sims/model/history_transaction.dart';
import 'package:sims/provider/history_transaction_provider.dart';
import 'package:sims/widgets/balance_layout.dart';
import 'package:sims/widgets/progress_loading.dart';

class HistoryTransactionPage extends StatelessWidget {
  const HistoryTransactionPage({super.key});

  static const String routeName = "/history_transaction";

  @override
  Widget build(BuildContext context) {
    var widthMax = MediaQuery.of(context).size.width - 80;
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

    Future refresh() async {
      var provider = Provider.of<HistoryTransactionProvider>(context, listen: false);
      provider.getBalance();
      provider.getHistory();
    }

    return Consumer<HistoryTransactionProvider>(
      builder: (context, provider, child) {
        List<HistoryTransaction> list = [];
        if(!provider.hasCheck){
          if(provider.token == ""){
            provider.checkToken();
          }
        }else{
          if(provider.token != ""){
            if (provider.dataBalance == null) {
              provider.getBalance();
            } else if (provider.data == null) {
              provider.getHistory();
            }
            if (provider.data != null) {
              if (provider.data?.data != null) {
                provider.data?.data?.records?.forEach((element) {
                  list.add(element);
                });
              }
            }
          }
        }
        return Scaffold(
          // appBar: ToolbarDefault(title: "Transaksi"),
          body:provider.loading
          ? ProgressLoading()
          : RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: refresh,
            child: Container(
              padding: EdgeInsets.all(15),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  BalanceLayout(
                    balance: provider.balance,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Text(
                      "Transaksi",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child:Column(
                      children: [
                        list.length > 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var data = list[index];
                              var type = 0;
                              if(data.transaction_type == "PAYMENT"){
                                type = 1;
                              }else if (data.transaction_type == "TOPUP") {
                                type = 2;
                              }
                              return Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border:Border.all(
                                    color: Colors.grey, 
                                    width: 0.5
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: widthMax/2,
                                          child: Text(
                                            (type == 1
                                            ? "- "
                                            : type == 2
                                              ? "+ "
                                              : " " )+ 
                                            CurrencyFormat.convertToIdr(data.total_amount, 0),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: type == 1 ? Colors.red : type == 2 ? Colors.green : Colors.black),
                                          ),
                                        ),
                                        Container(
                                          width: widthMax / 2,
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            MyDateFormat.chanegFormat(
                                                      data.created_on!, 
                                                      Constant.DATE_OUT_FORMAT_DEF1, 
                                                      Constant.DATE_OUT_FORMAT_DEF2) +" WIB",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[400]
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      width: widthMax / 2,
                                      height: widthMax / 6,
                                      child: Text(
                                        data.description!,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 12,
                                            // fontWeight: FontWeight.bold
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          )
                        : Container(
                            width: double.infinity,
                            height: 300,
                            child: Center(
                              child: Text(
                                  "Maaf tidak ada transaksi saat ini",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[400]
                                  ),
                                ),
                            ),
                          )
                        ,
                        (list.length == 0 && provider.offset > 0) || list.length > 0
                        ? GestureDetector(
                          onTap: (){
                            if(list.length < 5){
                              provider.resetData();
                            }else{
                              provider.showMore();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0,10,0,10),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              list.length < 5
                              ? "Reset"
                              : "Show more",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                        :SizedBox(),
                      ],
                    )
                  )
                ]
              )
            ),
          )
        );
      });
  }
}