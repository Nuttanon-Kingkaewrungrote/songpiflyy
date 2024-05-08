import 'package:flutter/material.dart';
import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final double imageSize;

  const SongTile({
    Key? key,
    required this.song,
    this.onTap,
    this.imageSize = 100.0, // กำหนดค่าเริ่มต้นของ imageSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.songName),
      subtitle: Text(song.artistName),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(
          width: 70, // กำหนดความกว้างของรูปภาพ
          height: 70, // กำหนดความสูงของรูปภาพ
          child: Image.asset(song.albumArtImagePath, fit: BoxFit.cover),
        ),
      ),
      onTap: onTap,
    );
  }
}