import 'dart:async';

import 'package:alpha_advisory/features/auth/models/user_data_dto.dart';
import 'package:alpha_advisory/features/chat/repository/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../models/chat_message_dto.dart';

part 'chat_screen_event.dart';

part 'chat_screen_state.dart';

class ChatScreenBloc extends Bloc<ChatScreenEvent, ChatScreenState> {
  ChatScreenBloc() : super(ChatScreenInitialState()) {
    on<ChatScreenLoadMessagesEvent>(_onLoadMessagesRequested);
    on<ChatScreenEditMessageTextEvent>(_onEditMessage);
    on<ChatScreenSendEvent>(_onSend);
  }

  var chatRepository = GetIt.instance<ChatRepository>();

  Future<void> _onLoadMessagesRequested(
      ChatScreenLoadMessagesEvent event, Emitter<ChatScreenState> emit) async {
    print('_onLoadMessagesRequested');

    emit(ChatScreenLoadedState(userData: UserData.fromLocal()));

    await emit.forEach(await chatRepository.getMessages(), onData: (message) {
      print('on data message f $message');
      if (state is ChatScreenLoadedState) {
        var cState = state as ChatScreenLoadedState;
        if (!cState.messages.contains(message)) {
          List<ChatMessageDto> messages = [];
          messages.addAll(cState.messages);
          messages.add(message);

          return cState.copyWith(messages: messages);
        }
      } else {
        return ChatScreenLoadedState(messages: [message]);
      }
      return ChatScreenInitialState();
    });
  }

  void _onEditMessage(
      ChatScreenEditMessageTextEvent event, Emitter<ChatScreenState> emit) {
    if (state is ChatScreenLoadedState) {
      var cState = state as ChatScreenLoadedState;
      emit(cState.copyWith(messageText: event.message));
    }
  }

  Future<void> _onSend(
      ChatScreenSendEvent event, Emitter<ChatScreenState> emit) async {
    chatRepository.sendMessage(event.message);
  }

  @override
  void onChange(Change<ChatScreenState> change) {
    print(change);
    super.onChange(change);
  }
}
