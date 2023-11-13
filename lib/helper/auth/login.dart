import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mage/helper/auth/get_user.dart';
import 'package:mage/helper/auth/sign_in_with_anonymously.dart';

Future login() async {
  // 注册/登录
  User? user = await getUser();
  if (user == null) {
    // 匿名注册
    await signInWithAnonymously();
    User? user = await getUser();
    if (user != null) {
      refreshToken(user);
    }
  } else {
    // 登录信息过期，todo 跳转到 login
    // todo
    print('${user.metadata.lastSignInTime}');

    final prefs = await SharedPreferences.getInstance();
    final expiration = prefs.getInt('expiration') ?? 0;
    DateTime now = DateTime.now();
    DateTime oneHourLater = now.add(const Duration(hours: 1));
    int timestamp = oneHourLater.millisecondsSinceEpoch ~/ 1000;
    if (timestamp > expiration) {
      // 刷新 token
      refreshToken(user);
    }
  }
}

Future refreshToken(User user) async {
  final prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  Duration fiveDays = const Duration(days: 5);
  DateTime fiveDaysLater = now.add(fiveDays);
  int timestampInSeconds = fiveDaysLater.millisecondsSinceEpoch ~/ 1000;
  await prefs.setInt('expiration', timestampInSeconds);
  await prefs.setString('token', '${user.uid}_$timestampInSeconds');
}
