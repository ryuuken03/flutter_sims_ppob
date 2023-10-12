import 'package:flutter/material.dart';

class DialogAlertAsk extends StatelessWidget {
  const DialogAlertAsk({
    required this.desc,
    required this.isNext,
    required this.negativeAction,
    this.positiveAction,
    this.positiveActionText = "Ok",
    this.negativeActionText = "Batal",
    this.desc2 = "",
    super.key,
  });
  final String desc;
  final String desc2;
  final bool isNext;
  final Function()? positiveAction;
  final String positiveActionText;
  final Function() negativeAction;
  final String negativeActionText;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        width: double.infinity,
        height: 300,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Image.asset('assets/image/Logo.png'),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  )),
            ),
            Visibility(
              visible: desc2 != "",
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  desc2,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Visibility(
              visible: isNext,
              child: GestureDetector(
                onTap: positiveAction,
                // () {
                // provider.postTopUp();
                // Navigator.of(context, rootNavigator: true).pop();
                // },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(positiveActionText,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              ),
            ),
            GestureDetector(
              onTap: negativeAction,
              // () {
              //   Navigator.of(context, rootNavigator: true).pop();
              // },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(negativeActionText,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
