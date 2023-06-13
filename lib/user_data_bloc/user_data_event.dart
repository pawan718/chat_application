part of 'user_data_bloc.dart';

@immutable
abstract class UserDataEvent {}

class AllUserDataEvent extends UserDataEvent {}

class OnlyActiveChatDataEvent extends UserDataEvent {}

class CreateChatEvent extends UserDataEvent {
  List<String> newdata;
  String uniqueid;
  CreateChatEvent({required this.newdata, required this.uniqueid});
}

class CountOfChatEvent extends UserDataEvent {
  final String currentuser;
  CountOfChatEvent({required this.currentuser});
}

class SendMessageEvent extends UserDataEvent {
  String message;
  String sender;
  String id;
  SendMessageEvent(
      {required this.sender, required this.message, required this.id});
}
