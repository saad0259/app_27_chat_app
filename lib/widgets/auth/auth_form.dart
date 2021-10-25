import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  final Future<void> Function(String email, String username, File? userImageFile,
      String password, bool isLogin)? submitAuthData;

  AuthForm(this.submitAuthData);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  File? _userImageFile;

  void _pickedImageFn(File image) {
    _userImageFile = image;
  }

  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };

  var _isLoading = false;

  // final _passwordController = TextEditingController();
  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (_userImageFile == null && _authMode == AuthMode.Signup) {
      _showErrorDialog('Image not selected');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    try {
      Focus.of(context).unfocus();
    } catch (_) {}
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    await widget.submitAuthData!(
        _authData['email']!.trim(),
        _authData['username']!.trim(),
        _userImageFile,
        _authData['password']!.trim(),
        _authMode == AuthMode.Login ? true : false);

    print('after submission');
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Card(
        // color: Theme.of(context).accentColor,
        margin: const EdgeInsets.all(20),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          // curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 430 : 300,
          width: deviceSize.width * 0.8,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _authMode == AuthMode.Login
                          ? Container()
                          : UserImagePicker(_pickedImageFn),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _authMode == AuthMode.Signup
                          ? TextFormField(
                              key: ValueKey('username'),
                              decoration:
                                  InputDecoration(labelText: 'Username'),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Please enter at-least 5 characters';
                                }
                              },
                              onSaved: (value) {
                                _authData['username'] = value!;
                              },
                            )
                          : Container(),
                    ),
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (value) {
                        _authData['email'] = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value!;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      ElevatedButton(
                        child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        ),
                        onPressed: _submit,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(15.0)),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary)),
                      ),
                    TextButton(
                      child: Text(
                        _authMode == AuthMode.Login
                            ? 'Create new account'
                            : 'Have an account? Login',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: _isLoading ? null : _switchAuthMode,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
