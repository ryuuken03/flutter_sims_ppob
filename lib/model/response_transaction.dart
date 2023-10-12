import 'package:sims/model/transaction_data.dart';

class ResponseTransaction {
  int status;
  String? message;
  TransactionData? data;
  ResponseTransaction({this.status = 0, this.message, this.data});

  factory ResponseTransaction.fromJson(Map<String, dynamic> json) {
    return ResponseTransaction(
      status: json["status"] as int,
      message: json["message"] as String,
      data: json["data"] == null 
      ? null : 
      TransactionData.fromJson(json["data"]),
    );
  }
}