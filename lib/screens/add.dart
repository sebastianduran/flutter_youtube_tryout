import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AddScreen extends StatefulWidget {
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController _addItemController = TextEditingController();

  late DocumentReference linkRef;

  List<String> videoID = [];

  bool showItem = false;

  final c = RegExp(r"^(https:?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Divider(),
          Container(
            child: TextField(
              controller: _addItemController,
              onEditingComplete: () {
                if (c.hasMatch(_addItemController.text)) {
                  _addItemFunction();
                } else {
                  //FocusScope.of(this.context).unfocus();
                  Flushbar(
                      title: 'Link invalido',
                      message: 'Ingresar un link valido',
                      duration: Duration(seconds: 3),
                      icon: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ))
                    ..show(context);
                }
              },
              style: TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                  labelText: 'Your video URL',
                  suffixIcon: GestureDetector(
                      child: Icon(Icons.add, size: 32),
                      onTap: () {
                        if (c.hasMatch(_addItemController.text))
                          _addItemFunction();
                      })),
            ),
          ),
          Flexible(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: showItem
                ? ListView.builder(
                    itemCount: videoID.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(8),
                      child: YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId:
                              YoutubePlayer.convertUrlToId(videoID[index]),
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blue,
                        progressColors: ProgressBarColors(
                            playedColor: Colors.blue,
                            handleColor: Colors.blueAccent),
                      ),
                    ),
                  )
                : CircularProgressIndicator(),
          ))
        ],
      ),
    );
  }

  void initState() {
    linkRef = FirebaseFirestore.instance.collection('links').doc('url');
    super.initState();
    getData();
  }

  _addItemFunction() async {
    await linkRef.set({
      _addItemController.text.toString(): _addItemController.text.toString()
    }, SetOptions(merge: true));
    Flushbar(
      title: 'Added',
      message: 'updating...',
      duration: Duration(seconds: 3),
      icon: Icon(Icons.info_outline),
    )..show(context);
    setState(() {
      videoID.add(_addItemController.text);
    });
    print('added');
    FocusScope.of(this.context).unfocus();
    _addItemController.clear();
  }

  getData() async {
    await linkRef
        .get()
        .then((value) => value.data()?.forEach((key, value) {
              if (!videoID.contains(value)) {
                videoID.add(value);
              }
            }))
        .whenComplete(() => setState(() {
              videoID.shuffle();
              showItem = true;
            }));
  }
}
