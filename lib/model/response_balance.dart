import 'package:sims/model/balance.dart';

class ResponseBalance {
  int status;
  String? message;
  Balance? data;
  ResponseBalance({this.status = 0, this.message, this.data});

  factory ResponseBalance.fromJson(Map<String, dynamic> json) {
    return ResponseBalance(
      status: json["status"] as int,
      message: json["message"] as String,
      data: json["data"] == null 
      ? null : 
      Balance.fromJson(json["data"]),
    );
  }
}