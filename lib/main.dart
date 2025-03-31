// import 'package:ebook_app/login.dart';
// import 'package:ebook_app/signup.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(App());
// }

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
//   }
// }

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/login.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 SizedBox(height: 60),
//                 SizedBox(height: 200),
//                 Text(
//                   'Монгол ардын үлгэр, домог',
//                   style: TextStyle(
//                     color: const Color.fromARGB(255, 223, 69, 192),
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 90),

//                 OutlinedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginPage()),
//                     );
//                   },
//                   child: Text('Нэвтрэх', style: TextStyle(color: Colors.black)),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.white),
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   ),
//                 ),

//                 SizedBox(height: 10),

//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignupPage()),
//                     );
//                   },
//                   child: Text(
//                     'Бүртгүүлэх',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                   ),
//                 ),

//                 SizedBox(
//                   height: 30,
//                 ), // Үүнийг энд оруулж, товчны дараа зай үлдээх
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ebook_app/login.dart';
import 'package:ebook_app/signup.dart';
import 'package:flutter/material.dart';

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
