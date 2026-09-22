import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? imageUrl;

  String cloudName = "vksw313p";
  String uploadPreset = "rishifirst_preset";

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    print('Bottom Clicked');

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      debugPrint("Picked :${pickedFile?.path}");

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        debugPrint("Image Updated");
      } else {
        debugPrint("User Cancelled");
      }
    } catch (e) {
      debugPrint("ERROR : $e");
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile) async {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/vksw3l3p/image/upload",
    );

    var request = http.MultipartRequest("POST", uri);

    request.fields["upload_preset"] = "rishifirst_preset";
    request.files.add(
      await http.MultipartFile.fromPath("file", imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      debugPrint("Status Code:${response.statusCode}");

      var responseData = await response.stream.bytesToString();
      var jsondata = jsonDecode(responseData);
      return jsondata["secure_url"];
    } else {
      var error = await response.stream.bytesToString();
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint(error);

      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      nameController.text = data['name'] ?? "";
      bioController.text = data['bio'] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.camera_alt, size: 35) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  String? imageUrl;

                  if (_image != null) {
                    imageUrl = await uploadImageToCloudinary(_image!);
                  }

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .update({
                        'name': nameController.text.trim(),
                        'bio': bioController.text.trim(),
                        'imageUrl': imageUrl,
                      });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile Updated Successfully")),
                  );
                  Navigator.pop(context);
                },
                child: Text("Save", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
