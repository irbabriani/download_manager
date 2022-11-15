import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:download_manager/presentation/authentication/authentication_cubit.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthenticationCubit authenticationCubit;
  SignInCubit({required this.authenticationCubit}) : super(SignInInitial());
}
