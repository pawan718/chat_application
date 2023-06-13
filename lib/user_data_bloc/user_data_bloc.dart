import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  String countofchats = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserDataBloc() : super(UserDataInitial()) {
    on<AllUserDataEvent>((event, emit) {});
    on<CreateChatEvent>((event, emit) =>
        _firestore.collection('Chats').doc(event.uniqueid).set({
          'Users': FieldValue.arrayUnion(event.newdata),
        }));

    on<SendMessageEvent>((event, emit) async => await _firestore
            .collection('Chats')
            .doc(event.id)
            .collection('Messages')
            .doc()
            .set({
          'message': event.message,
          'sender': event.sender,
          'timestamp': Timestamp.now(),
        }));
  }
}
