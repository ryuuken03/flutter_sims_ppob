import 'package:sims/model/profile.dart';

class ResponseProfile {
  int status;
  String? message;
  Profile? data;
  ResponseProfile({this.status = 0, this.message, this.data});

  factory ResponseProfile.fromJson(Map<String, dynamic> json) {
    return ResponseProfile(
      status: json["status"] as int,
      message: json["message"] as String,
      data: json["data"] == null 
      ? null : 
      Profile.fromJson(json["data"]),
    );
  }
}