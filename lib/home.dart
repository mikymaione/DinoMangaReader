import 'dart:io';

import 'package:dino_manga_reader/chapters.dart';
import 'package:dino_manga_reader/commons.dart';
import 'package:dino_manga_reader/msg.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? mangaFolder() {
    final root = Directory(FolderPicker.ROOTPATH);

    for (final d in root.listSync()) {
      if ('Manga' == Commons.folderNameFromPath(d.path)) {
        return d.path;
      }
    }

    return null;
  }

  List<FileSystemEntity> listFolders(BuildContext context) {
    final _mangaFolder = mangaFolder();

    if (_mangaFolder == null) {
      Msg.showError(context, 'No Manga folder founded');
      return List<FileSystemEntity>.empty();
    } else {
      final dir = Directory(_mangaFolder);

      var folders = dir.listSync();
      folders.sort((a, b) => a.path.compareTo(b.path));

      return folders;
    }
  }

  Future<List<FileSystemEntity>> listFoldersFuture(BuildContext context) {
    return Future.value(listFolders(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dr. Dino Manga Reader'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: listFoldersFuture(context),
        builder: (context, snapshot) => snapshot.hasData
            ? ListView(
                children: [
                  for (final f in snapshot.requireData) ...[
                    ListTile(
                      title: Text(Commons.folderNameFromPath(f.path)),
                      onTap: () => Commons.navigate(
                        context: context,
                        builder: (context) => Chapters(path: f.path),
                      ),
                    ),
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
