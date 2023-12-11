import 'package:go_router/go_router.dart';
import 'package:mage/pages/account_manage/account_manage_page.dart';
// import 'package:mage/pages/future_page/future_page.dart';
import 'package:mage/pages/login/login_page.dart';
import 'package:mage/pages/home/home_page.dart';
import 'package:mage/pages/me/me.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(title: 'Home'),
      // builder: (context, state) => const FuturePage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(title: 'Home'),
    ),
    GoRoute(
      path: '/me',
      builder: (context, state) => const MePage(title: 'Me'),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(title: 'Login'),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountManagePage(),
    ),
  ],
);
