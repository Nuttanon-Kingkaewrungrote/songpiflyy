import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicplayer2/models/like.dart';
import 'package:musicplayer2/pages/home_page.dart';
import 'package:provider/provider.dart';
import '../components/my_drawer.dart';
import '../components/song_tile.dart';

import '../models/song.dart';
import 'song_page.dart';

import 'package:http/http.dart' as http;

class FavPage extends StatelessWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the LikeProvider using Provider.of in the build method
    final likeProvider = Provider.of<LikeProvider>(context, listen: false);

    return Consumer<LikeProvider>(
      builder: (context, value, child) {
        // Get the playlist
        final List<Song> playlist = value.playlist;

        // Return the scaffold
          return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("L I K E"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
          drawer: const MyDrawer(),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              // Get the individual song
              final Song song = playlist[index];

              // Return the song tile UI
             return SongTile(
  song: song,
  onTap: () {
    goToSong(context, index, likeProvider);
    Navigator.pop(context);
  },
);

            },
          ),
        );
      },
    );
  }

  void _addToFavorites(BuildContext context, int songIndex, LikeProvider likeProvider) {
    // Update the current song index
    likeProvider.currentSongIndex = songIndex;

    // Add the song to favorites in the database (You need to implement this part)
    _addToFavoritesInDatabase(likeProvider.playlist[songIndex]);

    // Navigate to the song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }

  // Function to add song to favorites in the database
  Future<void> _addToFavoritesInDatabase(Song song) async {
    // var url = "http://192.168.50.217/flutter_login/image.php";
    var url = "https://songpifly.phusingdev.com/image.php";
    final response = await http.post(Uri.parse(url));
  }

  // Function to navigate to a song page
  void goToSong(BuildContext context, int songIndex, LikeProvider likeProvider) {
    // Update the current song index
    likeProvider.currentSongIndex = songIndex;

    // Navigate to the song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SongPage(),
      ),
    );
  }
}

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<String> data = [];

  @override
  void initState() {
    super.initState();
    // Load initial data
    fetchData();
    // Polling data update every 5 seconds
    Timer.periodic(Duration(seconds: 5), (timer) => fetchData());
  }

  Future<void> fetchData() async {
    var response = await http.get(Uri.parse('http://192.168.50.217/flutter_login/image.php'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(data[index]),
      ),
    );
  }
}


