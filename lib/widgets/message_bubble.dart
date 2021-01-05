import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String profileImage;
  final bool isMe;

  MessageBubble(this.message, this.userName, this.profileImage, this.isMe,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              !isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: !isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMe ? Radius.circular(0) : Radius.circular(14),
                  bottomRight: !isMe ? Radius.circular(0) : Radius.circular(14),
                ),
              ),
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: !isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline6.color,
                    ),
                    textAlign: !isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? 100 : null,
          right: !isMe ? 100 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(profileImage),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
