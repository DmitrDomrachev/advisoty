part of 'chat_screen_bloc.dart';

abstract class ChatScreenEvent extends Equatable {
  const ChatScreenEvent();
}

class ChatScreenLoadMessagesEvent extends ChatScreenEvent {
  const ChatScreenLoadMessagesEvent();

  @override
  List<Object?> get props => [];
}

class ChatScreenEditMessageTextEvent extends ChatScreenEvent {
  const ChatScreenEditMessageTextEvent(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ChatScreenSendEvent extends ChatScreenEvent {
  final String message;

  const ChatScreenSendEvent(this.message);
  @override
  List<Object?> get props => [];
}



