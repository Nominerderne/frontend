import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ebook_app/pages/home/home.dart';
import 'package:ebook_app/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      showSnackbar("Хэрэглэгчийн нэр болон нууц үгээ оруулна уу!");
      return;
    }

    final Uri url = Uri.parse("http://127.0.0.1:8000/login/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print(response.body); // Хариуг шалгах
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), // Таны үндсэн хуудсыг хөтлөх
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        showSnackbar("Алдаа: ${errorResponse['error']}");
      }
    } catch (e) {
      showSnackbar("Сервертэй холбогдож чадсангүй! Алдаа: $e");
      print(e); // Алдааг шалгах
    }
  }

  // showSnackbar функц
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  buildTextField("Имэйл", Icons.email, false, _emailController),
                  SizedBox(height: 10),
                  buildTextField(
                    "Нууц үг",
                    Icons.lock,
                    true,
                    _passwordController,
                  ),
                  SizedBox(height: 10),
                  buildGradientButton(context),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Бүртгүүлэх",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon,
    bool isPassword,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget buildGradientButton(BuildContext context) {
    return GestureDetector(
      onTap: login,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepPurple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Нэвтрэх",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:ebook_app/pages/home/home.dart';
// import 'package:ebook_app/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Token хадгалах
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', token); // Token хадгалж байна
//   }

//   // Token авах
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   }

//   // Нэвтрэх үйлдэл
//   Future<void> loginUser() async {
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/token/'),
//       headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       body: jsonEncode({
//         'username': usernameController.text,
//         'password': passwordController.text,
//       }),
//     );

//     print("Response Status: ${response.statusCode}");
//     print("Response Body: ${response.body}");

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       String token = data['access']; // Token авах

//       // Token хадгалах
//       await saveToken(token);

//       // Profile хуудсанд шилжих
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//         (Route<dynamic> route) => false,
//       );
//     } else {
//       var data = jsonDecode(response.body);
//       String errorMessage = data['detail'] ?? 'Алдаа гарлаа';
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
//               decoration: InputDecoration(labelText: 'Нэвтрэх нэр'),
//             ),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Нууц үг'),
//             ),
//             ElevatedButton(onPressed: loginUser, child: Text('Нэвтрэх')),
//             TextButton(
//               onPressed: () {
//                 // Бүртгүүлэх хуудас руу шилжих
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SignupPage(),
//                   ), // SignupPage гэж үүсгэсэн бол
//                 );
//               },
//               child: Text('Бүртгүүлэх'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
