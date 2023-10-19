import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final Message message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
              color: isMe ? Colors.green : Colors.blue,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(message.content,
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                timeago.format(message.time),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
}
