import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';
//import 'package:time_tracker_flutter_course/services/auth.dart';

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_flutter_course/app/sign_in/firebase/Modals/UserProfile.dart';
import 'package:time_tracker_flutter_course/app/home/account/gender_selector.dart';*/

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
    //final photoUrl = user.photoUrl ?? 'https://randomuser.me/api/portraits/men/46.jpg'.toString();
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


/*class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fnController = TextEditingController();
    var fnBio = TextEditingController();

    User user = Provider.of<User>(context);
    return StreamProvider<DocumentSnapshot>.value(
        value: Firestore.instance
            .collection("profiles")
            .document(user.uid)
            .snapshots(),
        child: Builder(builder: (context) {
          DocumentSnapshot snapshot = Provider.of<DocumentSnapshot>(context);
          if (snapshot != null && snapshot.exists) {
            var data = snapshot.data;
            return ChangeNotifierProvider<UserProfile>(
              builder: (context) => UserProfile.getInstance(
                  data["fullName"], data["gender"], data["bio"]),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: Text(
                    "Your Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 0.0,
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 16.0, 0.0),
                      child: IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.white),
                          onPressed: () {
                            _confirmSignOut(context);
                            //FirebaseAuth.instance.signOut();
                          }),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      heightFactor: 0.25,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(
                              MediaQuery.of(context).size.width)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Consumer<UserProfile>(
                          builder: (context, pData, _) {
                            fnController.value =
                                TextEditingValue(text: pData.fullName);
                            fnBio.value = TextEditingValue(text: pData.bio);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 50, 0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                "https://randomuser.me/api/portraits/men/46.jpg"))),
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                      onChanged: (text) {
                                        pData.fullName = text.trim();
                                      },
                                      controller: fnController,
                                      decoration: InputDecoration(
                                          hintText: "Full Name",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.6)),
                                              borderSide: BorderSide(
                                                  color: Colors.orange)))),
                                ),
                                GenderSelector(pData.gender),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                      controller: fnBio,
                                      onChanged: (text) {
                                        pData.bio = text.trim();
                                      },
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          hintText: "Bio",
                                          hintMaxLines: 5,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.6)),
                                              borderSide: BorderSide(
                                                  color: Colors.orange)))),
                                ),
                                MaterialButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    snapshot.reference
                                        .updateData(pData.toMap());
                                  },
                                  child: Text(
                                    "Save Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }

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
}*/
