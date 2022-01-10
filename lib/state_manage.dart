// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// import 'package:get/get_state_manager/get_state_manager.dart';
import 'dart:io';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/state_manager.dart';

class SocketController extends GetxController {
  Rx<IO.Socket> r_socket = IO.io('http://localhost:1337', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  }).obs;

  RxBool group_created = false.obs;

  connectSocketToServer() {
    try {
      IO.Socket socket = IO.io('http://localhost:1337', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
      r_socket.value = socket.connect();
      r_socket.value.onConnect((_) {
        print("connected");
      });
      update();
    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    connectSocketToServer();

    //Change value to name2
  }

  @override
  void onReady() {
    super.onReady();
    connectSocketToServer();
  }

  @override
  void onClose() {
    // Here, you can dispose your StreamControllers
    // you can cancel timers
    connectSocketToServer().dispose();
    super.onClose();
  }
}
