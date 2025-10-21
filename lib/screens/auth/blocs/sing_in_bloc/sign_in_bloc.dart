import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(const SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(const SignInInProgress());
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(const SignInSuccess());
      } catch (e) {
        emit(SignInFailure(e.toString()));
      }
    });
    
    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
