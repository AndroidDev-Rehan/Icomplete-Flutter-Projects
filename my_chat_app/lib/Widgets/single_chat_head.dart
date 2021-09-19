import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:my_chat_app/screens/chat_room_screen.dart';

class SingleChatHead extends StatefulWidget {
  final AppUser otherUser;
  final Message msg;

  const SingleChatHead({required this.otherUser, required this.msg});

  @override
  _SingleChatHeadState createState() => _SingleChatHeadState();
}

class _SingleChatHeadState extends State<SingleChatHead> {
  bool yes = false;

  @override
  Widget build(BuildContext context) {
    return yes
        ? Container(
            color: Colors.brown,
            child: Row(
              children: [
                FlutterLogo(),
                Expanded(
                  child: Text(
                    "Text 1 will be shown hereeeeeee eeeeeeeeeeeeeeeeeeeeeeeee",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        : InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(widget.otherUser.imgUrl),
                          fit: BoxFit.cover),
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.otherUser.userName,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Text(
                            widget.msg.text,
                            style: TextStyle(color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(user2: widget.otherUser),
                ),
              );
            } ,
          );
  }
}
