import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: const EdgeInsets.all(8.0),
          child: Text('This works'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

          FirebaseFirestore.instance
              .collection('/chats/tvNf8Zik8nbr7BbNxVlM/messages')
              .snapshots()
              .listen((data) {
                data.docs.forEach((element) {
                  print(element['text']);
                });

          });
        },
      ),
    );
  }
}
