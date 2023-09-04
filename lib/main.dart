import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:external_path/external_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const homePage(),
    );
  }
}


class homePage extends StatefulWidget {
  const homePage({super.key});
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  VideoPlayerController? videoPlayerController;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
               //  download and convert into bytes
               final videoBytes=await downloadVideo();
               if(videoBytes!=null){
                 print("VideoBytes type : ${videoBytes}");
                 String videoPath=await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                 print("videoPath : ${videoPath}");

                 final imgName = "video3.mp4";

                 Directory directory=Directory(videoPath);
                 File f = File('${directory.path}/${imgName}');
                 f.createSync();
                 f.writeAsBytesSync(videoBytes);
                 print("${f}");
                 setState(() {

                 });
                 // create and add video int path

                 // File videofile = File(directory);
                 // videofile.writeAsBytesSync(videoBytes);

                 // videoPlayerController=VideoPlayerController.file(videofile);
                 // videoPlayerController!.initialize();
                 // print("initialized? ${videoPlayerController!.value.isInitialized}");
                 // videoPlayerController!.play();
               } else {
                 print("video not loaded");
               }
               setState(() {});
              },
              icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: videoPlayerController !=null?
        AspectRatio(
          aspectRatio: videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(videoPlayerController!),
        ) : Text("video not selected"),
      )
    );
  }
}

Future<Uint8List?> downloadVideo() async {
  Uri videoUrl=Uri.parse("https://youtu.be/4bEAAQZn9Hs");
  try{
    Response response=await http.get(videoUrl);
    if(response.statusCode==200){
      final Uint8List videoBytes=Uint8List.fromList(response.bodyBytes);
      print("VideoBytes type : ${videoBytes.runtimeType}");
      return videoBytes;
    } else {
      return null;
    }
  } catch(e){
    print("download videoError : $e");
    return null;
  }
}




