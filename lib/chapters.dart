import 'dart:io';

import 'package:dino_manga_reader/commons.dart';
import 'package:dino_manga_reader/manga_viewer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chapters extends StatefulWidget {
  final String path;

  const Chapters({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  List<FileSystemEntity> listFolders() {
    final dir = Directory(widget.path);

    var folders = dir.listSync();
    folders.sort((a, b) => a.path.compareTo(b.path));

    return folders;
  }

  Future<List<FileSystemEntity>> listFoldersFuture() {
    return Future.value(listFolders());
  }

  Future<List<String>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('starred') ?? [];
  }

  Future<void> star(String path) async {
    final prefs = await SharedPreferences.getInstance();

    var folders = await loadData();

    if (folders.contains(path)) {
      folders.remove(path);
    } else {
      folders.add(path);
    }

    await prefs.setStringList('starred', folders);

    setState(() {
      // reload page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${Commons.folderNameFromPath(widget.path)} chapters'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: listFoldersFuture(),
        builder: (context, snapshotFolders) => FutureBuilder<List<String>>(
          future: loadData(),
          builder: (context, snapshotStarred) => snapshotFolders.hasData && snapshotStarred.hasData
              ? ListView(
                  children: [
                    for (final f in snapshotFolders.requireData) ...[
                      if (f is Directory) ...[
                        ListTile(
                          title: Text(Commons.folderNameFromPath(f.path)),
                          trailing: IconButton(
                            icon: Icon(snapshotStarred.requireData.contains(f.path) ? Icons.star : Icons.star_border),
                            onPressed: () => star(f.path),
                          ),
                          onTap: () => Commons.navigate(
                            context: context,
                            builder: (context) => MangaViewer(path: f.path),
                          ),
                        ),
                      ],
                    ],
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
