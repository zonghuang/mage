import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mage/helper/auth/get_user.dart';
import 'package:mage/components/app_navigation_bar.dart';
import 'package:mage/components/milestone_timeline.dart';

class MePage extends StatefulWidget {
  const MePage({super.key, required this.title});
  final String title;

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  User? user;

  @override
  initState() {
    super.initState();
    getUser().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //   actions: <Widget>[
          //   Container(
          //     padding: const EdgeInsets.only(right: 16),
          //     child: GestureDetector(
          //       onTap: () {
          //         // context.go('/account');
          //       },
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           ClipRRect(
          //             borderRadius: BorderRadius.circular(35),
          //             child: Image.asset(
          //               'images/logo.png',
          //               width: 32,
          //               height: 32,
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //           Text(user?.email ?? '', style: const TextStyle(fontSize: 12)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ],
          title: Text(AppLocalizations.of(context)!.me)),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: const Column(
          children: [
            MilestoneTimeline(),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
