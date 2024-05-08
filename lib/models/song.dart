import 'package:flutter/material.dart';





class Song {
  final String songName;
  final String artistName;
  final String albumArtImagePath;
  final String audioPath;
  // final bool favourite;

  Song({
    required this.songName,
    required this.artistName,
    required this.albumArtImagePath,
    required this.audioPath,
    // required this.favourite,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songName: json['songName'],
      artistName: json['artistName'],
      albumArtImagePath: json['albumArtImagePath'],
      audioPath: json['audioPath'],
      // favourite: json['list'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'songName': songName,
      'artistName': artistName,
      'albumArtImagePath': albumArtImagePath,
      'audioPath': audioPath,
    };
  }
}

class SongProvider extends ChangeNotifier {
  List<Song> _likedSongs = [];

  List<Song> get likedSongs => _likedSongs;

  void addLikedSong(Song songData) {
    _likedSongs.add(songData);
    notifyListeners();
  }

  void removeLikedSongData(Song songData) {
    _likedSongs.remove(songData);
    notifyListeners();
  }
}
