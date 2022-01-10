import 'dart:convert';
import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'chat_contacts.dart';
import 'create_group.dart';

class SelectDestination extends StatefulWidget {
  const SelectDestination({Key? key}) : super(key: key);

  @override
  _SelectDestinationState createState() => _SelectDestinationState();
}

class _SelectDestinationState extends State<SelectDestination> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: Color(0xffab0068),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: GFButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateChatGroup()));
                      },
                      text: "Create a Group",
                      textColor: Color(0xffab0068),
                      textStyle: TextStyle(
                          color: Color(0xffab0068),
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                      color: Color(0xffffffff),
                      icon: Icon(
                        Icons.group_add_sharp,
                        color: Color(0xffab0068),
                      ),
                      size: 50,
                      elevation: 2.0,
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: GFButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatContactList()))
                      },
                      text: "Continue to Chat",
                      textColor: Color(0xffab0068),
                      textStyle: TextStyle(
                          color: Color(0xffab0068),
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                      color: Color(0xffffffff),
                      icon: Icon(
                        Icons.chat_bubble_sharp,
                        color: Color(0xffab0068),
                      ),
                      size: 50,
                      elevation: 2.0,
                      padding: EdgeInsets.fromLTRB(23, 0, 23, 0),
                    ),
                  ),
                ],
              ),
            )));
  }
}
