/*
MIT License

Copyright (c) 2022 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import 'dart:io';

import 'package:dino_manga_reader/commons.dart';
import 'package:dino_manga_reader/manga_viewer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chapter extends StatefulWidget {
  final String path;
  final bool? starred;

  const Chapter({
    Key? key,
    required this.path,
    required this.starred,
  }) : super(key: key);

  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  final scrollController = ScrollController();
  List<FileSystemEntity> folders = [];

  @override
  void initState() {
    super.initState();

    folders = listFolders();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<FileSystemEntity> listFolders() {
    final dir = Directory(widget.path);

    var folders = dir.listSync();
    folders.sort((a, b) => a.path.compareTo(b.path));

    return folders;
  }

  Future<List<String>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('starred') ?? [];
  }

  Future<void> star(String path, {bool? setValue}) async {
    final prefs = await SharedPreferences.getInstance();

    var folders = await loadData();

    if (setValue == null) {
      if (folders.contains(path)) {
        folders.remove(path);
      } else {
        folders.add(path);
      }
    } else {
      if (setValue) {
        if (!folders.contains(path)) folders.add(path);
      } else {
        if (folders.contains(path)) folders.remove(path);
      }
    }

    await prefs.setStringList('starred', folders);

    setState(() {
      // reload page
    });
  }

  bool filterData(List<String>? starred, Directory f) {
    if (starred == null) {
      return false;
    } else {
      switch (widget.starred) {
        case true:
          return starred.contains(f.path);

        case false:
          return !starred.contains(f.path);

        default:
          return true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: loadData(),
      builder: (context, snapshotStarred) => Scrollbar(
        controller: scrollController,
        isAlwaysShown: true,
        child: ListView(
          controller: scrollController,
          children: [
            for (final f in folders) ...[
              if (f is Directory && filterData(snapshotStarred.data, f)) ...[
                ListTile(
                  title: Text(Commons.folderNameFromPath(f.path)),
                  trailing: IconButton(
                    icon: Icon((snapshotStarred.data?.contains(f.path) ?? false) ? Icons.star : Icons.star_border),
                    onPressed: () => star(f.path),
                  ),
                  onTap: () async {
                    await Commons.navigate(
                      context: context,
                      builder: (context) => MangaViewer(path: f.path),
                    );

                    star(f.path, setValue: true);
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
