import 'package:ebook_app/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fnameController = TextEditingController(); // Нэр
  final TextEditingController lnameController = TextEditingController(); // Овог
  /// Password hashing with MD5
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  bool isPasswordVisible = false;

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
      return;
    }

    try {
      final hashedPassword = hashPassword(passwordController.text);

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text, // Change 'uname' to 'username'
          'email': emailController.text,
          'password': hashedPassword, // Change 'upassword' to 'password'
        }),
      );

      print('Response body: ${response.body}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 201) {
        final successData = jsonDecode(response.body);
        String successMessage =
            successData['resultMessage'] ?? 'Амжилттай бүртгэгдлээ!';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(successMessage)));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['resultMessage'] ??
            'Бүртгэл амжилтгүй. Дахин оролдно уу.';

        // Хэрэглэгчийн нэр эсвэл имэйл давхар бүртгэгдсэн тохиолдолд
        if (errorMessage.contains(
          'Энэ хэрэглэгчийн нэр аль хэдийн бүртгэгдсэн байна',
        )) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Энэ хэрэглэгчийн нэр аль хэдийн бүртгэгдсэн байна.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login.jpeg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Бүртгүүлэх',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: 'Нэр'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Имэйл'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Нууц үг'),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Нууц үгээ давтах',
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors
                                  .transparent, // Gradient тулд background-ийг transparent болгоно
                          shadowColor: Colors.transparent, // Сүүдэрийг арилгах
                          padding:
                              EdgeInsets
                                  .zero, // Padding-ийг тэглэж, child дотор өөрөө зохицуулах
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.deepPurple],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: Text(
                              'Бүргтүүлэх',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Нэвтрэх',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:ebook_app/login.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   String hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     final digest = md5.convert(bytes);
//     return digest.toString();
//   }

//   // Flutter signup page нь бүх оролтыг стандарт байдлаар илгээнэ
//   Future<void> registerUser() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Нууц үг таарахгүй байна!')));
//       return;
//     }

//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/register/'),
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode({
//         'username': usernameController.text,
//         'email': emailController.text,
//         'password': passwordController.text, // Plain text password
//       }),
//     );

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Амжилттай бүртгэгдлээ!')));
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } else {
//       var data = jsonDecode(response.body);
//       String errorMessage = data['error'] ?? 'Бүртгэл амжилтгүй';
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(errorMessage)));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: 'Хэрэглэгчийн нэр'),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Имэйл'),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Нууц үг'),
//             ),
//             TextField(
//               controller: confirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Нууц үг давтах'),
//             ),
//             ElevatedButton(onPressed: registerUser, child: Text('Бүртгүүлэх')),
//           ],
//         ),
//       ),
//     );
//   }
// }
