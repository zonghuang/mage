import 'package:flutter/material.dart';
import 'package:mage/helper/auth/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:mage/router.dart';
import 'package:mage/models/record.dart';
import 'package:mage/models/user.dart';
import 'package:mage/models/aliyun.dart';
import 'package:mage/models/art_style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

  // 注册/登录
  await login();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        Provider(create: (context) => ArtStyleModel()),
        ChangeNotifierProvider(create: (context) => ArtStyleModel()),
        Provider(create: (context) => RecordModel()),
        ChangeNotifierProvider(create: (context) => RecordModel()),
        Provider(create: (context) => AliyunModel()),
        ChangeNotifierProvider(create: (context) => AliyunModel()),
      ],

      // Router
      child: MaterialApp.router(
        title: 'mage App',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('zh'), // Chinese
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
