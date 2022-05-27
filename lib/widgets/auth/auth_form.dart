import 'package:chat_app/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final void Function(String email, String pass, String userName, File image,
      bool isLogin, BuildContext ctx) _submitAuthForm;
  bool isLoading;

  AuthForm(this._submitAuthForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please pick an image!',
          ),
          backgroundColor: Theme
              .of(context)
              .errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      // print(_userEmail);
      // print(_userName);
      // print(_userPassword);

      widget._submitAuthForm(
        _userEmail.trim(),
        _userPassword,
        _userName,
        _userImageFile,
        _isLogin,
        context,
      );
      //use values to send auth req
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          height: _isLogin ? 300 : 470,
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, //as much as needed
                    children: <Widget>[
                      if (!_isLogin) UserImagePicker(_pickedImage),
                      TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@'))
                            return 'Please enter a valid email address!';
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email address'),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          autocorrect: true,
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value.isEmpty || value.length < 4)
                              return 'Please enter at least 4 characters';
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Username'),
                          onSaved: (value) {
                            _userName = value;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7)
                            return 'Password must be at least 7 characters long';
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      SizedBox(height: 12),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        RaisedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                      if (!widget.isLoading)
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'),
                          textColor: Theme
                              .of(context)
                              .accentColor,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
