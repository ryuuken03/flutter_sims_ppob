import 'package:sims/model/token.dart';

class ResponseLogin {
  int status;
  String? message;
  Token? data;
  ResponseLogin({this.status = 0, this.message, this.data});

  factory ResponseLogin.fromJson(Map<String, dynamic> json) {
    return ResponseLogin(
      status: json["status"] as int,
      message: json["message"] as String,
      data: json["data"] == null 
      ? null : 
      Token.fromJson(json["data"]),
    );
  }
}