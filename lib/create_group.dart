import 'dart:async';
import 'dart:io';

import 'package:chat_ui/socket.dart';
import 'package:chat_ui/state_manage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chat_contacts.dart';

class CreateChatGroup extends StatefulWidget {
  const CreateChatGroup({Key? key}) : super(key: key);

  @override
  _CreateChatGroupState createState() => _CreateChatGroupState();
}

class _CreateChatGroupState extends State<CreateChatGroup> {
  final _formKey = GlobalKey<FormBuilderState>();
  dynamic submitValues;
  bool loading = false;

  SocketController controller = Get.put(SocketController());
  void _onChanged() {
    // print(""rR);
  }

  onSubmit() {
    try {
      IO.Socket socket = connectSocketToServer();
      print(socket);
      if (socket != false) {
        socket.connect();
        controller.r_socket.value = socket;
        controller.update();
        socket.onConnect((_) {
          print('$_ connected');
          print(submitValues);
          //user_id from preference storage
          dynamic user_id = 10;
          socket.emit('create_group', {
            "group_name": submitValues["group_name"],
            "group_password": submitValues["group_password"],
            "no_of_participants": submitValues["no_of_participants"],
            "group_general_key": submitValues["group_general_key"],
            "owner_id": user_id,
          });
        });

        socket.on("create_group", (data) {
          print(data);
          if (data.containsKey('name')) {
            controller.group_created.value = true;
            controller.update();
            controller.r_socket.value = socket;
            controller.update();
            _formKey.currentState?.reset();
            // setState(() {});
          }
        });
      }
      // socket.on('typing', (data) => print("$data typing"));
      // socket.onDisconnect((_) => print('disconnect'));
      // socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e);
    }
  }

  FutureOr onGoBack() {
    setState(() {});
  }

  @override
  void dispose() {
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var genderOptions = [];
    return Obx(() => (Scaffold(
          appBar: GFAppBar(
            title: Text("Create Group"),
            backgroundColor: Color(0xffab0068),
            leading: GFIconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              type: GFButtonType.transparent,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      FormBuilder(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: <Widget>[
                            FormBuilderTextField(
                              name: 'group_name',
                              strutStyle: StrutStyle(height: 2),
                              decoration: InputDecoration(
                                labelText: 'Group Name',
                                labelStyle: TextStyle(color: Color(0xffab0068)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffab0068))),
                              ),
                              onChanged: (value) => {_onChanged()},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                              keyboardType: TextInputType.name,
                            ),
                            FormBuilderTextField(
                              name: 'group_password',
                              strutStyle: StrutStyle(height: 2),
                              decoration: InputDecoration(
                                  labelText: 'Group Password',
                                  labelStyle:
                                      TextStyle(color: Color(0xffab0068)),
                                  focusColor: Color(0xffab0068),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffab0068)))),
                              obscureText: true,
                              obscuringCharacter: "#",
                              onChanged: (value) => {_onChanged()},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.minLength(context, 6),
                              ]),
                              keyboardType: TextInputType.name,
                            ),
                            FormBuilderTextField(
                              name: 'no_of_participants',
                              strutStyle: StrutStyle(height: 2),
                              decoration: InputDecoration(
                                labelText: 'No of Participants',
                                labelStyle: TextStyle(color: Color(0xffab0068)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffab0068))),
                              ),
                              onChanged: (value) => {_onChanged()},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.numeric(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                              keyboardType: TextInputType.number,
                            ),
                            FormBuilderTextField(
                              name: 'group_general_key',
                              strutStyle: StrutStyle(height: 2),
                              decoration: InputDecoration(
                                labelText: 'Group Key',
                                labelStyle: TextStyle(color: Color(0xffab0068)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffab0068))),
                              ),
                              onChanged: (value) => {_onChanged()},
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.max(context, 70),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: !controller.group_created.value
                                  ? MaterialButton(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: Color(0xffab0068),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _formKey.currentState?.save();
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            submitValues =
                                                _formKey.currentState?.value;
                                          });
                                          onSubmit();
                                        } else {
                                          controller.group_created.value =
                                              false;
                                          controller.update();
                                        }
                                      },
                                    )
                                  : GFAlert(
                                      title: 'Great!',
                                      alignment: Alignment.bottomCenter,
                                      content: 'A Group has just been created',
                                      bottombar: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GFButton(
                                              color: Color(0xffab0068),
                                              onPressed: () {
                                                controller.group_created.value =
                                                    false;
                                                controller.update();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatContactList()));
                                              },
                                              shape: GFButtonShape.pills,
                                              child: Text('Proceed',
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xffffffff)))),
                                          SizedBox(width: 5),
                                          GFButton(
                                            color: Color(0xffab0068),
                                            onPressed: () {
                                              controller.group_created.value =
                                                  false;
                                              controller.update();
                                            },
                                            shape: GFButtonShape.pills,
                                            icon: Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color(0xffffffff)),
                                            position: GFPosition.end,
                                            text: 'Cancel',
                                          )
                                        ],
                                      ),
                                    )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
