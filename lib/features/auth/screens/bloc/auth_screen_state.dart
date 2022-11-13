part of 'auth_screen_bloc.dart';

abstract class AuthScreenState extends Equatable {
  const AuthScreenState();
}

class AuthScreenInitialState extends AuthScreenState {
  final String login;
  final String password;

  const AuthScreenInitialState({
    this.login = '',
    this.password = '',
  });

  @override
  List<Object> get props => [login, password];

  AuthScreenInitialState copyWith({
    String? login,
    String? password,
  }) {
    return AuthScreenInitialState(
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }
}

class AuthScreenLoadingState extends AuthScreenState {
  @override
  List<Object> get props => [];
}

class AuthScreenErrorState extends AuthScreenState {
  final String errorText;

  const AuthScreenErrorState(this.errorText);

  @override
  List<Object> get props => [];
}

class AuthScreenSuccessState extends AuthScreenState {
  @override
  List<Object> get props => [];
}
