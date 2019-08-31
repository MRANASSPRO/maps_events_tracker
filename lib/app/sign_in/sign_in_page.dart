import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/firebase/firebase_sign_in_page.dart';
import 'package:time_tracker_flutter_course/constants/strings.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';
//import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
//import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPageBuilder extends StatelessWidget {
  // P<ValueNotifier>
  //   P<SignInManager>(valueNotifier)
  //     SignInPage(value)
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
              builder: (_) => SignInManager(auth: auth, isLoading: isLoading),
              child: Consumer<SignInManager>(
                builder: (_, SignInManager manager, __) =>
                    SignInPage._(
                      isLoading: isLoading.value,
                      manager: manager,
                      title: 'Welcome Page',
                    ),
              ),
            ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.isLoading, this.manager, this.title})
      : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;

  /*Future<void> _showSignInError(BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }*/

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => FirebaseSignInPageBuilder(),
      ),
    );
  }

  /*Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    await FirebaseSignInPage.show(
      context,
      onSignedIn: () => Navigator.pop(context),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      //drawer: isLoading ? null : DeveloperMenu(),
      backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  /*Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/ADM.png'),
        ),
      ),
    );
  }*/

  Widget _buildHeader() {
    //_showLogo();
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      Strings.welcome,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w100),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 90.0,
            child: _buildHeader(),
          ),
          SizedBox(
            height: 50,
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.lightBlue,
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              onPressed:
              isLoading ? null : () => _signInWithEmailAndPassword(context),
            ),
          ),
          /*RaisedButton(
            child: Text(
                Strings.signInWithEmailPassword,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            onPressed: isLoading ? null : () => _signInWithEmailAndPassword(context),
            textColor: Colors.white,
            color: Colors.teal[700],
          ),*/
        ],
      ),
    );
  }
}


/*class SignInPage extends StatelessWidget {
  const SignInPage({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (context) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (context, valueNotifier, _) => Provider<SignInManager>(
          builder: (context) =>
              SignInManager(auth: auth, isLoading: valueNotifier),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) => SignInPage(
              manager: manager,
              isLoading: valueNotifier.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 90.0,
            child: _buildHeader(),
          ),
          SizedBox(
            height: 50,
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.lightBlue,
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              onPressed:
              isLoading ? null : () => _signInWithEmail(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}*/
