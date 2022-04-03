/*
MIT License

Copyright (c) 2022 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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
