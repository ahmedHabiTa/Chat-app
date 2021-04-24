import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'Sent at': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage' : userData['image_url']
    });
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                autocorrect: true,
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            controller: _controller,
            decoration: InputDecoration(hintText: 'Send a message ....'),
            onChanged: (val) {
              setState(() {
                _enteredMessage = val;
              });
            },
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey,
              icon: Icon(Icons.send),
              onPressed: _enteredMessage.trim().isEmpty ? null: _sendMessage)
        ],
      ),
    );
  }
}
