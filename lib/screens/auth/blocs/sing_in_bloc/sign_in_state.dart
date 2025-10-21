part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class SignInInProgress extends SignInState {
  const SignInInProgress();
}

class SignInSuccess extends SignInState {
  const SignInSuccess();
}

class SignInFailure extends SignInState {
  final String message;
  
  const SignInFailure(this.message);

  @override
  List<Object?> get props => [message];
}
