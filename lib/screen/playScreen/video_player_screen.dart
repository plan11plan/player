import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../models/file_model.dart';

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
  VideoPlayerController? videoPlayer;
  int currentSongIndex = 0;
  bool showControls = false;
  bool isFullscreen = false;

  @override
  void initState() {
    super.initState();
    currentSongIndex = widget.currentIndex;
    _initializeVideoPlayer(widget.mediaFiles[currentSongIndex].filePath);


  }
  void _toggleFullscreen() {
    if (isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    setState(() {
      isFullscreen = !isFullscreen;
    });
  }


  _initializeVideoPlayer(String path) async {
    videoPlayer?.dispose();

    videoPlayer = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {});
        videoPlayer?.play();
      });

    videoPlayer?.addListener(_updateSlider);
  }

  void _updateSlider() {
    setState(() {});
  }

  void onPrevious() {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      _changeVideo();
    }
  }

  void onNext() {
    if (currentSongIndex < widget.mediaFiles.length - 1) {
      currentSongIndex++;
      _changeVideo();
    }
  }

  _changeVideo() {
    videoPlayer?.pause();
    _initializeVideoPlayer(widget.mediaFiles[currentSongIndex].filePath);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: isLandscape && showControls
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${widget.mediaFiles[currentSongIndex].title}', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
            onPressed: _toggleFullscreen,
          ),
        ],
      )



          : null,
      backgroundColor: Colors.black,
      body: isLandscape
          ? GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: videoPlayer!.value.aspectRatio,
                child: VideoPlayer(videoPlayer!),
              ),
            ),
            if (showControls)
              Positioned(
                bottom: 50,
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2.0,
                        thumbShape:
                        RoundSliderThumbShape(enabledThumbRadius: 5.0,),
                        thumbColor: Colors.white,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey[800],
                      ),
                      child: Slider(
                        value: videoPlayer!.value.position.inSeconds.toDouble(),
                        onChanged: (value) {
                          final position = Duration(seconds: value.toInt());
                          videoPlayer?.seekTo(position);
                          setState(() {});
                        },
                        min: 0,
                        max: videoPlayer!.value.duration.inSeconds.toDouble(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _formatDuration(videoPlayer!.value.position),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(videoPlayer!.value.duration),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (showControls)
              Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 40,
                      onPressed: onPrevious,
                    ),
                    IconButton(
                      icon: Icon(videoPlayer?.value.isPlaying ?? false
                          ? Icons.pause
                          : Icons.play_arrow),
                      color: Colors.white,
                      iconSize: 60,
                      onPressed: () {
                        setState(() {
                          if (videoPlayer!.value.isPlaying) {
                            videoPlayer!.pause();
                          } else {
                            videoPlayer!.play();
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
              ),
          ],
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('${widget.mediaFiles[currentSongIndex].title}', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
                onPressed: _toggleFullscreen,
              ),
            ],
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                videoPlayer!.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: videoPlayer!.value.aspectRatio,
                  child: VideoPlayer(videoPlayer!),
                )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          if (videoPlayer!.value.isInitialized)
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: 5.0),
                    activeTrackColor: Colors.white,
                    thumbColor: Colors.white,

                    inactiveTrackColor: Colors.grey[800],
                  ),
                  child: Slider(
                    value: videoPlayer!.value.position.inSeconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(seconds: value.toInt());
                      videoPlayer?.seekTo(position);
                      setState(() {});
                    },
                    min: 0,
                    max: videoPlayer!.value.duration.inSeconds.toDouble(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _formatDuration(videoPlayer!.value.position),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _formatDuration(videoPlayer!.value.duration),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
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
                icon: Icon(videoPlayer?.value.isPlaying ?? false
                    ? Icons.pause
                    : Icons.play_arrow),
                color: Colors.white,
                iconSize: 60,
                onPressed: () {
                  setState(() {
                    if (videoPlayer!.value.isPlaying) {
                      videoPlayer!.pause();
                    } else {
                      videoPlayer!.play();
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    videoPlayer?.dispose();
  }

}
