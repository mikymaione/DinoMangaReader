/*
MIT License

Copyright (c) 2022 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import 'package:flutter/material.dart';

enum TypeOfMsg { ok, info, error }

class Msg {
  static void showOk(BuildContext context, String text) {
    show(context, text, TypeOfMsg.ok);
  }

  static void showInfo(BuildContext context, String text) {
    show(context, text, TypeOfMsg.info);
  }

  static void showError(BuildContext context, String text) {
    show(context, text, TypeOfMsg.error);
  }

  static Color _colorByTypeOfMsg(TypeOfMsg typeOfMsg) {
    switch (typeOfMsg) {
      case TypeOfMsg.ok:
        return const Color(0XFF16F28B);
      case TypeOfMsg.info:
        return const Color(0XFF2493FB);
      case TypeOfMsg.error:
        return const Color(0XFFFF4D4F);
    }
  }

  static void show(BuildContext context, String text, TypeOfMsg typeOfMsg) {
    final snackBar = SnackBar(
      backgroundColor: _colorByTypeOfMsg(typeOfMsg),
      content: Row(
        children: [
          if (typeOfMsg == TypeOfMsg.ok) ...[
            const Icon(Icons.done, color: Colors.white),
          ] else if (typeOfMsg == TypeOfMsg.info) ...[
            const Icon(Icons.info_outline, color: Colors.white),
          ] else if (typeOfMsg == TypeOfMsg.error) ...[
            const Icon(Icons.dangerous, color: Colors.white),
          ],
          const SizedBox(width: 20),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
