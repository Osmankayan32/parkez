/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/views/login_screen/controller/login_screen_controller.dart';
import 'package:login_screen/widgets/custom_buton.dart';
import 'package:login_screen/widgets/custom_textField.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Sayfası'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              hintText: "E-posta",
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: "Kullanıcı Adı",
              controller: _usernameController,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              hintText: "Şifre",
              controller: _passwordController,
            ),
            const SizedBox(height: 16.0),
            Consumer(
              builder: (context,ref,child) {
                final controller = ref.read(loginController);
                return CustomButon(
                    height: 50,
                    width: 150,
                    onTap: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      String username = _usernameController.text.trim();

                      controller.kayitOl(context, name: username, email: email, password: password);
                    },
                    child: const Text(
                      'Kayıt Ol',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ));
              }
            ),
          ],
        ),
      ),
    );
  }
}
*/
