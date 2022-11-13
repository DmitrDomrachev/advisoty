import 'dart:math';

import 'package:alpha_advisory/features/chat/models/chat_message_dto.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mrx_charts/mrx_charts.dart';

import '../bloc/chat_screen_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatScreenBloc()..add(const ChatScreenLoadMessagesEvent()),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          onPressed: () {
            context
                .read<ChatScreenBloc>()
                .add(const ChatScreenLoadMessagesEvent());
          },
          icon: const Icon(Icons.update),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ChatScreenBloc, ChatScreenState>(
          builder: (context, state) {
            if (state is ChatScreenLoadedState) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          BubbleSpecialThree(
                            color: state.messages[index].sender ==
                                state.userData.userId ? Colors.lightBlue : Colors.black12,
                            text: state.messages[index].text,
                            isSender: state.messages[index].sender ==
                                state.userData.userId,
                          ),
                          state.messages[index].messageType ==
                                  MessageType.widget
                              ? SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Chart(
                                        layers: layers(),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  MessageBar(
                    onSend: (text) {
                      context
                          .read<ChatScreenBloc>()
                          .add(ChatScreenSendEvent(text));
                      context
                          .read<ChatScreenBloc>()
                          .add(const ChatScreenEditMessageTextEvent(''));
                    },
                  ),
                ],
              );
            }
            return Container(
              child: Text('State: $state'),
            );
          },
        ),
      ),
    );
  }
}

List<ChartLayer> layers() {
  final from = DateTime(2021, 4);
  final to = DateTime(2021, 8);
  final frequency =
      (to.millisecondsSinceEpoch - from.millisecondsSinceEpoch) / 3.0;
  return [

    ChartAxisLayer(
      settings: ChartAxisSettings(
        x: ChartAxisSettingsAxis(
          frequency: frequency,
          max: to.millisecondsSinceEpoch.toDouble(),
          min: from.millisecondsSinceEpoch.toDouble(),
          textStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10.0,
          ),
        ),
        y: ChartAxisSettingsAxis(
          frequency: 100.0,
          max: 400.0,
          min: 0.0,
          textStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 10.0,
          ),
        ),
      ),
      labelX: (value) => DateFormat('MMM')
          .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())),
      labelY: (value) => value.toInt().toString(),
    ),
    ChartLineLayer(
      items: List.generate(
        4,
            (index) => ChartLineDataItem(
          x: (index * frequency) + from.millisecondsSinceEpoch,
          value: Random().nextInt(380) + 20,
        ),
      ),
      settings: const ChartLineSettings(
        color: Color(0xFF8043F9),
        thickness: 4.0,
      ),
    ),
    ChartTooltipLayer(
      shape: () => ChartTooltipLineShape<ChartLineDataItem>(
        backgroundColor: Colors.white,
        circleBackgroundColor: Colors.white,
        circleBorderColor: const Color(0xFF331B6D),
        circleSize: 4.0,
        circleBorderThickness: 2.0,
        currentPos: (item) => item.currentValuePos,
        onTextValue: (item) => '€${item.value.toString()}',
        marginBottom: 6.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        radius: 6.0,
        textStyle: const TextStyle(
          color: Color(0xFF8043F9),
          letterSpacing: 0.2,
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ];
}