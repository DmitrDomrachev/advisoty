import 'dart:convert';

import 'package:equatable/equatable.dart';

enum MessageType { text, media, widget }

class ChatMessageDto extends Equatable {
  final String? messageId;
  final String text;
  final String? data;
  final MessageType messageType;
  final String? mediaUrl;
  final int? sender;
  final int? recipient;
  final int dialogId;
  final int? timestamp;

  // Map<int, double> getData() {
  //   if(messageType == MessageType.widget) {
  //     print(json.decode(data ?? '{}'));
  //     return json.decode(data ?? '{}') as Map<int, double>;
  //   }
  //   return {};
  // }

  const ChatMessageDto(
      {this.messageId,
      required this.text,
      this.data,
      required this.messageType,
      this.mediaUrl,
      this.sender,
      this.recipient,
      required this.dialogId,
      this.timestamp});

  factory ChatMessageDto.send({
    required int dialogId,
    required String text,
    required String messageType,
    required Map<int, double> data,
  }) {
    var type = MessageType.text;
    if (messageType == 'TEXT') {
      type = MessageType.text;
    } else if (messageType == 'MEDIA') {
      type = MessageType.media;
    } else if (messageType == 'WIDGET') {
      type = MessageType.widget;
    }

    return ChatMessageDto(
        dialogId: dialogId,
        text: text,
        messageType: type,
        data: jsonEncode(data));
  }

  factory ChatMessageDto.formWeb(
      {required String messageId,
      required String text,
      String? data,
      required String messageType,
      String? mediaUrl,
      required int sender,
      required int recipient,
      required int dialogId,
      required int timestamp}) {
    var type = MessageType.text;
    if (messageType == 'TEXT') {
      type = MessageType.text;
    } else if (messageType == 'MEDIA') {
      type = MessageType.media;
    } else if (messageType == 'WIDGET') {
      type = MessageType.widget;
    }
    print('fromWb data: $data');
    return ChatMessageDto(
      messageId: messageId,
      text: text,
      messageType: type,
      sender: sender,
      recipient: recipient,
      dialogId: dialogId,
      timestamp: timestamp,
      data: data,
    );
  }

  @override
  String toString() {
    return 'ChatMessageDto{messageId: $messageId, text: $text}';
  }

  @override
  List<Object?> get props => [messageId, text];
}
