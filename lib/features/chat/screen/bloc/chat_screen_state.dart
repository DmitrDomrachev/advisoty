part of 'chat_screen_bloc.dart';

abstract class ChatScreenState extends Equatable {
  const ChatScreenState();
}

class ChatScreenInitialState extends ChatScreenState {
  @override
  List<Object> get props => [];
}

class ChatScreenLoadedState extends ChatScreenState {
  final String messageText;
  final List<ChatMessageDto> messages;
  final UserData userData;

  const ChatScreenLoadedState({
    this.messageText = '',
    this.messages = const [],
    this.userData = UserData.empty,
  });

  @override
  List<Object> get props => [messages, userData, messageText];

  ChatScreenLoadedState copyWith({
    String? messageText,
    List<ChatMessageDto>? messages,
    UserData? userData,
  }) {
    return ChatScreenLoadedState(
      messageText: messageText ?? this.messageText,
      messages: messages ?? this.messages,
      userData: userData ?? this.userData,
    );
  }
}
