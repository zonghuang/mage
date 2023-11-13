import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mage/helper/auth/create_user_with_email.dart';
import 'package:mage/helper/auth/link_with_credential.dart';
import 'package:mage/helper/auth/sign_in_with_google.dart';
import 'package:mage/helper/upload_local_to_cloud.dart';

class AccountManagePage extends StatefulWidget {
  const AccountManagePage({super.key});

  @override
  State<AccountManagePage> createState() => _AccountManagePageState();
}

class _AccountManagePageState extends State<AccountManagePage> {
  var provider = 'google';
  var email = '';
  var password = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  void goback() {
    context.go('/me');
  }

  Future<void> linkGoogle() async {
    // linkWithCredential('google', {});
    await signInWithGoogle();

    await uploadLocalToCloud();
  }

  Future<void> linkEmail() async {
    // linkWithCredential('email', {'email': email, 'password': password});
    await createUserWithEmail(email, password);

    await uploadLocalToCloud();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: provider == 'google',
              child: ElevatedButton(
                  onPressed: linkGoogle, child: const Text('Signin Google')),
            ),
            Visibility(
              visible: provider == 'email',
              child: SizedBox(
                width: 320,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (text) {
                        email = text;
                      },
                      controller: TextEditingController(text: email),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Please input your email.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (text) {
                        password = text;
                      },
                      obscureText: _obscureText,
                      controller: TextEditingController(text: password),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Please input your password.',
                        suffixIcon: IconButton(
                          onPressed: () => {
                            setState(() {
                              _obscureText = !_obscureText;
                            })
                          },
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: linkEmail,
                      child: const Text('Link with Email'),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  provider = provider == 'google' ? 'email' : 'google';
                });
              },
              child: Text(
                provider == 'google' ? 'Link with Email' : 'Link with Google',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            ElevatedButton(onPressed: goback, child: const Text('Go back')),
          ],
        ),
      ),
    );
  }
}
