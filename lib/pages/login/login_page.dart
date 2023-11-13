import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mage/helper/user_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String msg = 'status';

  @override
  void initState() {
    super.initState();
  }

  void gohome() {
    context.go('/home');
  }

  void _register() {
    register('muse@gmail.com', 'musetest');
  }

  void _signIn() {
    signIn('muse@gmail.com', 'musetest');
  }

  void _signOut() {
    signOut();
  }

  void _deleteUser() {
    deleteUser('muse@gmail.com', 'musetest');
  }

  void _getAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print(user);
      }
    });
  }

  void _signInWithApple() {}

  void _signInWithGoogle() async {
    var data = await signInWithGoogle();
    print('data: $data');
  }

  // void _deleteWithGoogle() {
  //   setState(() {
  //     msg = 'deleteing...';
  //   });
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) async {
  //     setState(() {
  //       msg = 'wait deleteing...';
  //     });
  //     print('user: $user');
  //     await user?.delete();
  //     setState(() {
  //       msg = 'User deleted successfully!';
  //     });
  //     print("User deleted successfully!");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign in'),
            ElevatedButton(onPressed: gohome, child: const Text('Go home')),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
            ElevatedButton(onPressed: _signIn, child: const Text('Sign in')),
            ElevatedButton(onPressed: _signOut, child: const Text('Sign out')),
            ElevatedButton(
                onPressed: _deleteUser, child: const Text('Delete user')),
            ElevatedButton(
                onPressed: _getAuthState, child: const Text('Get AuthState')),
            ElevatedButton(
                onPressed: _signInWithApple, child: const Text('Apple')),
            ElevatedButton(
                onPressed: _signInWithGoogle, child: const Text('Google')),
            // ElevatedButton(
            //     onPressed: _deleteWithGoogle,
            //     child: const Text('Delete Google')),
            Text('Message: $msg')
          ],
        ),
      ),
    );
  }
}
