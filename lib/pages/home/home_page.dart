import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mage/components/app_navigation_bar.dart';
import 'package:mage/components/home_art_styles.dart';
import 'package:mage/components/home_input.dart';
import 'package:mage/data/constants/system.dart';
import 'package:mage/data/persistence/records_storage.dart';
import 'package:mage/data/service/post.service.dart';
import 'package:mage/helper/auth/get_user.dart';
import 'package:mage/models/art_style.dart';
import 'package:mage/models/record.dart';
import 'package:mage/models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    RecordsStorage storage = RecordsStorage();
    storage.readRecords().then((value) {
      var recordModel = Provider.of<RecordModel>(context, listen: false);
      recordModel.updateRecordList(value);
    });
  }

  Future<void> make() async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var userModel = Provider.of<UserModel>(context, listen: false);
    var artStyleModel = Provider.of<ArtStyleModel>(context, listen: false);
    var recordModel = Provider.of<RecordModel>(context, listen: false);
    userModel.goTab(context, 'me');

    var lora = artStyleModel.artStyleForm.lora;
    var mode = artStyleModel.artStyleForm.mode.first.name;
    var qrCodeContent = artStyleModel.artStyleForm.qrCodeContent;
    var qrCodeImage = artStyleModel.artStyleForm.qrCodeImage;
    var prompt = artStyleModel.artStyleForm.prompt;

    artStyleModel.artStyleForm.qrCodeContent = '';
    artStyleModel.artStyleForm.qrCodeImage = '';
    artStyleModel.artStyleForm.prompt = '';
    artStyleModel.updateArtStyleForm();

    // 插入数据（State）
    var id = recordModel.recordList.length.toString();
    RecordItem newItem = RecordItem(
      id: id,
      lora: lora,
      result: '',
      status: 'pending',
      timestamp: timestamp,
    );
    recordModel.recordList.insert(0, newItem);
    var storage = RecordsStorage();
    await storage.writeRecords(recordModel.recordList);
    var records = await storage.readRecords();
    recordModel.updateRecordList(records);

    /// 生成
    var res = await postService<ArtStyleResult>(
        ArtStyleResult.fromJson, apiGenerate, {
      'lora': lora,
      'mode': mode,
      'qrCodeContent': mode == 'prompt' ? prompt : qrCodeContent,
      // 'qrCodeContent': qrCodeContent,
      'qrCodeImage': qrCodeImage,
      'prompt': prompt
    });
    print('res: ${res.imgUrl}');

    artStyleModel.updateResult(res.imgUrl);

    /// 存记录到本地
    RecordItem recordToUpdate =
        recordModel.recordList.firstWhere((record) => record.id == id);
    if (res.imgUrl != '') {
      recordToUpdate.status = 'fulfilled';
      recordToUpdate.result = res.imgUrl;
    } else {
      recordToUpdate.status = 'rejected';
    }
    await storage.writeRecords(recordModel.recordList);
    var newRecords = await storage.readRecords();
    recordModel.updateRecordList(newRecords);

    /// 数据存档（Cloud）
    var db = FirebaseFirestore.instance;
    final record = <String, dynamic>{
      'lora': lora,
      'mode': mode,
      'qrCodeContent': qrCodeContent,
      'qrCodeImage': qrCodeImage,
      'prompt': prompt,
      'timestamp': timestamp,
      'result': res.imgUrl,
      'status': res.imgUrl == '' ? 'rejected' : 'fulfilled',
    };

    User? user = await getUser();
    print('uid: ${user?.uid}');
    String uid = user?.uid ?? 'records';
    db.collection(uid).add(record).then((DocumentReference doc) {
      print('DocumentSnapshot added with ID: ${doc.id}');
    });
  }

  Future<void> clear() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          AppLocalizations.of(context)!.homeTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const HomeArtStyles(),
              const HomeInput(),
              ElevatedButton.icon(
                onPressed: make,
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
                icon: const Icon(Icons.draw_outlined),
                label: Text(AppLocalizations.of(context)!.make),
              ),
              // ElevatedButton(onPressed: clear, child: const Text('Clear')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
