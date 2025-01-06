part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoading extends ChatState{}

class ChatLoaded extends ChatState{
  final List messages;
  ChatLoaded({required this.messages});
}
