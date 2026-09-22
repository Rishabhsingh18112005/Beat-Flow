import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:new_pro/sec_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const SecScreen();
        }

        return const MyHomePage(title: "Login");
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF061A33),
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: Color(0xFF38D9FF),
          secondary: Color(0xFFFFC107),
          surface: Color(0xFF102F4D),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF092442),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AuthCheck(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  bool _showpassword = false;
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  Future<bool> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: usernameC.text.trim(),
            password: passwordC.text.trim(),
          );
      print(userCredential.user?.email);
      return true;
    } on FirebaseAuthException catch (e) {
      print("Code: ${e.code}");
      print("Message: ${e.message}");
      return false;
    }
  }

  bool animate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        backgroundColor: Color(0xFF0B5FA5),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          //blue cyan gradiant
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0878C9), Color(0xFF18C9E8)],
            ),
          ),

          child: Center(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,

              width: MediaQuery.of(context).size.width * 0.85,
              height: animate ? 451 : 0,

              decoration: BoxDecoration(
                //glass blue Card
                color: Colors.white.withOpacity(0.16),
                borderRadius: BorderRadius.circular(30),

                border: Border.all(
                  color: Colors.white.withOpacity(0.30),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 3,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 50,
                  bottom: 50,
                ),

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Login Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '-𝑳𝒐𝒈 𝑰𝒏-',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      //Email
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: usernameC,
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Error';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.20),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFFFFD54F),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFD54F),
                                    width: 2,
                                  ),
                                ),
                                labelText: 'Username',
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Password
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: passwordC,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Error';
                                }
                                return null;
                              },
                              obscureText: _showpassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.20),
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  color: Color(0xFFFFD54F),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showpassword = !_showpassword;
                                    });
                                  },
                                  child: Icon(
                                    _showpassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFFFFD54F),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFFD54F),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Get Help
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            opacity: animate ? 1 : 0,
                            duration: const Duration(seconds: 2),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Get Help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Login Button
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            opacity: animate ? 1 : 0,
                            duration: const Duration(seconds: 2),

                            child: SizedBox(
                              width: 190,
                              height: 50,

                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool didLogin = await login();

                                    if (didLogin) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SecScreen(),
                                        ),
                                      );
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          didLogin
                                              ? 'Successfully Login'
                                              : 'Login Failed',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFC107),
                                  foregroundColor: Colors.black,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      //Sign Up
                      TextButton(
                        onPressed: () async {
                          //Existing Sign Up code
                          if (_formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .createUserWithEmailAndPassword(
                                    email: usernameC.text.trim(),
                                    password: passwordC.text.trim(),
                                  );

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                    'name': 'New User',
                                    'email': usernameC.text.trim(),
                                    'bio': 'Hello 👋',
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Account Created Successfully"),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message ?? "Signup Failed"),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "New Here? Sign Up",
                          style: TextStyle(
                            color: Color(0xFFFFD54F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
