import 'package:flutter/material.dart';
import 'package:movie_web/bloc/bloc-provider.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;
  String _username;
  String _phone;

  bool validateEmail(email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return regex.hasMatch(email);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void showSnackBar(message) {
    final snackBar = SnackBar(
      content: Text("$message"),
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          Scaffold.of(context).removeCurrentSnackBar();
        },
      ),
      behavior: SnackBarBehavior.fixed,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget build(context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                onSaved: (text) {
                  _email = text;
                },
                validator: (text) {
                  if (text.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!validateEmail(text)) {
                    return "Please enter valid email";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter your email"),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                onSaved: (text) {
                  _username = text;
                },
                validator: (text) {
                  if (text.isEmpty) {
                    return "Please enter username";
                  }
                  if (text.length < 5) {
                    return "Username must has atleast 5 character";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter your username"),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                onSaved: (text) {
                  _password = text;
                },
                controller: _passwordController,
                validator: (text) {
                  if (text.isEmpty) {
                    return "Please enter you password";
                  }
                  if (text.length < 5) {
                    return "Password must has atleast 5 character";
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter your password"),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                validator: (text) {
                  if (_passwordController.text != text) {
                    return 'Password do not match';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(hintText: "Confirm your password"),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                onSaved: (text) {
                  _phone = text;
                },
                validator: (text) {
                  if (text.length < 10) {
                    return "Please enter valid phone number";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter your phone"),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.purpleAccent,
                disabledColor: Colors.purple,
                disabledTextColor: Colors.grey,
                onPressed: () async {
                  final isValid = _formKey.currentState.validate();
                  if (!_autoValidate) {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                  if (!isValid) {
                    return;
                  }
                  _formKey.currentState.save();
                  final success = await BlocProvider.of(context)
                      .userBloc
                      .signup(_email, _password, _username, _phone);
                  if (success) {
                    Navigator.of(context).pop();
                    showSnackBar(
                        "Congratulation $_username, you have signed up successfully.");
                    return;
                  }
                },
                child: Text("Sign up"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}