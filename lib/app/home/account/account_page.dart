
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';
//import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      //final auth = Provider.of<AuthBase>(context);
      final auth = Provider.of<AuthService>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Déconnexion',
      content: 'Confirmer la déconnexion?',
      cancelActionText: 'Annuler',
      defaultActionText: 'Oui',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Compte'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    final photoUrl = user.photoUrl ?? 'https://robohash.org/${user.uid}';
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: photoUrl,
          radius: 50,
        ),
        SizedBox(height: 20),
        Text(
          user.email,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
