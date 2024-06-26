import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'song.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
    
    
    


    List<Song> _playlist = [];
    Future<List<dynamic>>  fetchSongs() async {
    // var url = "http://192.168.50.217/flutter_login/image.php";
    var url = "https://songpifly.phusingdev.com/image.php";
    final response = await http.post(Uri.parse(url));

    // Decode the response and map it to list of Song objects
    List<dynamic> songsData = json.decode(response.body);
      _playlist = songsData.map((data) => Song(
      songName: data['name'],
      artistName: data['artist'],
      albumArtImagePath:'assets/images/'+data['image'],
      audioPath: 'audio/'+data['audio'] ,
      // favourite: data['list']
          )).toList();
     // Notify listeners about the change in playlist
    notifyListeners();

    return _playlist;
  }
  
    
  
  
  

  // current song playing index
  int? _currentSongIndex;

  /*

  A U D I O P L A Y E R

  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    fetchSongs();
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // Play a song
  void play() async {
    if (_currentSongIndex == null) return; // Or handle it differently

    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // Stop the current song
    await _audioPlayer.play(AssetSource(path)); // Play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // Pause the current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or Resume
  void pauseOrResume() async {
    if (isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // Seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // Go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // If it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    if (_currentSongIndex == null || _playlist.isEmpty) return;

    if (_currentDuration.inSeconds > 2) {
      // If more than 2 seconds have passed, restart the current song
      seek(Duration.zero);
    } else {
      // If it's within the first 2 seconds, go to the previous song
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // If it's the first song, loop back to the last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // Dispose audio player when provider is disposed
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /*

  G E T T E R S

  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*

  S E T T E R S

  */

  // Updated setter for currentSongIndex to include play functionality
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play(); // Play the song at the new index
    }
    notifyListeners();
  }
}
