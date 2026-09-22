import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_pro/MusicPlayer.dart';
import 'package:new_pro/Profile.dart';

final List<Map<String, String>> searchSongs = [
  {
    'title': 'I Love What You Do To Me',
    'artist': 'The Soundlings',
    'image': 'assets/images/img1.jpg',
    'url': 'assets/audio/song1.mp3',
  },
  {
    'title': 'Flow My Tears',
    'artist': 'A Person Unknown',
    'image': 'assets/images/img.jpg',
    'url': 'assets/audio/song2.mp3',
  },
  {
    'title': 'Always Yours',
    'artist': 'The Parisian feat. Paris Fleming',
    'image': 'assets/images/img3.jpg',
    'url': 'assets/audio/song3.mp3',
  },
];

String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning 🌞';
  } else if (hour < 17) {
    return 'Good Afternoon ⛅';
  } else if (hour < 21) {
    return 'Good Evening 🍵';
  } else {
    return 'Good Night 🌜';
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];

  List<Map<String, String>> songResults = [];

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        songResults = [];
      });
      return;
    }
    try {
      //Users Search
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      final userResults = snapshot.docs
          .where((doc) {
            final data = doc.data();
            final name = (data['name'] ?? '').toString().toLowerCase();

            return name.contains(query.trim().toLowerCase());
          })
          .map((doc) {
            return {'id': doc.id, ...doc.data()};
          })
          .toList();
      final searchText = query.trim().toLowerCase();
      //Song Search
      final songSearchResults = searchSongs.where((song) {
        final title = song['title']!.toLowerCase();
        final artist = song['artist']!.toLowerCase();


        return title.contains(searchText) || artist.contains(searchText);
      }).toList();

      setState(() {
        searchResults = userResults;
        songResults = songSearchResults;
      });

      print("SONG RESULTS: $songResults");

      print('USERS FOUND: ${userResults.length}');
      print('SONGS FOUND: ${songSearchResults.length}');
    } catch (e) {
      print("SEARCH ERROR: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
        backgroundColor: Color(0xFF0755C9),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0755C9), Color(0xFF087ED8), Color(0xFF00B8D9)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getGreeting(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Find Ur Taste Here 😉😋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 70,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0755C9),
                      Color(0xFF087ED8),
                      Color(0xFF00B8D9),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FC),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            searchUsers(value);
                          },
                          style: const TextStyle(
                            color: Color(0xFF102F4D),
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Search for Music, Artist, Album',
                            hintStyle: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 7),

                    Container(
                      height: 58,
                      width: 58,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Color(0xFF087ED8),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              if (songResults.isNotEmpty) ...[
                const SizedBox(height: 15),

                ...songResults.map((song) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),

                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          song['image']!,
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),

                      title: Text(
                        song['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        song['artist']!,
                        style: const TextStyle(color: Colors.white70),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Color(0xFFFFC107),
                          size: 38,
                        ),
                        onPressed: () {
                          final index = searchSongs.indexOf(song);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayer(
                                songTitle: song['title']!,
                                artist: song['artist']!,
                                audioUrl: song['url']!,
                                songIndex: index,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: searchResults.map((user) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xFFFFC107),
                          backgroundImage:
                              user['imageUrl'] != null &&
                                  user['imageUrl'].toString().isNotEmpty
                              ? NetworkImage(user['imageUrl'].toString())
                              : null,
                          child:
                              user['imageUrl'] == null ||
                                  user['imageUrl'].toString().isEmpty
                              ? const Icon(Icons.person, color: Colors.black)
                              : null,
                        ),
                        title: Text(
                          user['name'] ?? 'No Name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user['bio'] ?? 'No Bio',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Profile(profileUserId: user['id']),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],

              SizedBox(height: 25),
              Text(
                'For You',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  _categoryChip('Rock', true),
                  _categoryChip('Indie', true),
                  _categoryChip('Pop', true),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Artist U May Like',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFFFC107),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28),
              SizedBox(
                height: 145,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _artistCard('The Weeknd', 'assets/images/img.jpg'),
                    _artistCard('Ed Sheeran', 'assets/images/img1.jpg'),
                    _artistCard('Glass Animals', 'assets/images/img3.jpg'),
                  ],
                ),
              ),
              SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending Music',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'See more',
                    style: TextStyle(
                      color: const Color(0xFFFFC107),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              _trendingTile(
                'Blinding Lights',
                'The Weeknd',
                'assets/images/img.jpg',
              ),
              _trendingTile('Perfect', 'Ed Sheeran', 'assets/images/img1.jpg'),
              _trendingTile('Perfect', 'Ed Sheeran', 'assets/images/img1.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String title, bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Color(0xFFFFC107) : Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _artistCard(String name, String image) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(18),
            child: Image.asset(
              image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 7),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _trendingTile(String title, String artist, String image) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadiusGeometry.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.asset(image, height: 55, width: 55, fit: BoxFit.cover),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(artist, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Icon(Icons.favorite_border, color: Colors.white),
        ],
      ),
    );
  }
}
