import 'package:sims/model/banner_data.dart';

class ResponseBanner {
  int status;
  String? message;
  List<BannerData>? data;
  ResponseBanner({this.status = 0, this.message, this.data});

  factory ResponseBanner.fromJson(Map<String, dynamic> json) {
    List<BannerData>? banners;
    if (json["data"] != null) {
      banners = [];
      json['data'].forEach((v) {
        banners!.add(BannerData.fromJson(v));
      });
    }
    return ResponseBanner(
        status: json["status"] as int,
        message: json["message"] as String,
        data: banners);
  }
}