import 'package:bloc/bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailed extends LoginState {
  final String error;

  LoginFailed({required this.error});
}

class LoginEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  LoginState get initialState => LoginInitial();

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event.username.isEmpty) {
      yield LoginFailed(error: 'El nombre de usuario está vacío');
    } else if (event.password.isEmpty) {
      yield LoginFailed(error: 'La contraseña está vacía');
    } else {
      yield LoginLoading();

      final isLogin = await doLogin(event.username, event.password);
      if (isLogin) {
        yield LoginSuccess();
      } else {
        yield LoginFailed(error: 'Error de inicio de sesión');
      }
    }
  }

  Future<bool> doLogin(username, password) async {
    await Future.delayed(const Duration(seconds: 3));
    return username == 'admin' && password == 'admin';
  }
}
