import 'dart:convert';
import 'dart:io';
import 'package:chat_ui/state_manage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:getwidget/getwidget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
      id: '06c33e8b-e835-4736-80f4-63f44b66666c',
      firstName: "Jane",
      imageUrl: 'https://avatars.githubusercontent.com/u/33809426?v=4');

  dynamic socket;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    setState(() {
      socket = connectSocketToServer();
    });
  }

  newMessage(data) {
    List<types.Message> msg;
    print(data);
    msg = ((data) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();
    print(msg);
    _addMessage(msg[0]);
  }

  connectSocketToServer() {
    try {
      IO.Socket socket =
          IO.io('https://fluttsocket.herokuapp.com/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();

      setState(() {
        socket = socket;
      });

      print(socket.id);
      socket.onConnect((_) {
        print('connected');
        socket.emit('/test', {
          "recipient_id": "1",
          "sender_id": "77",
          "text": "this is just what we have \n jsjfa",
          "token": "from client"
        });
      });
      socket.on('jest', (data) {
        print("${data[0]['author']} | ${data[0]['id']} | ${data[0]['text']}");
        final _user = types.User(
            id: data[0]['id'],
            firstName: data[0]['author']['firstName'],
            imageUrl: 'https://avatars.githubusercontent.com/u/14123304?v=4');

        if (data[0]['type'] == "text") {
          //this works for text messages adding
          final textMessage = types.TextMessage(
            author: _user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: data[0]['text'],
          );
          _addMessage(textMessage);
        }
      });
      socket.on('typing', (data) => print("$data typing"));
      socket.onDisconnect((_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
      return socket;
    } catch (e) {
      print(e);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    socket.emit("/test", {
      "author": _user,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "id": const Uuid().v4(),
      "text": message.text
    });
    print("$textMessage mehn");
    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  //bubble style widget, USES Bubble Package
  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) {
    return Bubble(
      nipHeight: 10.0,
      padding: BubbleEdges.all(5),
      // style: BubbleStyle(padding: BubbleEdges.all(5), margin: BubbleEdges.all(1)),
      child: child,
      color: _user.id != message.author.id ||
              message.type == types.MessageType.image
          ? const Color(0xffff6c02)
          : const Color(0xffab0068),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : _user.id != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          appBar: GFAppBar(
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
              title: const Text('R-Chat - John'),
              centerTitle: true,
              backgroundColor: Color(0xffab0068),
              searchBar: true),
          body: SafeArea(
            bottom: false,
            child: Chat(
                messages: _messages,
                onAttachmentPressed: _handleAtachmentPressed,
                onMessageTap: _handleMessageTap,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: _handleSendPressed,
                user: _user,
                hideBackgroundOnEmojiMessages: true,
                showUserAvatars: true,
                showUserNames: true,
                sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                bubbleBuilder: _bubbleBuilder,
                theme: const DefaultChatTheme(
                    inputBackgroundColor: Color(0xffe00702),
                    //changes the file attache icon
                    attachmentButtonIcon: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                    inputBorderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20), bottom: Radius.circular(20)),
                    inputPadding: EdgeInsets.all(5)),
                l10n: const ChatL10nEn(
                  inputPlaceholder: 'Enter Text',
                )),
          ),
        )));
  }
}
