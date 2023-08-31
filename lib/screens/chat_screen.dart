import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser; //late is used to defer initialization

class ChatScreen extends StatefulWidget {

  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String ?messageText;

  void getCurrentUser() async {
    try{
  final user = await _auth.currentUser;
  if (user != null) {
    loggedInUser = user;
  }
  } catch (e){
    print(e);
  }
}

  @override
  void initState() {
    super.initState();
    getCurrentUser(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
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

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) { //this napshot is not same as above snapshot(above one was a querySnapshot and this one is flutter's async snapshot that makes use of query snapshot)
                if(snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages) {
                    final messageData = message.data() as Map<String, dynamic>;
                    final messageText = messageData['text'] as String;
                    final messageSender = messageData['sender'] as String;
                    final timestamp = messageData['timestamp'] as Timestamp?;

                     if (timestamp != null) {
                        // Use timestamp
                      } else {
                        // Handle case where timestamp is null
                      }

                    final currentUser = loggedInUser.email;

                    final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      timestamp: timestamp,
                      me: currentUser == messageSender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true, //to scroll to latest message
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageBubbles,
                    ),
                  );
                }
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator(); // Placeholder widget when loading
                }
              },
            );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.me, this.timestamp});

  final String ?sender;
  final String ?text;
  final Timestamp ?timestamp;
  final bool ?me;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: me! ? CrossAxisAlignment.end : CrossAxisAlignment.start, // Adjusted CrossAxisAlignment based on 'me'
        children: [
          Text(
            sender!,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),),
          Material(
            borderRadius: me! ? BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) : BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: me! ? Colors.lightBlueAccent: Color.fromARGB(255, 217, 212, 212) ,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }
}
