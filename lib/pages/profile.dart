import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  String profileImageBase64 = '';
  Uint8List? profileImageBytes;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userid = prefs.getInt('userid');
    final url = Uri.parse(baseUrl + 'useredit/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'getuserinfo', "userid": userid}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['resultCode'] == 200) {
          setState(() {
            usernameController.text = responseData['data'][0]['username'] ?? "";
            emailController.text = responseData['data'][0]['email'] ?? "";
            bioController.text = responseData['data'][0]['bio'] ?? "";
            profileImageBase64 =
                responseData['data'][0]['profileimagebase64'] ?? "";

            if (profileImageBase64.isNotEmpty &&
                profileImageBase64.contains("base64")) {
              try {
                profileImageBytes = base64Decode(
                  profileImageBase64.split(',').last,
                );
              } catch (e) {
                profileImageBytes = null;
                print("Base64 decoding алдаа: $e");
              }
            } else {
              profileImageBytes = null;
            }
          });
        } else {
          showAlert(context, 'Мэдээлэл авахад алдаа гарлаа.');
        }
      } else {
        showAlert(context, 'Сервертэй холбогдож чадсангүй.');
      }
    } catch (e) {
      showAlert(context, 'Хүсэлт илгээхэд алдаа гарлаа: $e');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (kIsWeb) {
          final webImageBytes = await image.readAsBytes();
          setState(() {
            profileImageBytes = webImageBytes;
            profileImageBase64 =
                'data:image/png;base64,${base64Encode(webImageBytes)}';
          });
        } else {
          final bytes = await File(image.path).readAsBytes();
          setState(() {
            profileImageBytes = bytes;
            profileImageBase64 = 'data:image/png;base64,${base64Encode(bytes)}';
          });
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Зураг сонгоход алдаа гарлаа: $e')),
      );
    }
  }

  Future<void> updateUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userid = prefs.getInt('userid');
    final url = Uri.parse(baseUrl + 'useredit/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'edituser',
          "userid": userid,
          'username': usernameController.text,
          'email': emailController.text,
          'bio': bioController.text,
          'profileimagebase64': profileImageBase64,
        }),
      );

      if (response.statusCode == 200) {
        final successData = json.decode(response.body);
        if (successData['resultCode'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Мэдээлэл амжилттай шинэчлэгдлээ')),
          );
        } else {
          showAlert(context, 'Алдаа: ${successData['resultMessage']}');
        }
      } else {
        showAlert(context, 'Сервертэй холбогдож чадсангүй.');
      }
    } catch (e) {
      showAlert(context, 'Алдаа гарлаа: $e');
    }
  }

  void showAlert(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  profileImageBytes != null
                                      ? MemoryImage(profileImageBytes!)
                                      : AssetImage('assets/images/profile.jpeg')
                                          as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: const Color.fromARGB(
                                      255,
                                      89,
                                      139,
                                      225,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Нэвтрэх нэр',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'И-мэйл',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: bioController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Биография',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: updateUserProfile,
                        icon: Icon(Icons.save),
                        label: Text("Хадгалах"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
