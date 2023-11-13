import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mage/models/record.dart';
import 'package:path_provider/path_provider.dart';

class RecordsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/records.txt');
  }

  Future readRecords() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      List<dynamic> ordinaryList = jsonDecode(contents);

      List<RecordItem> recordList = ordinaryList.map((map) {
        return RecordItem(
          id: map['id'],
          lora: map['lora'],
          result: map['result'],
          status: map['status'],
          timestamp: map['timestamp'],
        );
      }).toList();

      return recordList;
    } catch (e) {
      List<RecordItem> recordList = [];
      return recordList;
    }
  }

  Future<File> writeRecords(List<RecordItem> records) async {
    final file = await _localFile;

    List<Map<String, dynamic>> ordinaryList = records.map((recordItem) {
      return {
        'id': recordItem.id,
        'lora': recordItem.lora,
        'result': recordItem.result,
        'status': recordItem.status,
        'timestamp': recordItem.timestamp,
      };
    }).toList();

    String contents = jsonEncode(ordinaryList);

    // Write the file
    return file.writeAsString(contents);
  }
}
