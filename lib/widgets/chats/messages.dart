import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data?.docs ?? null;

                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs?.length ?? 0,
                  itemBuilder: (ctx, index) => MessageBubble(
                    chatDocs![index]['username'],
                    chatDocs[index]['text'] ?? 'No data found',
                    chatDocs[index]['userId'] == snapshot.data!.uid,
                  key: ValueKey(chatDocs[index].id),
                  ),
                );
              });
        });
  }
}
