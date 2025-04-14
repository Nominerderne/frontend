// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'profile.dart'; // ProfilePage руу шилжих

// class Profile1Page extends StatefulWidget {
//   @override
//   _Profile1PageState createState() => _Profile1PageState();
// }

// class _Profile1PageState extends State<Profile1Page> {
//   String username = "";
//   String email = "";
//   String profileImageBase64 = "";

//   @override
//   void initState() {
//     super.initState();
//     getUserInfo();
//   }

//   // SharedPreferences-аас хэрэглэгчийн мэдээллийг авах
//   Future<void> getUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       username = prefs.getString('username') ?? 'Таны нэр';
//       email = prefs.getString('email') ?? 'Таны имэйл';
//       profileImageBase64 = prefs.getString('profileImage') ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Таны Профайл')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Профайл зураг
//             CircleAvatar(
//               radius: 60,
//               backgroundImage:
//                   profileImageBase64.isNotEmpty
//                       ? MemoryImage(base64Decode(profileImageBase64))
//                       : AssetImage('assets/images/profile.jpeg')
//                           as ImageProvider,
//             ),
//             SizedBox(height: 16),
//             Text('Нэвтрэх нэр: $username'),
//             Text('Имэйл: $email'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // ProfilePage руу шилжих
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfilePage()),
//                 );
//               },
//               child: Text('Профайл засах'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
