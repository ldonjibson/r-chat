import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;

connectSocketToServer() {
  try {
    IO.Socket socket = IO.io('http://10.0.2.2:1337', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false,
    });
    return socket;
  } catch (e) {
    print(e);
    return false;
  }
}
