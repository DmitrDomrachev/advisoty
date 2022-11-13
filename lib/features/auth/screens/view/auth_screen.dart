import 'package:alpha_advisory/features/chat/screen/view/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_screen_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthScreenBloc(),
      child: BlocListener<AuthScreenBloc, AuthScreenState>(
        listener: (context, state) {
          if (state is AuthScreenSuccessState) {
            print('push');
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ChatPage()));
          }
        },
        child: AuthView(),
      ),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: BlocBuilder<AuthScreenBloc, AuthScreenState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (text) {
                    context
                        .read<AuthScreenBloc>()
                        .add(AuthScreenLoginChangedEvent(text));
                  },
                  decoration: InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (text) {
                    context
                        .read<AuthScreenBloc>()
                        .add(AuthScreenPasswordChangedEvent(text));
                  },
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      context
                          .read<AuthScreenBloc>()
                          .add(AuthScreenLoginEvent());
                    },
                    child: const Text('Войти'))
              ],
            ),
          );
        },
      ),
    );
  }
}
