import 'package:flutter/material.dart';
import 'package:sims/constant/currency_format.dart';

class BalanceLayout extends StatelessWidget {
  const BalanceLayout({
    required this.balance,
    super.key,
  });

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
            height: 150,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  constraints: BoxConstraints.tightFor(),
                  child: Image.asset(
                    "assets/image/Background_Saldo.png",
                    fit: BoxFit.fill,
                    // width: double.infinity,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Saldo Anda",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            CurrencyFormat.convertToIdr(int.parse(balance), 0),
                            // provider.balance,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 35,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
  }
}
