class TransactionData {
  String? invoice_number;
  String? service_code;
  String? service_name;
  String? transaction_type;
  int total_amount;
  String? created_on;
  
  TransactionData({
    this.invoice_number, 
    this.service_code, 
    this.service_name, 
    this.transaction_type, 
    this.created_on, 
    this.total_amount = 0
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      invoice_number: json["invoice_number"] as String,
      service_code: json["service_code"] as String,
      service_name: json["service_name"] as String,
      transaction_type: json["transaction_type"] as String,
      created_on: json["created_on"] as String,
      total_amount: json["total_amount"] as int,
    );
  }
}