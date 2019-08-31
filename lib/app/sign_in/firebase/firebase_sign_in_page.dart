import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/firebase/firebase_sign_in_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/constants/strings.dart';
import 'package:time_tracker_flutter_course/services/auth_service.dart';

class FirebaseSignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return ChangeNotifierProvider<FirebaseSignInModel>(
      builder: (_) => FirebaseSignInModel(auth: auth),
      child: Consumer<FirebaseSignInModel>(
        builder: (_, FirebaseSignInModel model, __) =>
            FirebaseSignInPage._(model: model),
      ),
    );
  }
}

class FirebaseSignInPage extends StatefulWidget {
  const FirebaseSignInPage._({Key key, @required this.model}) : super(key: key);
  final FirebaseSignInModel model;

  @override
  _FirebaseSignInPageState createState() => _FirebaseSignInPageState();
}

class _FirebaseSignInPageState extends State<FirebaseSignInPage> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseSignInModel get model => widget.model;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      FirebaseSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  void _unfocus() {
    _emailFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  Future<void> _submit() async {
    _unfocus();
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == FirebaseSignInFormType.forgotPassword) {
          PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          Navigator.of(context).pop();
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    final FocusNode newFocus =
        model.canSubmitEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateFormType(FirebaseSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: Strings.emailLabel,
        hintText: Strings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      //obscureText: true,
      obscureText: false,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  Widget _showLogo() {
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
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 8.0),
        _showLogo(),
        SizedBox(height: 8.0),
        _buildEmailField(),
        if (model.formType !=
            FirebaseSignInFormType.forgotPassword) ...<Widget>[
          SizedBox(height: 8.0),
          _buildPasswordField(),
        ],
        SizedBox(height: 8.0),
        FormSubmitButton(
          text: model.primaryButtonText,
          loading: model.isLoading,
          onPressed: model.isLoading ? null : _submit,
        ),
        SizedBox(height: 8.0),
        FlatButton(
          child: Text(model.secondaryButtonText),
          onPressed: model.isLoading
              ? null
              : () => _updateFormType(model.secondaryActionFormType),
        ),
        if (model.formType == FirebaseSignInFormType.signIn)
          FlatButton(
            child: Text(Strings.forgotPasswordQuestion),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(FirebaseSignInFormType.forgotPassword),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(model.title),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}
