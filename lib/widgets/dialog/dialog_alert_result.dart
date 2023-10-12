import 'package:flutter/material.dart';

class DialogAlertResult extends StatelessWidget {
  const DialogAlertResult({
    required this.desc,
    this.desc2 = "",
    this.message = "",
    this.action,
    this.actionText = "Ok",
    this.isSuccess = false,
    super.key,
  });

  final String desc;
  final String desc2;
  final String message;
  final bool isSuccess;
  final Function()? action;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          width: double.infinity,
          height: 290,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                child: Icon(
                  isSuccess ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(desc,
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
                visible: message != "",
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      )),
                ),
              ),
              GestureDetector(
                onTap: action,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text(actionText,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
