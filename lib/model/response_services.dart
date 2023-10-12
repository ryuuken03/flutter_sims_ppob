import 'package:sims/model/service.dart';

class ResponseServices {
  int status;
  String? message;
  List<Service>? data;
  ResponseServices({this.status = 0, this.message, this.data});

  factory ResponseServices.fromJson(Map<String, dynamic> json) {
    List<Service>? services;
    if(json["data"]!=null){
      services = [];
      json['data'].forEach((v) {
        services!.add(Service.fromJson(v));
      });
    }
    return ResponseServices(
      status: json["status"] as int,
      message: json["message"] as String,
      data: services
    );
  }
}