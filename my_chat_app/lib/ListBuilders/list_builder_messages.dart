import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/chat_room.dart';
import 'package:my_chat_app/Widgets/single_message.dart';

//This widget will provide listView of single messages for chat room screen

class MessagesList extends StatefulWidget {
  final ChatRoom? chatRoom;

  const MessagesList({required this.chatRoom});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return (widget.chatRoom==null)?
        Center(
          child: Text(
            "No messages to show here."
          ),
        ):
    ListView.builder(
        itemCount: widget.chatRoom!.messageList.length,
        itemBuilder: (context, index) =>
            SingleMessage(msg: widget.chatRoom!.messageList[index]));
  }
}
