import 'package:alpha_advisory/features/auth/repository/auth_repository.dart';
import 'package:alpha_advisory/features/chat/repository/chat_repository.dart';
import 'package:alpha_advisory/features/chat/repository/chat_web.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/repository/auth_web.dart';

Future<void> setupGetIt() async {
  final getIt = GetIt.instance;

  BaseOptions options = BaseOptions(
    baseUrl: 'https://hack.invest-open.ru',
    connectTimeout: 30000,
    receiveTimeout: 30000,
    contentType: 'application/json',
  );
  getIt.registerSingleton<Dio>(Dio(options));

  getIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());

  getIt.registerSingleton(
    AuthRepository(
      AuthWebDataProvider(),
    ),
  );

  getIt.registerSingleton(
    ChatRepository(
      ChatWebDataProvider(),
    ),
  );

}
