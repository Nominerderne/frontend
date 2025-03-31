import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// class Profile {
//   final String username;
//   final String email;
//   final String bio;
//   final String profileImage;

//   Profile({
//     required this.username,
//     required this.email,
//     required this.bio,
//     required this.profileImage,
//   });

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       username: json['username'],
//       email: json['email'],
//       bio: json['bio'],
//       profileImage: json['profile_image'] ?? '', // Handling null case
//     );
//   }
// }

class ProfilePag extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String bio = '';
  String profileImage = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> getUserInfo(String token) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/profile/');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        username = responseData['user_info']['username'];
        email = responseData['user_info']['email'];
        bio = 'Bio not provided';
        profileImage = ''; // Profile зураг оруулна уу
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Алдаа гарлаа: ${response.body}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Профайл')),
      body: Center(
        child:
            isLoading
                ? CircularProgressIndicator() // Loading үзүүлж байх
                : errorMessage.isNotEmpty
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage, style: TextStyle(color: Colors.red)),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileImage.isNotEmpty
                        ? Image.network(profileImage) // Profile зураг харуулах
                        : Icon(Icons.account_circle, size: 100), // Icon
                    Text('Нэвтрэх нэр: $username'),
                    Text('И-мэйл: $email'),
                    Text('Биография: $bio'),
                  ],
                ),
      ),
    );
  }
}
