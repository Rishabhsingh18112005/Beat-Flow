import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_pro/SettingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String profileUserId;

  const Profile({super.key, required this.profileUserId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> followUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    final targetUserId = widget.profileUserId;

    if (currentUserId == targetUserId) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .set({'followedAt': FieldValue.serverTimestamp()});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .set({'followedAt': FieldValue.serverTimestamp()});

      print("FOLLOW SUCCESS");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Followed successfully!")));
      }
    } catch (e) {
      print("FOLLOW ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Follow Error: $e")));
      }
    }
  }

  Future<void> unfollowUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final currentUserId = currentUser.uid;
    final targetUserId = widget.profileUserId;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('followers')
          .doc(currentUserId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(targetUserId)
          .delete();

      print("UNFOLLOW SUCCESS");
    } catch (e) {
      print("UNFOLLOW ERROR: $e");
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  Stream<int> followerCount() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileUserId)
        .collection('followers')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> followingCount() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileUserId)
        .collection('following')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    debugPrint("CURRENT USER ID = ${user?.uid}");
    debugPrint("PROFILE USER ID = ${widget.profileUserId}");
    debugPrint("CURRENT USER EMAIL = ${user?.email}");

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0xFF0755C9),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
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
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Center(
                  child: Column(
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.profileUserId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            debugPrint("Firestore Error: ${snapshot.error}");

                            return Text(
                              "Profile data can't be load",
                              style: TextStyle(color: Colors.red),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Text(
                              "Profile data can't find",
                              style: TextStyle(color: Colors.red),
                            );
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey.shade300,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Image.network(
                                      data['imageUrl'].toString(),
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }

                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            debugPrint("IMAGE ERROR = $error");
                                            debugPrint(
                                              "IMAGE URL = ${data['imageUrl']}",
                                            );

                                            return const Icon(
                                              Icons.error,
                                              size: 60,
                                              color: Colors.red,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                data['name'] ?? "No Name",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                data['bio'] ?? "No Bio",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StreamBuilder<int>(
                            stream: followerCount(),
                            builder: (context, snapshot) {
                              return statBox(
                                "${snapshot.data ?? 0}",
                                "Followers",
                              );
                            },
                          ),
                          StreamBuilder<int>(
                            stream: followingCount(),
                            builder: (context, snapshot) {
                              return statBox(
                                "${snapshot.data ?? 0}",
                                "Following",
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          if (user!.uid != widget.profileUserId)
                            Expanded(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.profileUserId)
                                    .collection('followers')
                                    .doc(user.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  final isFollowing =
                                      snapshot.data?.exists ?? false;

                                  return SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (isFollowing) {
                                          await unfollowUser();
                                        } else {
                                          await followUser();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFFFC107,
                                        ),
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        isFollowing ? 'Following' : 'Follow',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          if (user.uid != widget.profileUserId)
                            const SizedBox(width: 15),

                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Share feature baad me add karenge
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC107),
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Featured Playlist',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      playlistCard("Liked Songs", Icons.library_add_check),
                      playlistCard("My Playlist", Icons.playlist_play),
                      playlistCard("Downloads", Icons.download_sharp),
                      playlistCard("Favourite Artist", Icons.favorite),
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

  Widget statBox(String number, String title) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget playlistCard(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF087ED8).withOpacity(0.65),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFFC107), size: 24),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
