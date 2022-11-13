part of 'auth_screen_bloc.dart';

abstract class AuthScreenEvent extends Equatable {
  const AuthScreenEvent();
}

class AuthScreenInitEvent extends AuthScreenEvent {
  @override
  List<Object?> get props => [];
}

class AuthScreenLoginChangedEvent extends AuthScreenEvent {
  final String login;

  const AuthScreenLoginChangedEvent(this.login);

  @override
  List<Object?> get props => [login];
}

class AuthScreenPasswordChangedEvent extends AuthScreenEvent {
  final String password;

  const AuthScreenPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class AuthScreenLoginEvent extends AuthScreenEvent {
  @override
  List<Object?> get props => [];
}
