import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _msgController=new TextEditingController();

  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final _user=FirebaseAuth.instance.currentUser;
    // TODO: get the userinfo and store username in map below
    if(_user==null)
      {
        return;
      }
    final userData = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage.trim(),
      'createdAt': Timestamp.now(),
      'userId':_user.uid,
      'username':userData['username'],
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: InputDecoration(
                labelText: 'Send Message',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _enteredMessage
                  .trim()
                  .isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}
