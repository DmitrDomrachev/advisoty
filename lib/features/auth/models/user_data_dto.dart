import 'package:alpha_advisory/features/auth/models/token_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { operator, client, unfilled }

@immutable
class UserData {
  final int userId;

  final UserRole userRole;

  final String userLogin;

  final TokenDto tokenDto;

  const UserData({
    required this.userId,
    required this.userRole,
    required this.userLogin,
    required this.tokenDto,
  });

  factory UserData.fromWeb(
      {required int userId,
      required String userRole,
      required String userLogin,
      required String token}) {
    UserRole role = UserRole.unfilled;
    if (userRole.toLowerCase() == 'client') {
      role = UserRole.client;
    } else if (userRole.toLowerCase() == 'operator') {
      role = UserRole.operator;
    }
    return UserData(
      userId: userId,
      userRole: role,
      userLogin: userLogin,
      tokenDto: TokenDto(token: token),
    );
  }

  Future<void> saveUserDate() async {
    final prefs = GetIt.instance<SharedPreferences>();
    await prefs.setInt('userId', userId);
    await prefs.setString('userRole', userRole.name);
    await prefs.setString('userLogin', userLogin);
    await prefs.setString('tokenDto', tokenDto.token);
  }

  factory UserData.fromLocal() {
    final prefs = GetIt.instance<SharedPreferences>();
    int userId = prefs.getInt('userId') ?? 0;
    String? userRole = prefs.getString('userRole');
    String userLogin = prefs.getString('userLogin') ?? '';
    String tokenDto = prefs.getString('tokenDto') ?? '';

    UserRole role = UserRole.unfilled;
    if (userRole == 'client') {
      role = UserRole.client;
    } else if (userRole == 'operator') {
      role = UserRole.operator;
    }

    return UserData(
      userId: userId,
      userRole: role,
      userLogin: userLogin,
      tokenDto: TokenDto(token: tokenDto),
    );
  }

  @override
  String toString() {
    return 'UserDataDto{userId: $userId, userRole: $userRole, userLogin: $userLogin, tokenDto: $tokenDto}';
  }

  static const empty = UserData(
      userId: 0,
      userRole: UserRole.unfilled,
      userLogin: '-',
      tokenDto: TokenDto.empty);
}
