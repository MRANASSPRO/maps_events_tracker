import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';
//import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
//import 'package:time_tracker_flutter_course/services/auth.dart';

//aka RootPage
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (_, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPageBuilder();
          }
          /*return Provider<User>.value(
            value: user,
            child: HomePage(),
          );*/
          return Provider<User>.value(
            value: user,
            child: Provider<Database>(
              builder: (_) => FirestoreDatabase(uid: user.uid),
              //builder: (_) => FirestoreDatabase(),
              child: HomePage(),
            ),
          );
          /*return Provider<User>(
            builder: (_) => User(uid: user.uid),
            child: HomePage(),
          );*/
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

/*class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            return Provider<User>.value(
              value: user,
              child: Provider<Database>(
                builder: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}*/
