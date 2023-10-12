class Service {
  String? service_code;
  String? service_name;
  String? service_icon;
  int service_tariff;
  
  Service({this.service_code, this.service_name, this.service_icon, this.service_tariff = 0});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      service_code: json["service_code"] as String,
      service_name: json["service_name"] as String,
      service_icon: json["service_icon"] as String,
      service_tariff: json["service_tariff"] as int,
    );
  }
}