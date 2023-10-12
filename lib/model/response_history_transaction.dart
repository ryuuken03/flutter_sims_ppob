import 'package:sims/model/history_transaction_data.dart';

class ResponseHistoryTransaction {
  int status;
  String? message;
  HistoryTransactionData? data;
  ResponseHistoryTransaction({this.status = 0, this.message, this.data});

  factory ResponseHistoryTransaction.fromJson(Map<String, dynamic> json) {
    return ResponseHistoryTransaction(
      status: json["status"] as int,
      message: json["message"] as String,
      data: json["data"] == null 
      ? null : 
      HistoryTransactionData.fromJson(json["data"]),
    );
  }
}