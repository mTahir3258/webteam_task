import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseAuth _auth;

  RegisterCubit({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        super(const RegisterState());

  void nameChanged(String value) => emit(state.copyWith(name: value));

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> submit() async {
    if (state.status == RegisterStatus.submitting) return;
    emit(state.copyWith(status: RegisterStatus.submitting, errorMessage: null));
    try {
      // Create user with email & password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password,
      );

      // Optionally update displayName
      await userCredential.user?.updateDisplayName(state.name.trim());

      emit(state.copyWith(status: RegisterStatus.success));
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'Authentication error';
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: message));
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, errorMessage: e.toString()));
    }
  }
}
