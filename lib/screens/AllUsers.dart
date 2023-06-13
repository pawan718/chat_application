import 'dart:convert';

import 'package:chat_application/screens/HomeScreen.dart';
import 'package:chat_application/user_data_bloc/user_data_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_data_model/user_data.dart';
import 'chat_screen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserStreams2(),
          ],
        ),
      ),
    );
  }
}

class UserStreams2 extends StatelessWidget {
  UserStreams2({Key? key}) : super(key: key);
  final usersdatacomefromfirebase = _firestore.collection('Users').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: usersdatacomefromfirebase,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final usersdata = snapshot.data?.docs;
          List<dynamic> userdatas = [];
          for (var data in usersdata!) {
            final email = data['email'];
            if (email != loggedInUser!.email) {
              userdatas.add(email);
            }
          }
          return Column(
            children: userdatas
                .map((e) => UserChatCard(
                      email: e,
                      onPressed: () async {
                        List<String> newdata = [loggedInUser?.email ?? '', e];
                        final emails = [loggedInUser!.email, '$e'];
                        emails.sort();
                        final input = emails.join(":");
                        String uniqueID = generateUniqueID(input);
                        final result = await _firestore
                            .collection('Chats')
                            .doc(uniqueID)
                            .get();
                        if (result.exists) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      uniqueID, loggedInUser!.email ?? '', e)));
                        } else {
                          context.read<UserDataBloc>().add(CreateChatEvent(
                              newdata: newdata, uniqueid: uniqueID));
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    uniqueID, loggedInUser?.email ?? '', e)));
                      },
                    ))
                .toList(),
          );
        });
  }

  String generateUniqueID(String input) {
    var bytes = utf8.encode(input);

    // Generate the hash
    var hash = sha256.convert(bytes);

    // Convert the hash to a string
    var uniqueID = hash.toString();

    return uniqueID;
  }
}
