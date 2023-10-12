import 'package:sims/model/history_transaction.dart';

class HistoryTransactionData{
  // int offset;
  // dynamic limit;
  List<HistoryTransaction>? records;
  
  HistoryTransactionData({this.records});

  factory HistoryTransactionData.fromJson(Map<String, dynamic> json) {
    List<HistoryTransaction>? histories;
    if (json["records"] != null) {
      histories = [];
      json['records'].forEach((v) {
        histories!.add(HistoryTransaction.fromJson(v));
      });
    }
    return HistoryTransactionData(
      // offset: json["offset"] as int,
      // limit: json["limit"] as dynamic,
      records: histories
    );
  }
}