import 'package:flutter/material.dart';
import 'package:movie_web/bloc/bloc-provider.dart';
import 'package:movie_web/models/user.dart';

class UtitlityScreen extends StatefulWidget {
  @override
  _UtitlityScreenState createState() => _UtitlityScreenState();
}

class _UtitlityScreenState extends State<UtitlityScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }
    BlocProvider.of(context)
        .userBloc
        .login(_emailController.text, _passwordController.text);
  }

  renderLoginForm() {
    return Container(
      height: 500.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage("assets/doraemon.jpg"),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(hintText: "Enter your email"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: true,
              decoration: InputDecoration(hintText: "Enter your password"),
              onFieldSubmitted: (_) {
                login();
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.purpleAccent,
              disabledColor: Colors.purple,
              disabledTextColor: Colors.grey,
              onPressed: (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty)
                  ? null
                  : () => login(),
              child: Text("Login"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              onPressed: () {
                showBottomSheet(
                    context: context, builder: (context) => SignupForm());
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool invalidLoginForm = true;
  Widget build(context) {
    return StreamBuilder(
      stream: BlocProvider.of(context).userBloc.user$,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.data != null) {
          return Text("Login success");
        }
        return renderLoginForm();
      },
    );
  }
}

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

  Widget build(context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
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
              SizedBox(
                height: 20.0,
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
              SizedBox(
                height: 20.0,
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
                decoration: InputDecoration(hintText: "Enter your password"),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (text) {
                  print(text);
                  print(_passwordController.text);
                  if (_passwordController.text != text) {
                    return 'Password do not match';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Confirm your password"),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                onSaved: (text) {
                  _phone = text;
                },
                validator: (text) {
                  if (text.length > 10) {
                    return "Please enter valid phone number";
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Enter your phone"),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  textColor: Colors.white,
                  color: Colors.purpleAccent,
                  disabledColor: Colors.purple,
                  disabledTextColor: Colors.grey,
                  onPressed: () {
                    final isValid = _formKey.currentState.validate();
                    if (!_autoValidate) {
                      setState(() {
                        _autoValidate = true;
                      });
                    }
                    if (isValid) {
                      _formKey.currentState.save();
                      // BlocProvider.of(context).userBloc.signup(_email, _password, _username, _phone);
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
