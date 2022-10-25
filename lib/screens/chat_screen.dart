import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flash_chat_project/constants.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  String messageText;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
                stream: _firestore
                    .collection('messages')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (Context, snapshot) {
                  List<textBubble> list = [];
                  var documents = snapshot.data.docs.reversed;
                  for (var data in documents) {
                    String senderMassage = data.data()['sender'];
                    String textMassage = data.data()['text'];
                    final messageTime = data.data()['time'] as Timestamp;
                    final loggedInUser = _auth.currentUser;
                    final textwidget = textBubble(
                        textMassage: textMassage,
                        senderMassage: senderMassage,
                        isMe: loggedInUser.email == senderMassage,
                        time: messageTime);
                    list.add(textwidget);
                  }

                  return Flexible(
                    child: ListView(
                      reverse: true,
                      children: list,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: textEditingController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textEditingController.clear();
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textBubble extends StatelessWidget {
  textBubble({
    @required this.textMassage,
    @required this.senderMassage,
    @required this.time,
    @required this.isMe,
  });
  final Timestamp time;
  final String textMassage;
  final String senderMassage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    Color backGroundcolor;
    CrossAxisAlignment location;
    if (isMe) {
      backGroundcolor = Colors.blueAccent;
      location = CrossAxisAlignment.end;
    } else {
      backGroundcolor = Colors.greenAccent;
      location = CrossAxisAlignment.start;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: location,
      children: [
        Text(
          '${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000).month}-${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000).day} ${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000).hour}:${DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000).minute}', // add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thing
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
        Text(
          senderMassage,
          style: TextStyle(color: Colors.black38),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Material(
            elevation: 20.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15)),
            color: backGroundcolor,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                textMassage,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
