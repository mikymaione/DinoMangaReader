import 'dart:io';

import 'package:dino_manga_reader/commons.dart';
import 'package:flutter/material.dart';

class MangaViewer extends StatelessWidget {
  final String path;

  const MangaViewer({
    Key? key,
    required this.path,
  }) : super(key: key);

  List<FileSystemEntity> listFiles() {
    final dir = Directory(path);

    var files = dir.listSync();
    files.sort((a, b) => a.path.compareTo(b.path));

    return files;
  }

  Future<List<FileSystemEntity>> listFilesFuture() {
    return Future.value(listFiles());
  }

  Widget loadImage(String f) {
    try {
      return Image.file(File(f));
    } catch (e) {
      // no image
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(Commons.folderNameFromPath(path)),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: listFilesFuture(),
        builder: (context, snapshot) => snapshot.hasData
            ? ListView(
                children: [
                  for (final f in snapshot.requireData) ...[
                    if (f is File) ...[
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: loadImage(f.path),
                      ),
                    ],
                  ],
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
