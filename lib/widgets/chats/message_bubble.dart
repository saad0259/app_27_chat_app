import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.username, this.imageUrl, this.message, this.isMe,
      {required this.key});

  final String message, username, imageUrl;
  final bool isMe;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft:
                      !isMe ? Radius.circular(0) : Radius.circular(12.0),
                  bottomRight:
                      isMe ? Radius.circular(0) : Radius.circular(12.0),
                ),
              ),
              width: 140.0,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -30,
          left: 120,
          child: CircleAvatar(
            // backgroundImage: NetworkImage(imageUrl),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
