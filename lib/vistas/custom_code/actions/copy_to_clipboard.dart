// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '../../flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';

// ignore_for_file: prefer_const_constructors
copyToClipboard(BuildContext context, url) async {
  await Clipboard.setData(ClipboardData(text: url)).then((_) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copiado al portapapeles')));
  });
}
