import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

final AndroidEqualizer globalEqualizer = AndroidEqualizer();
final AudioPlayer globalPlayer = AudioPlayer(
  audioPipeline: AudioPipeline(androidAudioEffects: [globalEqualizer]),
);
int globalCurrentIndex = 0;

final List<Map<String, String>> songs = [
  {
    'title': 'I Love What You Do To Me',
    'artist': 'The Soundlings',
    'url': 'assets/audio/song1.mp3',
    'image': 'assets/images/img1.jpg',
  },
  {
    'title': 'Flow My Tears',
    'artist': 'A Person Unknown',
    'url': 'assets/audio/song2.mp3',
    'image': 'assets/images/img.jpg',
  },
  {
    'title': 'Always Yours (The Parisian & Paris Fleming)',
    'artist': 'The Parisian feat. Paris Fleming',
    'url': 'assets/audio/song3.mp3',
    'image': 'assets/images/img3.jpg',
  },
  {
    'title': 'I Love What You Do To Me',
    'artist': 'The Soundlings',
    'url': 'assets/audio/song1.mp3',
    'image': 'assets/images/img1.jpg',
  },
  {
    'title': 'Flow My Tears',
    'artist': 'A Person Unknown',
    'url': 'assets/audio/song2.mp3',
    'image': 'assets/images/img.jpg',
  },
];

class MusicPlayer extends StatefulWidget {
  final String songTitle;
  final String artist;
  final String audioUrl;
  final int songIndex;

  const MusicPlayer({
    super.key,
    required this.songTitle,
    required this.artist,
    required this.audioUrl,
    required this.songIndex,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer get player => globalPlayer;
  final AndroidEqualizer equalizer = AndroidEqualizer();

  int currentIndex = 0;
  bool isFavourite = false;
  bool isShuffle = false;
  bool isRepeat = false;
  bool isEqualizer = false;

  String get currentTitle => songs[currentIndex]['title']!;

  String get currentArtist => songs[currentIndex]['artist']!;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.songIndex;
    globalCurrentIndex = currentIndex;

    loadSong();
  }

  //Next Song Song
  Future<void> nextSong() async {
    if (isShuffle) {
      currentIndex = (currentIndex + 1) % songs.length;
      globalCurrentIndex = currentIndex;
    } else if (currentIndex < songs.length - 1) {
      currentIndex++;
      globalCurrentIndex = currentIndex;
    }
    await player.setAsset(songs[currentIndex]['url']!);

    setState(() {});
    await player.play();
  }

  //Previous Song
  Future<void> previousSong() async {
    if (currentIndex > 0) {
      currentIndex--;
      globalCurrentIndex = currentIndex;

      await player.setAsset(songs[currentIndex]['url']!);

      setState(() {});
      await player.play();
    } else {
      await player.seek(Duration.zero);
    }
  }

  //Load Current Song
  Future<void> loadSong() async {
    try {
      await player.setAsset(songs[currentIndex]['url']!);

      debugPrint("Audio Loaded Successfully");
    } catch (e) {
      debugPrint("AUDIO ERROR: $e");
    }
  }

  Future<void> showEqualizer() async {
    final parameters = await globalEqualizer.parameters;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF102F4D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        final bands = parameters.bands;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Equalizer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),

              _eqSlider('Bass', bands.first),

              _eqSlider('Mid', bands[bands.length ~/ 2]),

              _eqSlider('Treble', bands.last),
            ],
          ),
        );
      },
    );
  }

  Widget _eqSlider(String title, AndroidEqualizerBand band) {
    return StatefulBuilder(
      builder: (context, setSliderState) {
        double currentGain = band.gain;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title  ${currentGain.toStringAsFixed(1)} dB',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            Slider(
              min: -12,
              max: 12,
              value: currentGain.clamp(-12, 12),
              activeColor: const Color(0xFFFFC107),
              inactiveColor: Colors.white30,
              onChanged: (value) {
                setSliderState(() {
                  currentGain = value;
                });

                band.setGain(value);
              },
            ),
          ],
        );
      },
    );
  }

  //Format Line
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    //Global AudioPlayer ko dispose nhi karna hai.
    //Ise Home par music continue rahega
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.share, color: Colors.white, size: 28),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.accessibility, size: 30),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Music Icon
            Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00B8D9).withOpacity(0.35),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  songs[currentIndex]['image']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Song Title
            Text(
              currentTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Artist
            Text(
              currentArtist,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            //Shuffle
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShuffle = !isShuffle;
                    });
                  },
                  icon: Icon(
                    Icons.shuffle,
                    color: isShuffle ? Color(0xFFFFC107) : Colors.white,
                    size: 30,
                  ),
                ),
                //Repeat
                IconButton(
                  onPressed: () {
                    setState(() {
                      isRepeat = !isRepeat;
                    });
                  },
                  icon: Icon(
                    Icons.repeat,
                    color: isRepeat ? Color(0xFFFFC107) : Colors.white,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    isEqualizer = !isEqualizer;
                    showEqualizer();
                  },
                  icon: Icon(Icons.equalizer, color: Colors.white, size: 30),
                ),
                //Favourite
                SizedBox(width: 230),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFavourite = !isFavourite;
                    });
                  },
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                    color: isFavourite ? Color(0xFFFFC107) : Colors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // Progress Bar
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                final duration = player.duration ?? Duration.zero;

                final max = duration.inMilliseconds > 0
                    ? duration.inMilliseconds.toDouble()
                    : 1.0;

                final value = position.inMilliseconds
                    .clamp(0, duration.inMilliseconds)
                    .toDouble();

                return Column(
                  children: [
                    Slider(
                      min: 0,
                      max: max,
                      value: value,
                      activeColor: const Color(0xFFFFC107),
                      inactiveColor: Colors.white30,
                      onChanged: (newValue) {
                        player.seek(Duration(milliseconds: newValue.toInt()));
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(position)),
                          Text(formatDuration(duration)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(width: 20),
            // Play / Pause
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        previousSong();
                      },
                      icon: Icon(Icons.skip_previous, size: 55),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      onPressed: () async {
                        try {
                          if (playing) {
                            await player.pause();
                          } else {
                            await player.play();
                          }
                        } catch (e) {
                          debugPrint("Play Error: $e");
                        }
                      },
                      icon: Icon(
                        playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 75,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        nextSong();
                      },
                      icon: Icon(Icons.skip_next, size: 55),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
