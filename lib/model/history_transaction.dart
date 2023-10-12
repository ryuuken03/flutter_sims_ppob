class HistoryTransaction {
  String? invoice_number;
  String? transaction_type;
  String? description;
  int total_amount;
  String? created_on;
  
  HistoryTransaction({this.invoice_number, this.transaction_type, this.description, this.total_amount = 0, this.created_on});

  factory HistoryTransaction.fromJson(Map<String, dynamic> json) {
    return HistoryTransaction(
      invoice_number: json["invoice_number"] as String,
      transaction_type: json["transaction_type"] as String,
      description: json["description"] as String,
      total_amount: json["total_amount"] as int,
      created_on: json["created_on"] as String,
    );
  }
}