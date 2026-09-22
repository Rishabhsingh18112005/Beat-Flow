import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_pro/EditProfile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0xFF0755C9),
        elevation: 0,
        title: const Text("Settings"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0755C9), Color(0xFF087ED8), Color(0xFF00B8D9)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFFFFC107)),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Color(0xFFFFC107)),
                title: Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFFFC107),
                  size: 16,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditProfile()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
