import 'package:flutter/material.dart';
import 'package:movie_web/bloc/bloc-provider.dart';
import 'package:movie_web/models/user.dart';
import 'package:movie_web/widgets/signup.dart';

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
        child: ListView(
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
            ),
            FlatButton(
              child: Text("Sign in with google"),
              onPressed: () {
                BlocProvider.of(context).userBloc.googleLogin();
              },
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

