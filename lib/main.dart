import 'dart:convert';
import 'package:ebook_app/pages/home/home.dart';
import 'package:ebook_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './config.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Cookie хадгалах

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  // Хэрэглэгчийн session-ийг шалгах функц
  Future<void> checkLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');

    if (sessionCookie != null) {
      // Хэрэв sessionCookie байгаа бол хэрэглэгч нэвтэрсэн байна
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Нэвтэрсэн эсэхийг шалгах
    checkLoginStatus(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment:
                  MainAxisAlignment.center, // төвлөрүүлж байрлуулах
              children: [
                Text(
                  'Монгол ардын үлгэр, домог',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 223, 69, 192),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 90),

                // Нэвтрэх товч
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Нэвтрэх', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),

                SizedBox(height: 20), // Товчлууруудын хооронд зай нэмэх
                // Бүртгүүлэх товч
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Бүртгүүлэх',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),

                SizedBox(height: 30), // Доорх зай
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Имэйл болон нууц үгээ оруулна уу!");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl + 'user/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': "login",
          'email': email,
          'password': hashPassword(password),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["resultCode"] == 200) {
          String? rawCookie = response.headers['set-cookie'];
          if (rawCookie != null) {
            String sessionCookie = rawCookie.split(';')[0];
            await saveSessionCookie(sessionCookie);
          }

          // Хэрэглэгчийн мэдээллийг хадгалах
          final user = responseData["data"][0];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userid', user["userid"]);
          await prefs.setString('username', user["username"]);
          await prefs.setString('email', user["email"]);

          // Амжилттай нэвтэрсэн тул Home рүү шилжих
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          showSnackbar(
            "Нэвтрэхэд алдаа гарлаа: ${responseData["resultMessage"]}",
          );
        }
      } else {
        showSnackbar(
          "2Серверээс алдаатай хариу ирлээ (${response.statusCode})",
        );
      }
    } catch (e) {
      showSnackbar("Сервертэй холбогдож чадсангүй! Алдаа: $e");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Имэйл'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Нууц үг'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: login, child: Text('Нэвтрэх')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
