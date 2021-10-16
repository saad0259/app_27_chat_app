import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Dummy Appbar'),),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('/chats/tvNf8Zik8nbr7BbNxVlM/messages')
                .snapshots(),
            builder: (ctx, streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final documents= streamSnapshot.data?.docs ?? null;
              return ListView.builder(
                itemCount: documents?.length ?? 0,
                itemBuilder: (ctx, index) => Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(documents?[index]['text']?? 'No data found'),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('/chats/tvNf8Zik8nbr7BbNxVlM/messages').add({
              'text':'Added by button click!',
            });

          },
        ),
      ),
    );
  }
}
