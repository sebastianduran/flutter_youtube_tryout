import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_tryout/data.dart';
import 'package:flutter_youtube_tryout/screens/add.dart';
import 'package:flutter_youtube_tryout/screens/video.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:flutter_youtube_tryout/screens/home.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;

  int _selectIndex = 0;

  final _screens = [
    HomeScreen(),
    const Scaffold(body: Center(child: Text('Explore'))),
    AddScreen(),
    const Scaffold(body: Center(child: Text('Subscriptions'))),
    const Scaffold(body: Center(child: Text('Library'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniPlayerController =
              watch(miniPlayerControllerProvider).state;
          print(selectedVideo);
          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                    i, Offstage(offstage: _selectIndex != i, child: screen)))
                .values
                .toList()
                  ..add(Offstage(
                    offstage: selectedVideo == null,
                    child: Miniplayer(
                        controller: miniPlayerController,
                        minHeight: _playerMinHeight,
                        maxHeight: MediaQuery.of(context).size.height,
                        builder: (height, percentage) {
                          if (selectedVideo == null)
                            return const SizedBox.shrink();

                          if (height <= _playerMinHeight + 50.0)
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.network(selectedVideo.thumbnailUrl,
                                          height: _playerMinHeight - 4.0,
                                          width: 120.0,
                                          fit: BoxFit.cover),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                selectedVideo.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              )),
                                              Flexible(
                                                child: Text(
                                                  selectedVideo.author.username,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.play_arrow),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read(selectedVideoProvider)
                                              .state = null;
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const LinearProgressIndicator(
                                    value: 0.4,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.red),
                                  ),
                                ],
                              ),
                            );
                          return VideoScreen();
                        }),
                  )),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectIndex,
        onTap: (i) => setState(() => _selectIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined),
              activeIcon: Icon(Icons.subscriptions),
              label: "Subscriptions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              activeIcon: Icon(Icons.video_library),
              label: "Library")
        ],
      ),
    );
  }
}
