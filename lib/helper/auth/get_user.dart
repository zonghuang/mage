import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

Future<User?> getUser() async {
  Completer<User?> completer = Completer<User?>(); // 使用Completer来等待异步操作完成

  late User? currentUser;
  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      currentUser = null;
    } else {
      print('User is signed in!');
      currentUser = user;
    }

    completer.complete(currentUser); // 异步操作完成时，通过Completer标记为完成
  });

  return completer.future; // 返回Completer的future，这个future会在异步操作完成时得到结果
}
