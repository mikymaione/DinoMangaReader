import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class Commons {
  static String folderNameFromPath(String path) {
    return p.basename(path);
  }

  static Future navigate({required BuildContext context, required WidgetBuilder builder}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }
}
