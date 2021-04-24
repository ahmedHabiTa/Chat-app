import 'package:chat_app/widgets/user_iamge_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class AuthForm extends StatefulWidget {
  final void Function(String email,String password,String username, bool isLogin,BuildContext ctx,File image) submitFunc;
  final bool _isLoading ;

  AuthForm(this.submitFunc,this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {



  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  File _userImageFile ;
  void _pickedImage(File pickedImage){
    _userImageFile = pickedImage ;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(!_isLogin && _userImageFile == null){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 2),
      ));
      return ;
    }

    if (isValid) {
      _formKey.currentState.save();
     widget.submitFunc(
         _email.trim(),_password.trim(),_username.trim(),_isLogin,context,_userImageFile
     );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(!_isLogin)
                  UserImagePicker(_pickedImage),
                _buildTextFormField(
                  'email',
                  (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  (val) => _email = val,
                  'Email Address',

                ),
                if (!_isLogin)
                  _buildTextFormField('username', (val) {
                    if (val.isEmpty || val.length < 4) {
                      return 'Please enter at least 4 characters';
                    }
                    return null;
                  }, (val) => _username = val, 'Username'),
                _buildTextFormField('password', (val){
                  if(val.isEmpty || val.length < 8){
                    return ' Password must be at least 8 characters';
                  }
                  return null ;
                }, (val) => _password = val, 'Password'),
                SizedBox(height: 12,),
                if(widget._isLoading)
                  CircularProgressIndicator(),
                if(!widget._isLoading)
                RaisedButton(onPressed: _submit,child: Text(_isLogin? 'Login' : 'Sign Up'),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin ? 'Create new Account ?' : ' Already have an Account ?',style: TextStyle(color: Colors.black),),
                    FlatButton(child: Text(_isLogin ? 'Register Now' : 'Login now',style: TextStyle(color: Theme.of(context).primaryColor),),
                    onPressed: (){
                      setState(() {
                        _isLogin = !_isLogin ;
                      });
                    },),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildTextFormField(
    String key, Function validator, Function onSaved, String labelText) {
  return TextFormField(

    key: ValueKey(key),
    validator: validator,
    onSaved: onSaved,
    decoration: InputDecoration(labelText: labelText),
  );
}
