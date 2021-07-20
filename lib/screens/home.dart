import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_tryout/data.dart';
import 'package:flutter_youtube_tryout/widgets/custom_sliver_app_bar.dart';
import 'package:flutter_youtube_tryout/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController _addItemController = TextEditingController();
  late DocumentReference linkRef;
  List<String> videoID = [];
  bool showItem = false;
  final radd =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        CustomSliverAppBar(),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 60.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final video = videos[index];
                return VideoCard(video: video);
              },
              childCount: videos.length,
            ),
          ),
        ),
      ],
    ));
  }
}
