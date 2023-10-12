class ResponseGeneral {
  int status;
  String? message;
  // String? data;
  ResponseGeneral({this.status = -1, this.message});

  factory ResponseGeneral.fromJson(Map<String, dynamic> json) {
    return ResponseGeneral(
        status: json["status"] as int,
        message: json["message"] as String
        // data: json["data"] as String
        );
  }
}
