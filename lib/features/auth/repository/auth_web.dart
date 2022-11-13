import 'dart:convert'; // for the utf8.encode method

import 'package:alpha_advisory/features/auth/models/token_dto.dart';
import 'package:alpha_advisory/features/auth/models/user_data_dto.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AuthWebDataProvider {
  final Dio dio = GetIt.instance<Dio>();

  Future<UserData> signIn(String login, String password) async {
    var bytes = utf8.encode(password);
    var hashPassword = sha256.convert(bytes);

    dio.options.headers['content-Type'] = 'application/json';

    var response = await dio
        .post('/auth', data: {"login": login, "password": "$hashPassword"});

    print('signIn with jwt token:  ${response.data['jwtToken']}');
    print(response.data);
    var userData = UserData.fromWeb(
        userId: response.data['userId'],
        userRole: response.data['role'],
        userLogin: response.data['login'],
        token: response.data['jwtToken']);
    print('user data: $userData');
    return userData;
  }

  Future<bool> verifyToken(TokenDto tokenDto) async {
    return true;
  }
}
