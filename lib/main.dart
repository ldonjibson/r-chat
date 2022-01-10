import 'dart:convert';
import 'dart:io';
import 'package:chat_ui/shared_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'single_chat_page.dart';
import 'chat_contacts.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'login.dart';
import 'package:platform_device_id/platform_device_id.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getDeviceId() async {
    try {
      dynamic chk = await PlatformDeviceId.getDeviceId;
      await saveStringData("deviceId", chk);
      // print(chk);
    } on PlatformException {
      print('Failed to get deviceId.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getDeviceId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: SplashScreen(
          seconds: 2,
          navigateAfterSeconds: SelectDestination(),
          title: Text(
            'R-Chat!',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color(0xffffffff)),
          ),
          // image: Image(
          //   image: AssetImage('images/logo.png'),
          //   height: 50,
          //   width: 200,
          //   filterQuality: FilterQuality.high,
          // ),
          backgroundColor: Color(0xffab0068),
          styleTextUnderTheLoader: TextStyle(),
          photoSize: 100.0,
          onClick: () => {},
          loadingText: Text(
            'Loading...',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color(0xffffffff)),
          ),
          loaderColor: Colors.white),
    );
  }
}
