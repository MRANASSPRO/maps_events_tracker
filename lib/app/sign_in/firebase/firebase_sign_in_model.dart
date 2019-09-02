import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/constants/strings.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';

enum FirebaseSignInFormType { signIn, register, forgotPassword }

class FirebaseSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  FirebaseSignInModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = FirebaseSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthService auth;

  String email;
  String password;
  FirebaseSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case FirebaseSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case FirebaseSignInFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
        case FirebaseSignInFormType.forgotPassword:
          await auth.sendPasswordResetEmail(email);
          break;
      }
      return true;
    } catch (e) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(FirebaseSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String email,
    String password,
    FirebaseSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == FirebaseSignInFormType.register) {
      return Strings.password8CharactersLabel;
    }
    return Strings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <FirebaseSignInFormType, String>{
      FirebaseSignInFormType.register: Strings.createAnAccount,
      FirebaseSignInFormType.signIn: Strings.signIn,
      FirebaseSignInFormType.forgotPassword: Strings.sendResetLink,
    }[formType];
  }

  String get secondaryButtonText {
    return <FirebaseSignInFormType, String>{
      FirebaseSignInFormType.register: Strings.haveAnAccount,
      FirebaseSignInFormType.signIn: Strings.needAnAccount,
      FirebaseSignInFormType.forgotPassword: Strings.backToSignIn,
    }[formType];
  }

  FirebaseSignInFormType get secondaryActionFormType {
    return <FirebaseSignInFormType, FirebaseSignInFormType>{
      FirebaseSignInFormType.register: FirebaseSignInFormType.signIn,
      FirebaseSignInFormType.signIn: FirebaseSignInFormType.register,
      FirebaseSignInFormType.forgotPassword: FirebaseSignInFormType.signIn,
    }[formType];
  }

  String get errorAlertTitle {
    return <FirebaseSignInFormType, String>{
      FirebaseSignInFormType.register: Strings.registrationFailed,
      FirebaseSignInFormType.signIn: Strings.signInFailed,
      FirebaseSignInFormType.forgotPassword: Strings.passwordResetFailed,
    }[formType];
  }

  String get title {
    return <FirebaseSignInFormType, String>{
      FirebaseSignInFormType.register: Strings.register,
      FirebaseSignInFormType.signIn: Strings.signInPageTitle,
      FirebaseSignInFormType.forgotPassword: Strings.forgotPassword,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == FirebaseSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
    formType == FirebaseSignInFormType.forgotPassword ? canSubmitEmail : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty ? Strings.invalidEmailEmpty : Strings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty ? Strings.invalidPasswordEmpty : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
