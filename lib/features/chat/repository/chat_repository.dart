import 'dart:convert';

import 'package:alpha_advisory/features/chat/models/chat_message_dto.dart';
import 'package:alpha_advisory/features/chat/repository/chat_web.dart';
import 'package:alpha_advisory/features/chat/utils/stock_chart.dart';

abstract class IChatRepository {
  Future<int> getChatId();

  Future<void> sendMessage(String message);

  Future<Stream<ChatMessageDto>> getMessages();
}

class ChatRepository implements IChatRepository {
  final ChatWebDataProvider dataProvider;

  const ChatRepository(this.dataProvider);

  @override
  Future<int> getChatId() async {
    return await dataProvider.getChatId();
  }

  @override
  Future<Stream<ChatMessageDto>> getMessages() async {
    print('repo getMessages');
    return await dataProvider.messagesStream();
  }

  @override
  Future<void> sendMessage(String message) async {
    if (message.contains('*')) {
      Map<String,double> data = await getStockChart(message.split('*')[1]);
      try {
        var messageDto = ChatMessageDto(
            text: message,
            messageType: MessageType.widget,
            dialogId: await getChatId(),
            data: data.toString());
        print('repo send widget message: ${messageDto.data}');
        await dataProvider.sendMessage(messageDto);
      } catch (e) {
        print('repo error');
        print(e);
      }
    } else {
      var messageDto = ChatMessageDto(
          text: message,
          messageType: MessageType.text,
          dialogId: await getChatId());
      print('repo send text message: $messageDto');
      await dataProvider.sendMessage(messageDto);
    }
  }
}
