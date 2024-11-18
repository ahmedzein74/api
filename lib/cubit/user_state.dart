class UserState {}

final class UserInitial extends UserState {}

final class SignInLoading extends UserState {}

final class SignInSuccess extends UserState {}

final class SignInError extends UserState {
  final String message;
  SignInError(this.message);
}
