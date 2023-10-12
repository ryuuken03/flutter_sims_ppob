class BannerData {
  String? banner_name;
  String? banner_image;
  String? description;
  
  BannerData({this.banner_name, this.banner_image, this.description});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      banner_name: json["banner_name"] as String,
      banner_image: json["banner_image"] as String,
      description: json["description"] as String,
    );
  }
}