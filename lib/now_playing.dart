import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget{
  const NowPlaying({Key? key, required this.songs, required this.audioPlayer, required this.currentSongIndex}) : super(key: key);
  final List<SongModel>? songs;
  final AudioPlayer audioPlayer;
  final int currentSongIndex;
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>{
  int currentSongIndex=0;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  List<SongModel>? songs = [];

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSongIndex = widget.currentSongIndex;
    songs = widget.songs;
    playSong();
    //Play next song when current song ends
    widget.audioPlayer.playerStateStream.listen((event) {
      if(event.processingState == ProcessingState.completed){
        playNextSong();
      }
    });
  }


  void playSong () async {
    try{
      widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(songs![currentSongIndex].uri!)));
      widget.audioPlayer.play();
      isPlaying = true;
    }on Exception{
      log('Error occurred');
    }
    widget.audioPlayer.durationStream.listen((d){
      setState(() {
        duration = d!;
      });
    });

    widget.audioPlayer.positionStream.listen((p){
      setState(() {
        position = p;
      });
    });
  }

  void playPreviousSong(){
      if(currentSongIndex >0){
        setState(() {
          currentSongIndex--;
        });
        playSong();
      }
    }

  void playNextSong(){
      if(currentSongIndex < songs!.length-1){
        setState(() {
          currentSongIndex++;
        });
        playSong();
      }
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SafeArea(
        child: Container(
          width:double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios)
              ),
              const SizedBox(
                height: 30.0,
                ),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      child: Icon(
                        Icons.music_note,
                        size: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      songs![currentSongIndex].displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                   const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      songs![currentSongIndex].artist.toString() == '<unknown>' ? 'Unknown Artist' : songs![currentSongIndex].artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Text(
                          position.toString().split('.').first,
                        ),
                        Expanded(
                          child: Slider(
                            min: 0.0,
                            value: position.inSeconds.toDouble(),
                            max: duration.inSeconds.toDouble(),
                            onChanged: (value){
                            setState(() {
                              changeToSeconds(value.toInt());
                              value = value;
                            });
                          },
                          ),
                        ),
                        Text(
                          duration.toString().split('.').first,
                        ),
                      ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(onPressed: (){
                          playPreviousSong();
                        }, icon: const Icon(Icons.skip_previous, size: 40.0)),
                        IconButton(onPressed: (){
                          if(isPlaying){
                            widget.audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          }else{
                            widget.audioPlayer.play();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        }, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 40.0, color: Colors.orangeAccent,)),
                        IconButton(onPressed: (){
                          playNextSong();
                        }, icon: const Icon(Icons.skip_next, size: 40.0)),
                      ],
                      )
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
  void changeToSeconds(int seconds){
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}