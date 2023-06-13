import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(LoggedInState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<SignUpEvent>((event, emit) async {
      emit(LoadingState());
      try {
        final user = await _auth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);
        if (user != null) {
          _firestore.collection('Users').doc(user.user?.uid).set({
            'id': user.user?.uid,
            'email': user.user?.email,
            'name': event.name,
          });
        }
        emit(LoggedInState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
