import 'dart:developer';
import 'package:cyclease/now_playing.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPlayer extends StatefulWidget {
  const MediaPlayer({Key? key}) : super(key: key);


  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  Future<List<SongModel>>? _songsFuture;
  final AudioPlayer audioPlayer = AudioPlayer();
  playSong(String? uri) async {
    try{
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
    }on Exception{
      log('Error occurred');
    }
  }


  @override
  void initState() {
    super.initState();
    _requestPermissionAndQuerySongs();
  }

Future<void> _requestPermissionAndQuerySongs() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  if (await Permission.storage.isPermanentlyDenied) {
  // The user selected "Don't ask again". Open the app settings.
  openAppSettings();
  }
  if (status.isGranted) {
    _songsFuture = audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    ).then((songs)=> songs.where((song) => !song.data.contains('/WhatsApp/')).toList());
    setState(() {});
  } else {
    // Handle the case where the user denied the permission request.
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => {}
              )
        ]
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _songsFuture,
        builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
    if (snapshot.data != null) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(snapshot.data![index].title),
            subtitle: Text(snapshot.data![index].artist ?? 'Unknown'),
            trailing: const Icon(Icons.more_horiz),
            leading:  const CircleAvatar(
              child: Icon(Icons.music_note),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NowPlaying(currentSongIndex: index, audioPlayer: audioPlayer, songs: snapshot.data,)));
            },
          );
        },
      );
    } else {
      return const Center(
        child: Text('No data available'),
      );
    }
  }
  return const Center(
    child: CircularProgressIndicator(),
  );
},
      ),
    );
  }
}