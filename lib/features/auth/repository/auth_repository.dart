import 'package:alpha_advisory/features/auth/models/user_data_dto.dart';
import 'package:alpha_advisory/features/auth/repository/auth_web.dart';

import '../models/token_dto.dart';

abstract class IAuthRepository {
  Future<void> signIn({
    required String login,
    required String password,
  });

  TokenDto getToken();

  Future<void> signOut();

  Future<bool> checkToken();
}

class AuthRepository implements IAuthRepository {
  final AuthWebDataProvider _client;

  AuthRepository(this._client);

  @override
  Future<void> signIn({required String login, required String password}) async {
    UserData userData = await _client.signIn(login, password);
    userData.saveUserDate();
    print('repo get userdata ${UserData.fromLocal()}');
  }

  @override
  Future<void> signOut() async {
    UserData.empty.saveUserDate();
  }

  @override
  TokenDto getToken() {
    print('repo getToken userdata ${UserData.fromLocal()}');
    return UserData.fromLocal().tokenDto;
  }

  @override
  Future<bool> checkToken() async {
    return UserData.fromLocal().tokenDto.token.length > 1;
  }
}
