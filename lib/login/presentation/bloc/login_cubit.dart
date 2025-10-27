import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _auth;

  LoginCubit({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        super(const LoginState());

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> loginUser() async {
    if (state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));
    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      emit(state.copyWith(status: LoginStatus.success));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.message ?? 'Invalid credentials',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
