class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';

  // Logout
  static const String logout = 'Logout';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';

  // Sign In Page
  static const String welcomePageTitle = 'Accueil';
  static const String welcome = 'Bienvenue dans ADM Tracker';
  static const String welcomeButton = 'Commencer';
  static const String signIn = 'Connexion';
  static const String signInPageTitle = 'Login';
  static const String signInWithEmailPassword =
      'Sign in with email and password';
  static const String signInWithEmailLink = 'Sign in with email link';
  static const String signInWithFacebook = 'Sign in with Facebook';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';

  // Email & Password page
  static const String register = 'S´inscrire';
  static const String forgotPassword = 'Mot de passe oublié';
  static const String forgotPasswordQuestion = 'Mot de passe oublié?';
  static const String createAnAccount = 'Créer un Compte';
  static const String needAnAccount = 'Nouveau compte? S´inscrire';
  static const String haveAnAccount = 'Déja enregisté? Connexion';
  static const String signInFailed = 'Sign in failed';
  static const String registrationFailed = 'Inscription échouée';
  static const String passwordResetFailed = 'Réinitialisation échouée';
  static const String sendResetLink = 'Réinitialisation';
  static const String backToSignIn = 'Retour vers login';
  static const String resetLinkSentTitle = 'Lien Envoyé';
  static const String resetLinkSentMessage =
      'Vérifiez votre email pour réinitialiser votre mot de passe';
  static const String emailLabel = 'Email';
  static const String emailHint = 'email@test.com';
  static const String password8CharactersLabel = 'Mot de passe (8+ caractères)';
  static const String passwordLabel = 'Mot de passe';
  static const String invalidEmailErrorText = 'Email est invalide';
  static const String invalidEmailEmpty = 'Email est vide';
  static const String invalidPasswordTooShort = 'Mot de passe est trop court';
  static const String invalidPasswordEmpty = 'Mot de passe est vide';

  // Email link page
  static const String submitEmailAddressLink =
      'Submit your email address to receive an activation link.';
  static const String checkYourEmail = 'Check your email';

  static String activationLinkSent(String email) => 'We have sent an activation link to $email';
  static const String errorSendingEmail = 'Error sending email';
  static const String sendActivationLink = 'Send activation link';
  static const String activationLinkError = 'Email activation error';
  static const String submitEmailAgain = 'Please submit your email address again to receive a new activation link.';
  static const String userAlreadySignedIn = 'Received an activation link but you are already signed in.';
  static const String isNotSignInWithEmailLinkMessage = 'Invalid activation link';
}
