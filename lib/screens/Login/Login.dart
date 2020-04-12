import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  bool _passwordVisible = false;
  PlatformException _error;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    _auth.currentUser().then((user) {
      Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (r) => false);
    });
  }


  void _signIn() async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      Navigator.pushNamedAndRemoveUntil(context, "/dashboard", (r) => false);
    } catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  Widget _entryField(String title) {
    FocusNode _inputFocusNode;
    TextEditingController _inputTextEditorController;
    switch (title) {
      case "Email":
        _inputFocusNode = _emailNode;
        _inputTextEditorController = _emailController;
        break;
      case "Password":
        _inputFocusNode = _passwordNode;
        _inputTextEditorController = _passwordController;
        break;
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: title == "Password" && !_passwordVisible,
            focusNode: _inputFocusNode,
            controller: _inputTextEditorController,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              suffixIcon: title == "Password"
                  ? IconButton(
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    )
                  : null,
            ),
            onFieldSubmitted: (term) {
              _inputFocusNode.unfocus();
              switch (title) {
                case "Email":
                  FocusScope.of(context).requestFocus(_passwordNode);
                  break;
                case "Password":
                  break;
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _entryField("Email"),
          _entryField("Password"),
          if (_error != null) ...[
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    _error.message,
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Log In'),
                onPressed: () => _signIn(),
                color: Colors.black54,
              )
            ],
          )
        ],
      ),
    );
  }
}
