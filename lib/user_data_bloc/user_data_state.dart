part of 'user_data_bloc.dart';

@immutable
abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class LoadingState extends UserDataState {}

class LoadedData extends UserDataState {}
