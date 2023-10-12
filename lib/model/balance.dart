class Balance {
  int balance;
  
  Balance({this.balance = 0});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      balance: json["balance"] as int,
    );
  }
}