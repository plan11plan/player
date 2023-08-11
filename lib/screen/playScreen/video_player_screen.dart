import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/file_model.dart';
import '../../widgets/seekbar.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final int currentIndex;

  const VideoPlayerScreen(
      {Key? key, required this.mediaFiles, required this.currentIndex})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayer;
  int currentSongIndex = 0;

  @override
  void initState() {
    super.initState();

    // 현재 재생할 미디어 파일의 인덱스를 설정합니다.
    currentSongIndex = widget.currentIndex;

    // 선택된 미디어 파일로 비디오 플레이어를 초기화합니다.
    _initializeVideoPlayer(widget.mediaFiles[currentSongIndex].filePath);

    // Add a listener to the videoPlayer
    videoPlayer.addListener(() {
      // Rebuild the widget whenever the videoPlayer's state changes
      setState(() {});
    });
  }

  _initializeVideoPlayer(String path) {
    videoPlayer = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        videoPlayer.play();
      });

    // 현재 재생 중인 미디어 파일의 인덱스를 업데이트합니다.
    // Note: videoPlayer에는 currentIndexStream이 없습니다.
    // 이 기능은 audioPlayer에서만 제공됩니다. 따라서 이 코드는 제거해야 합니다.
  }

  void onPrevious() {
    if (currentSongIndex > 0) {
      setState(() {
        currentSongIndex--;
        videoPlayer.pause();
        videoPlayer.seekTo(Duration.zero);
        _initializeVideoPlayer(widget.mediaFiles[currentSongIndex].filePath);
      });
    }
  }

  void onNext() {
    if (currentSongIndex < widget.mediaFiles.length - 1) {
      setState(() {
        currentSongIndex++;
        videoPlayer.pause();
        videoPlayer.seekTo(Duration.zero);
        _initializeVideoPlayer(widget.mediaFiles[currentSongIndex].filePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Now Playing', style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Check if the video player is initialized
                videoPlayer.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: videoPlayer.value.aspectRatio,
                  child: VideoPlayer(videoPlayer),
                )
                    : CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  widget.mediaFiles[currentSongIndex].title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  widget.mediaFiles[currentSongIndex].description,
                  style: TextStyle(color: Colors.grey[400], fontSize: 18),
                ),
              ],
            ),
          ),
          if (videoPlayer.value.isInitialized)
            SeekBar(
              position: videoPlayer.value.position,
              duration: videoPlayer.value.duration,
              onChanged: (position) {
                videoPlayer.seekTo(position);
              },
              onChangeEnd: (position) {
                // If you want to perform any additional actions after the user finishes seeking
              },
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 40,
                onPressed: onPrevious,
              ),
              IconButton(
                icon: Icon(videoPlayer.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                color: Colors.white,
                iconSize: 60,
                onPressed: () {
                  setState(() {
                    if (videoPlayer.value.isPlaying) {
                      videoPlayer.pause();
                    } else {
                      videoPlayer.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                iconSize: 40,
                onPressed: onNext,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }




  @override
  void dispose() {
    super.dispose();
    videoPlayer.dispose();
  }
}