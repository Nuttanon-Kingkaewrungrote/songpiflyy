import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicplayer2/models/like.dart';
import 'package:musicplayer2/pages/listpage.dart';
import 'package:provider/provider.dart';
import '../components/neu_box.dart';
import '../models/playlist.dart';
import 'package:http/http.dart' as http;

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  // convert seconds into min:seconds
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        // get playlist
        final playlist = value.playlist;

        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.primary,

                        ),
                      ),

                      // page title
                      Text(
                        'P L A Y L I S T',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                      // menu button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // album artwork
                  NeuBox(
                    padding: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // album artwork
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // song & artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    currentSong.artistName,
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                ],
                              ),

                           // heart icon with navigation
GestureDetector(
  onTap: () {
    _removeToFavorites(context, currentSong.songName);
    rebuildFavPage(context); // เรียกใช้ rebuildFavPage เมื่อกลับมาหน้า FavPage
  },
  child: Icon(
    Icons.thumb_down,
    color: Colors.red.shade400,
  ),
),



// heart icon with navigation
GestureDetector(
  onTap: () {
    _addToFavorites(context, currentSong.songName);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavPage()),
    );
  },
  child: Icon(
    Icons.favorite,
    color: Colors.red.shade400,
  ),
),




                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // song duration progress
                  Column(
                    children: [
                      // start and end time
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // start time
                            Text(
                              formatTime(value.currentDuration),
                              style: const TextStyle(color: Colors.grey),
                            ),

                            // shuffle
                            const Icon(Icons.shuffle, color: Colors.grey),

                            // repeat
                            const Icon(Icons.repeat, color: Colors.grey),

                            // end time
                            Text(
                              formatTime(value.totalDuration),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // slider
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green.shade400,
                          inactiveColor: Theme.of(context).colorScheme.tertiary,
                          onChanged: (double value) {
                            // during when the user sliding around
                          },
                          onChangeEnd: (double double) {
                            // sliding has finished, go to that position
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // playback controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // back
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreviousSong,
                          child: const NeuBox(
                            padding: 20,
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // pause / play
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            padding: 20,
                            child: Icon(
                              value.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // forward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(
                            padding: 20,
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
 void _addToFavorites(BuildContext context, String songName) {
    // Update the current song index


    // Add the song to favorites in the database (You need to implement this part)
    _addToFavoritesInDatabase(songName);

    // Navigate to the song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }
  
  // Function to add song to favorites in the database
  Future<void> _addToFavoritesInDatabase(String songName) async {
//  var url = "http://192.168.50.217/flutter_login/songindex.php";
 var url = "https://songpifly.phusingdev.com/songindex.php";

   
  
  // Your data to be posted
  var data = {
    'songname': songName,
  
  };

  // Encode the data to JSON
  var jsonData = jsonEncode(data);

  try {
    // Make POST request to PHP endpoint
    var response = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: {'Content-Type': 'application/json'},
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Print response from PHP server
      print('Response from PHP: ${response.body}');
    } else {
      // Print error message
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // Print error message if request fails
    print('Exception details: $e');
  }
  }
}


 
 void _removeToFavorites(BuildContext context, String songName) {
    // Update the current song index


    // Add the song to favorites in the database (You need to implement this part)
    _removeToFavoritesInDatabase(songName);

    // Navigate to the song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }
  
  // Function to add song to favorites in the database
  Future<void> _removeToFavoritesInDatabase(String songName) async {
 var url = "http://192.168.50.217/flutter_login/removesongindex.php";
   
  
  // Your data to be posted
  var data = {
    'songname': songName,
  
  };

  // Encode the data to JSON
  var jsonData = jsonEncode(data);

  try {
    // Make POST request to PHP endpoint
    var response = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: {'Content-Type': 'application/json'},
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Print response from PHP server
      print('Response from PHP: ${response.body}');
    } else {
      // Print error message
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // Print error message if request fails
    print('Exception details: $e');
  }
  }

// ประกาศฟังก์ชัน rebuildFavPage ใน FavPage
void rebuildFavPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => FavPage()),
  );
}
