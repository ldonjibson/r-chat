import 'dart:io';

import 'package:chat_ui/socket.dart';
import 'package:chat_ui/state_manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'single_chat_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatContactList extends StatefulWidget {
  const ChatContactList({Key? key}) : super(key: key);

  @override
  _ChatContactListState createState() => _ChatContactListState();
}

class _ChatContactListState extends State<ChatContactList>
    with TickerProviderStateMixin {
  late TabController tabController;
  dynamic allGroups = [];

  dynamic chatGroups = [];

  SocketController controller = Get.put(SocketController());

  late IO.Socket socket;

  callSocket() {
    IO.Socket socket = connectSocketToServer();
    if (socket != false) {
      socket.connect();
      socket.onConnect((_) {
        print('$_ connected');
        socket.emit('get_my_rooms', {
          "device_id": "Yellowsedet",
          "user_id": 10,
        });

        socket.emit("get_rooms", {
          "device_id": "Yellowsedet",
          "user_id": 10,
        });
      });

      socket.on("get_my_rooms_Yellowsedet", (data) {
        print("${data} kkkkr");
        setState(() {
          chatGroups = data;
        });
      });

      socket.on("get_rooms_Yellowsedet", (data) {
        print("$data, aajso");
        setState(() {
          allGroups = data;
        });
      });
      return socket;
    }
    // IO.Socket socket = controller.r_socket.value;
    // print(socket.connected);
    // socket.connect();
    // socket.onConnect((data) => {print("connected")});
    // print("chat_contacts");
    // socket.emit('get_my_rooms', {
    //   "device_id": "Yellowsedet",
    //   "user_id": 10,
    // });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    callSocket();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callSocket();
  }

  @override
  void dispose() {
    tabController.dispose();
    callSocket().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
          title: const Text('R-Chat'),
          centerTitle: true,
          backgroundColor: Color(0xffab0068),
          searchBar: true),
      body: GFTabBarView(controller: tabController, children: <Widget>[
        Container(
          color: Color(0xffffffff),
          child: Container(
              child: chatGroups.length != 0
                  ? ListView.builder(
                      itemCount: chatGroups.length != 0 ? chatGroups.length : 0,
                      itemBuilder: (BuildContext context, int position) {
                        dynamic name = chatGroups[position]['name'];
                        return Card(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                            shadowColor: Color(0xffffffff),
                            color: Color(0xffffffff),
                            borderOnForeground: false,
                            semanticContainer: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: InkWell(
                                splashColor: Color(0xffab0068),
                                // borderRadius: BorderRadius.all(Radius.circular(0)),
                                onTap: () {
                                  print("Navigate to the single chat page");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage()));
                                },
                                child: SizedBox(
                                  // width: 300,
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 0, 10, 0)),
                                      Icon(
                                        Icons.supervised_user_circle,
                                        size: 40,
                                      ),
                                      // Image(
                                      //   image: AssetImage(name['image']),
                                      //   height: 100,
                                      //   width: 150,
                                      //   filterQuality: FilterQuality.high,
                                      // ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              child: Text(
                                                (name),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                              "Last chat message",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              // style: TextStyle(),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                      })
                  : Card(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 2),
                      shadowColor: Color(0xffffffff),
                      color: Color(0xffffffff),
                      borderOnForeground: false,
                      semanticContainer: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: InkWell(
                          splashColor: Color(0xffab0068),
                          // borderRadius: BorderRadius.all(Radius.circular(0)),
                          onTap: () {
                            print("Navigate to the single chat page");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage()));
                          },
                          child: SizedBox(
                            // width: 300,
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                                Icon(
                                  Icons.supervised_user_circle,
                                  size: 40,
                                ),
                                // Image(
                                //   image: AssetImage(name['image']),
                                //   height: 100,
                                //   width: 150,
                                //   filterQuality: FilterQuality.high,
                                // ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 0),
                                        child: Text(
                                          ("No group yet"),
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    // Padding(
                                    //   padding:
                                    //       EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    //   child: Text(
                                    //     "Last chat message",
                                    //     textAlign: TextAlign.left,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     // style: TextStyle(),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          )))),
        ),
        Container(
          color: Color(0xffffffff),
          child: Container(
              child: ListView.builder(
                  itemCount: allGroups.length != 0 ? allGroups.length : 0,
                  itemBuilder: (BuildContext context, int position) {
                    dynamic name = allGroups[position];
                    return Card(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        shadowColor: Color(0xffffffff),
                        color: Color(0xffffffff),
                        borderOnForeground: false,
                        semanticContainer: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: InkWell(
                            splashColor: Color(0xffab0068),
                            // borderRadius: BorderRadius.all(Radius.circular(0)),
                            onTap: () {
                              print("Navigate to the single chat page");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatPage()));
                            },
                            child: SizedBox(
                              // width: 300,
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0)),
                                  Icon(
                                    Icons.supervised_user_circle,
                                    size: 40,
                                  ),
                                  // Image(
                                  //   image: AssetImage(name['image']),
                                  //   height: 100,
                                  //   width: 150,
                                  //   filterQuality: FilterQuality.high,
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Text(
                                            (name),
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(
                                          "Last chat message",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          // style: TextStyle(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )));
                  })),
        ),
        Container(color: Colors.blue)
      ]),
      bottomNavigationBar: GFTabBar(
        tabBarColor: Color(0xffab0068),
        indicatorColor: Color(0xffffffff),
        length: 3,
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(Icons.group_outlined),
            child: Text(
              'Groups',
            ),
          ),
          Tab(
            icon: Icon(Icons.group_outlined),
            child: Text(
              'My Groups',
            ),
          ),
          Tab(
            icon: Icon(Icons.archive_sharp),
            child: Text(
              'Archives',
            ),
          ),
        ],
      ),
    );
  }
}
