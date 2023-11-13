import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mage/data/persistence/records_storage.dart';
import 'package:mage/helper/auth/get_user.dart';
import 'package:mage/models/record.dart';

// 上传本地数据到云端
Future uploadLocalToCloud() async {
  var storage = RecordsStorage();
  var db = FirebaseFirestore.instance;
  User? user = await getUser();
  List<RecordItem> recordList = await storage.readRecords();

  // 遍历上传
  for (RecordItem item in recordList) {
    final record = <String, dynamic>{
      'id': item.id,
      'lora': item.lora,
      // 'mode': item.mode,
      // 'qrCodeContent': item.qrCodeContent,
      // 'qrCodeImage': item.qrCodeImage,
      // 'prompt': item.prompt,
      'timestamp': item.timestamp,
      // 'result': item.imgUrl,
      'status': item.status,
    };

    String uid = user?.uid ?? 'records';
    db.collection(uid).add(record).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
    });
  }
}
