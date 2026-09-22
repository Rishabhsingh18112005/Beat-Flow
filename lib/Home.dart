import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_pro/MusicPlayer.dart';
import 'package:just_audio/just_audio.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  final List<Map<String, String>> trendingSongs = [
    {
      'title': 'I Love What You Do To Me',
      'artist': 'The Soundlings',
      'image': 'https://picsum.photos/300/300?random=1',
    },
    {
      'title': 'Flow My Tears',
      'artist': 'A Person Unknown',
      'image': 'https://picsum.photos/300/300?random=2',
    },
    {
      'title': 'Always Yours (feat. The Parisian & Paris Fleming)',
      'artist': 'The Parisian feat. Paris Fleming',
      'image': 'https://picsum.photos/300/300?random=3',
    },
  ];

  final List<Map<String, String>> playlists = [
    {
      'title': 'Chill Vibes',
      'subtitle': 'Relax & Enjoy',
      'image': 'https://picsum.photos/400/400?random=4',
    },
    {
      'title': 'Workout Mix',
      'subtitle': 'Power Your Day',
      'image': 'https://picsum.photos/400/400?random=5',
    },
    {
      'title': 'Late Night',
      'subtitle': 'Midnight Feelings',
      'image': 'https://picsum.photos/400/400?random=6',
    },
    {
      'title': 'Energy',
      'subtitle': 'Energetic',
      'image': 'https://picsum.photos/400/400?random=7',
    },
    {
      'title': 'Party Mood',
      'subtitle': 'Friends',
      'image': 'https://picsum.photos/400/400?random=8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0755C9), Color(0xFF087ED8), Color(0xFF00B8D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "BeatFlow",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Feel the Music🎧",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none, color: Colors.white),
                  ),
                ),
                SizedBox(height: 25),
                //Welcome Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1265D9), Color(0xFF1265D9)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Ready to Listen Something Amazing",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 15),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.black,
                                size: 20,
                              ),
                              label: const Text(
                                'Play Music',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.headphones, size: 75, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                //Trending
                sectionTitle('Trending Songs', 'See All'),
                SizedBox(height: 15),
                SizedBox(
                  height: 215,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingSongs.length,
                    itemBuilder: (context, index) {
                      final song = trendingSongs[index];

                      return GestureDetector(
                        onTap: () {
                          globalCurrentIndex = index;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayer(
                                songTitle: song['title']!,
                                artist: song['artist']!,
                                audioUrl: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
                                  songIndex: index,
                            ),
                            ),
                          );
                        },
                        child: Container(
                          width: 155,
                          margin: EdgeInsets.only(right: 14),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(15),
                                child: Image.network(
                                  song['image']!,
                                  height: 130,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                song['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                song['artist']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 28),
                //Recently Played
                sectionTitle('Recently Played', "See All"),
                SizedBox(height:12, width: 12),
                musicTile('Blinding Light', 'The weekend', Icons.music_note),
                musicTile('Shape of You', 'Ed Sheeran', Icons.music_note),
                musicTile('Heat Waves', 'Glass Animals', Icons.music_note),
                musicTile('Save your Tears', 'The Weekend', Icons.music_note),
                musicTile('In your Eyes', 'The Weekend ', Icons.music_note),
                SizedBox(height: 28),
                //PlayList
                sectionTitle('Recommended Playlist', 'See All'),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return Container(
                        width: 145,
                        margin: EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Image.network(
                                playlist['image']!,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    playlist['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    playlist['subtitle']!,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Mini Player
      bottomSheet: StreamBuilder<PlayerState>(
        stream: globalPlayer.playerStateStream,
        builder: (context, snapshot) {
          final isPlaying = snapshot.data?.playing ?? false;
          final currentIndex = globalCurrentIndex;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                    songTitle: songs[currentIndex]['title']!,
                    artist: songs[currentIndex]['artist']!,
                    audioUrl: songs[currentIndex]['url']!,
                    songIndex: currentIndex,
                  ),
                ),
              );
            },
            child: Container(
              height: 70,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF063E91),
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      songs[currentIndex]['image']!,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[currentIndex]['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          songs[currentIndex]['artist']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      try {
                        if (isPlaying) {
                          globalPlayer.pause();
                        } else {
                          globalPlayer.setAsset(
                            songs[globalCurrentIndex]['url']!,
                          ).then((_){
                            globalPlayer.play();
                          });
                        }
                      }catch (e) {
                        debugPrint('Mini Player Error: $e');
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFFFFC107),
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //Section Tile
  Widget sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //Music Tile
  Widget musicTile(String title, String artist, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    artist,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFFFFC107),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
