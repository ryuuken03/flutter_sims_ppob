class Profile {
  String? email;
  String? first_name;
  String? last_name;
  String? profile_image;

  Profile({this.email, this.first_name, this.last_name, this.profile_image});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      email: json["email"] as String,
      first_name: json["first_name"] as String,
      last_name: json["last_name"] as String,
      profile_image: json["profile_image"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> profile = Map<String, dynamic>();
    profile["email"] = this.email;
    profile["first_name"] = this.first_name;
    profile["last_name"] = this.last_name;
    profile["profile_image"] = this.profile_image;
    return profile;
  }
}
