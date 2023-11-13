import 'package:flutter/material.dart';

class RecordItem {
  String id;
  String lora;
  String result;
  String status;
  int timestamp;

  RecordItem({
    required this.id,
    required this.lora,
    required this.result,
    required this.status,
    required this.timestamp,
  });
}

class RecordModel extends ChangeNotifier {
  late List<RecordItem> _recordList;

  RecordModel() {}

  List<RecordItem> get recordList => _recordList;

  void updateRecordList(List<RecordItem> value) {
    _recordList = value;
    notifyListeners();
  }
}

// final List<RecordItem> recordList = [
//   RecordItem(
//     id: '1',
//     lora: "Event 1",
//     result: "https://mage.zonghuang.cn/prod/user/1571706335766.jpg",
//     status: 'fulfilled',
//     timestamp: '2023-11-10',
//   ),
//   RecordItem(
//     id: '2',
//     lora: "Event 2",
//     result: "Description for event 2",
//     status: 'pending',
//     timestamp: '2023-11-10',
//   ),
//   RecordItem(
//     id: '3',
//     lora: "Event 3",
//     result: "Description for event 3",
//     status: 'rejected',
//     timestamp: '2023-11-10',
//   ),
// ];
