import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userName': userData['userName'],
      'userId': user.uid,
      'profileImage': userData['profileImage']
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
        children: <Widget>[
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Send a message...',
              ),
              onChanged: (ch) {
                _enteredMessage = ch;
              },
              autofocus: true,
              onTap: () => _enteredMessage = '',
            ),
          ),
          IconButton(
              autofocus: true,
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: () {
                setState(() {
                  _enteredMessage.trim().isEmpty ? null : _sendMessage();
                });
              }),
        ],
      ),
    );
  }
}
