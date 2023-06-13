import 'package:chat_application/screens/HomeScreen.dart';
import 'package:chat_application/user_data_model/Messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_data_bloc/user_data_bloc.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatelessWidget {
  ChatScreen(this.uniqueid, this.sender, this.reciever, {super.key});
  String uniqueid;
  String sender;
  String message = "";
  String reciever;
  final messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(''),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffffe1e1),
                Color(0xffff9d9d),
                Color(0xffff9d9d),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Messages(
            sendermail: sender,
            recievermail: reciever,
            id: uniqueid,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextField(
                    controller: messageTextController,
                    onChanged: (value) {
                      message = value;
                    },
                  )),
              TextButton(
                  onPressed: () async {
                    messageTextController.clear();
                    context.read<UserDataBloc>().add(SendMessageEvent(
                        sender: loggedInUser!.email ?? '',
                        message: message,
                        id: uniqueid));
                  },
                  child: const Text(
                    'send',
                    style: TextStyle(color: Colors.pinkAccent),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  const Messages(
      {required this.sendermail,
      required this.recievermail,
      required this.id,
      super.key});
  final String sendermail;
  final String recievermail;
  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Chats')
            .doc(id)
            .collection('Messages')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            snapshot.data;
            final messages = snapshot.data?.docs;
            List<MessageBubble> allmessages = [];
            for (var message in messages!) {
              final data = message['message'];
              final sender = message['sender'];
              final currentuser = loggedInUser?.email;
              final messagedata = MessageBubble(
                sender: sender,
                isMe: currentuser == sender,
                text: data,
              );
              allmessages.add(messagedata);
            }
            return Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allmessages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => MessageBubble(
                      sender: allmessages[index].sender,
                      text: allmessages[index].text,
                      isMe: allmessages[index].isMe)),
            );
          } else {
            return Container();
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          sender,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(colors: [
                    Color(0xffFFFFF5),
                    Color(0xffFFFFF5),
                  ])
                : const LinearGradient(
                    colors: [
                      Color(0xffffe1e1),
                      Color(0xffff9d9d),
                      Color(0xffff9d9d),
                    ],
                  ),
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
