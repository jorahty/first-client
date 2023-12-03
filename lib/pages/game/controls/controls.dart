import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'desktop/desktop.dart';
import 'mobile/mobile.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.socket});

  final IO.Socket socket;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.android) {
      return MobileControls(socket: socket);
    } else {
      return DesktopControls(socket: socket);
    }
  }
}
