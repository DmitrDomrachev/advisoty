import 'dart:async';

import 'package:alpha_advisory/features/auth/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'auth_screen_event.dart';

part 'auth_screen_state.dart';

class AuthScreenBloc extends Bloc<AuthScreenEvent, AuthScreenState> {
  AuthScreenBloc() : super(const AuthScreenInitialState()) {
    on<AuthScreenInitEvent>(_onInit);
    on<AuthScreenLoginChangedEvent>(_onLoginChanged);
    on<AuthScreenPasswordChangedEvent>(_onPasswordChanged);
    on<AuthScreenLoginEvent>(_onLogin);
  }

  var repository = GetIt.instance<AuthRepository>();

  Future<void> _onLogin(
      AuthScreenLoginEvent event, Emitter<AuthScreenState> emit) async {
    print('_onLogin');
    if (state is AuthScreenInitialState) {
      final cState = state as AuthScreenInitialState;
      print('${cState.login} ${cState.password}');
      await repository.signIn(login: cState.login, password: cState.password);
      print('emit(AuthScreenSuccessState());');

    }
    emit(AuthScreenSuccessState());
  }

  void _onLoginChanged(
      AuthScreenLoginChangedEvent event, Emitter<AuthScreenState> emit) {
    if (state is AuthScreenInitialState) {
      final cState = state as AuthScreenInitialState;
      emit(cState.copyWith(login: event.login));
    } else {
      emit(AuthScreenInitialState(login: event.login));
    }
  }

  void _onPasswordChanged(
      AuthScreenPasswordChangedEvent event, Emitter<AuthScreenState> emit) {
    if (state is AuthScreenInitialState) {
      final cState = state as AuthScreenInitialState;
      emit(cState.copyWith(password: event.password));
    } else {
      emit(AuthScreenInitialState(password: event.password));
    }
  }

  Future<void> _onInit(
      AuthScreenInitEvent event, Emitter<AuthScreenState> emit) async {
    var token = await repository.getToken();
    if (token.token.length > 1){
      emit(AuthScreenSuccessState());
    }
    emit(AuthScreenInitialState());
  }

  @override
  void onChange(Change<AuthScreenState> change) {
    print(change);
  }
}
