// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();

//   Future<void> _registerUser() async {
//     final response = await http.post(
//       Uri.parse('127.0.0.1:8000/register/'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'username': _usernameController.text,
//         'password': _passwordController.text,
//         'email': _emailController.text,
//       }),
//     );

//     if (response.statusCode == 201) {
//       // Бүртгэл амжилттай
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Бүртгэл амжилттай')));
//     } else {
//       // Алдаа гарсан
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа!')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Шинэ хэрэглэгч бүртгэх')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Хэрэглэгчийн нэр'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Нууц үг'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Имэйл хаяг'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(onPressed: _registerUser, child: Text('Бүртгүүлэх')),
//           ],
//         ),
//       ),
//     );
//   }
// }
