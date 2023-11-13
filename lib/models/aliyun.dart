import 'package:flutter/material.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:mage/data/constants/system.dart';

import 'package:mage/data/service/get.service.dart';

class AliyunStsAuth {
  final String accessKeyId;
  final String accessKeySecret;
  final String securityToken;
  final String expiration;

  const AliyunStsAuth({
    required this.accessKeyId,
    required this.accessKeySecret,
    required this.securityToken,
    required this.expiration,
  });

  factory AliyunStsAuth.fromJson(Map<Object, dynamic> json) {
    return AliyunStsAuth(
      accessKeyId: json['AccessKeyId'],
      accessKeySecret: json['AccessKeySecret'],
      securityToken: json['SecurityToken'],
      expiration: json['Expiration'],
    );
  }
}

class AliyunModel extends ChangeNotifier {
  late AliyunStsAuth _aliyunStsAuth;

  AliyunModel() {
    _aliyunStsAuth = const AliyunStsAuth(
      accessKeyId: '',
      accessKeySecret: '',
      securityToken: '',
      expiration: '',
    );
  }

  AliyunStsAuth get aliyunOSSAuth => _aliyunStsAuth;

  set artStyleForm(AliyunStsAuth value) {
    _aliyunStsAuth = value;
    notifyListeners();
  }

  void updateAliyunStsAuth() {
    notifyListeners();
  }

  Auth _authGetter() {
    return Auth(
      accessKey: _aliyunStsAuth.accessKeyId,
      accessSecret: _aliyunStsAuth.accessKeySecret,
      expire: _aliyunStsAuth.expiration,
      secureToken: _aliyunStsAuth.securityToken,
    );
  }

  Future<void> getAliyunStsAuth() async {
    _aliyunStsAuth =
        await getService<AliyunStsAuth>(AliyunStsAuth.fromJson, apiSts);
  }

  Future<String> putObjectFile(
      String pickedFilePath, String storageFilePath) async {
    if (_aliyunStsAuth.expiration == '' ||
        checkTimeDifference(_aliyunStsAuth.expiration)) {
      await getAliyunStsAuth();
    }

    Client.init(
      // stsUrl: 'http://127.0.0.1:9000/sts',
      ossEndpoint: aliyunOSSEndpoint,
      bucketName: aliyunBucketName,
      authGetter: _authGetter,
    );

    var imgUrl = '';
    await Client().putObjectFile(
      pickedFilePath,
      fileKey: storageFilePath,
      option: PutRequestOption(
        onSendProgress: (count, total) {
          print("send: count = $count, and total = $total");
          if (count == total) {
            imgUrl = '$storageBaseUrl/$storageFilePath';
          }
        },
        onReceiveProgress: (count, total) {
          print("receive: count = $count, and total = $total");
        },
        override: false,
        aclModel: AclMode.publicRead,
        storageType: StorageType.ia,
        // callback: Callback
        // callback: Callback(
        //   callbackUrl: callbackUrl,
        //   callbackBody:
        //       "{\"mimeType\":\${mimeType}, \"filepath\":\${object},\"size\":\${size},\"bucket\":\${bucket},\"phone\":\${x:phone}}",
        //   callbackVar: {"x:phone": "android"},
        //   calbackBodyType: CalbackBodyType.json,
        // ),
      ),
    );
    return imgUrl;
  }
}

bool checkTimeDifference(String isoTime) {
  // Parse the input time
  DateTime inputTime = DateTime.parse(isoTime).toUtc();

  // Get the current UTC time
  DateTime now = DateTime.now().toUtc();

  // Calculate the difference in minutes
  int differenceInMinutes = inputTime.difference(now).inMinutes;

  // If the difference is more than 5 minutes, return false. Otherwise, return true.
  return differenceInMinutes <= 5;
}
