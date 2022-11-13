import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alpha_advisory/features/auth/models/user_data_dto.dart';
import 'package:alpha_advisory/features/chat/models/chat_message_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

@immutable
class ChatWebDataProvider {
  final Dio dio = GetIt.instance<Dio>();

  final _messageStreamController = StreamController<ChatMessageDto>();

  Future<void> sendMessage(ChatMessageDto chatMessageDto) async {
    print('send message ${chatMessageDto.data}');
    final UserData userDataDto = UserData.fromLocal();
    dio.options.headers['Authorization'] = userDataDto.tokenDto.header();
    try {
      await dio.post('/message/send', data: {
        "message": {
          "dialogId": 14,
          "text": "${chatMessageDto.text}",
          "messageType":
              chatMessageDto.messageType.toString().split('.')[1].toUpperCase(),
          'data': '{}',
        }
      });
    } catch (e) {
      print('send message error x');
      print(e);
    }
  }

  Future<int> getChatId() async {
    final UserData userDataDto = UserData.fromLocal();
    dio.options.headers['Authorization'] = userDataDto.tokenDto.header();

    var response = await dio.get('/chat/dialog');
    return response.data['dialogId'];
  }

  Future<Stream<ChatMessageDto>> messagesStream() async {
    // final UserData userDataDto = UserData.fromLocal();
    var messages = await _getMessages(await getChatId());
    print('messagesStream web data ${messages}');

    for (var message in messages) {
      _messageStreamController.add(message);
      print('add to stream $message ${message.data}');
    }
    await _subscribeWebSocket();
    return _messageStreamController.stream;
  }

  Future<void> _subscribeWebSocket() async {
    final channel = await WebSocket.connect('wss://hack.invest-open.ru/chat',
        headers: {'Authorization': UserData.fromLocal().tokenDto.header()});
    channel.listen((data) {
      var message = json.decode(data)['messageData'];
      var messageDto = ChatMessageDto.formWeb(
        messageId: message['messageId'],
        text: message['text'],
        messageType: message['messageType'],
        sender: message['sender'],
        recipient: message['recipient'],
        dialogId: message['dialogId'],
        timestamp: message['timestamp'],
        data: message['data'],
      );
      print('subscribeWebSocket messageDto $messageDto');
      _messageStreamController.add(messageDto);
    });
  }

  Future<List<ChatMessageDto>> _getMessages(int dialogId) async {
    final UserData userDataDto = UserData.fromLocal();
    print("getMessages($dialogId)");
    dio.options.headers['Authorization'] = userDataDto.tokenDto.header();

    var response = await dio.get('/chat/history?dialogId=$dialogId');
    List<ChatMessageDto> messages = [];

    for (var message in response.data['messages']) {
      messages.add(
        ChatMessageDto.formWeb(
          messageId: message['messageId'],
          text: message['text'],
          messageType: message['messageType'],
          sender: message['sender'],
          recipient: message['recipient'],
          dialogId: message['dialogId'],
          timestamp: message['timestamp'],
          data: message['data'],
        ),
      );
    }

    print('web chat return ${messages.length} messages');
    return messages.reversed.toList();
  }
}
