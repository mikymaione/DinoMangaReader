import 'dart:io';

import 'package:dino_manga_reader/commons.dart';
import 'package:flutter/material.dart';

class MangaViewer extends StatefulWidget {
  final String path;

  const MangaViewer({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _MangaViewerState createState() => _MangaViewerState();
}

class _MangaViewerState extends State<MangaViewer> {
  final pageController = PageController();
  List<FileSystemEntity> files = [];
  int curPage = 1;

  @override
  void initState() {
    super.initState();

    files = listFiles();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  List<FileSystemEntity> listFiles() {
    final dir = Directory(widget.path);

    var files = dir.listSync();
    files.sort((a, b) => a.path.compareTo(b.path));

    return files;
  }

  Widget loadImage(String f) {
    try {
      return Image.file(File(f));
    } catch (e) {
      // no image
      return Container();
    }
  }

  double get pctPage => curPage / files.map((e) => e is File ? 1 : 0).reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(Commons.folderNameFromPath(widget.path)),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) => setState(() => curPage = value),
              children: [
                for (final f in files) ...[
                  if (f is File) ...[
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: loadImage(f.path),
                    ),
                  ],
                ],
              ],
            ),
          ),
          LinearProgressIndicator(
            value: pctPage,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
