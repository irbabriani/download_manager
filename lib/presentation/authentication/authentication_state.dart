part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}
