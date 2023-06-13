import 'dart:math';

import 'package:chat_application/screens/AllUsers.dart';
import 'package:chat_application/screens/FirstScreen.dart';
import 'package:chat_application/screens/chat_screen.dart';
import 'package:chat_application/user_data_bloc/user_data_bloc.dart';
import 'package:chat_application/user_data_model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
User? loggedInUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var data = "";
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AllUsers()));
          }),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xffffe1e1),
              Color(0xffff9d9d),
              Color(0xffff9d9d),
            ])),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                      child: Icon(Icons.menu),
                    ),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: IconButton(
                                      onPressed: () async {
                                        await _auth.signOut();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const FirstScreen()));
                                      },
                                      icon: const Icon(Icons.logout)))
                            ]),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Chats',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        'chats',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    UserStreams(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class UserStreams extends StatelessWidget {
  const UserStreams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Chats')
            .where('Users', arrayContains: loggedInUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final usersdata = snapshot.data?.docs;
          List<UserData> userdatas = [];
          for (var data in usersdata!) {
            final id = data.id;
            final mydata = data.data() as Map<String, dynamic>;
            final response = mydata['Users'] as List<dynamic>;
            if (response.last == loggedInUser!.email) {
              userdatas.add(UserData(response.first, id));
            } else {
              userdatas.add(UserData(response.last, id));
            }
          }
          return Column(
            children: userdatas
                .map((e) => UserChatCard(
                      email: e.email,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    e.id, loggedInUser?.email ?? '', e.email)));
                      },
                    ))
                .toList(),
          );
        });
  }
}

class UserChatCard extends StatelessWidget {
  const UserChatCard({
    required this.email,
    this.onPressed,
    super.key,
  });
  final String email;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Row(
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
