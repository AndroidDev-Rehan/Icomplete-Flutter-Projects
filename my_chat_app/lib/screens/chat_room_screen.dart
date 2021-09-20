import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/ListBuilders/list_builder_messages.dart';
import 'package:my_chat_app/Models/Daos/chat_room.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatelessWidget {
  final AppUser user2;

  ChatRoomScreen({required this.user2});

  final List<AppUser> users = [];

  Future<void> fillUsersList() async {
    final currUser = FirebaseAuth.instance.currentUser;
    final currAppUser = await UserDao().returnAppUser(currUser!.uid);

    if (currAppUser.uid.compareTo(user2.uid) == -1) {
//      users = [currAppUser,user2];
      users.insert(0, currAppUser);
      users.insert(1, user2);
    } else {
      users.insert(0, user2);
      users.insert(1, currAppUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "ChatRoom Screen has received ${user2.userName} as user2 and forwarding the exact same to Create Message");
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(user2.imgUrl), fit: BoxFit.cover),
              color: Colors.deepPurple,
            ),
          ),
        ),
        title: Text(user2.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: fillUsersList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Consumer<SingleUserAllConversations>(
                        builder: (context, singleUserAllConversations, child) {
                      return MessagesList(
                        chatRoom:
                            singleUserAllConversations.returnChatRoom(users),
                      );
                    });
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          ),
          CreateMsg(
            otherUser: user2,
          ),
        ],
      ),
      // bottomNavigationBar: CreateMsg(),
    );
  }
}

class CreateMsg extends StatelessWidget {
  final myController = TextEditingController();
  final AppUser otherUser;

  CreateMsg({required this.otherUser});

  @override
  Widget build(BuildContext context) {
    print("Create Message has received user2 as ${otherUser.userName}");
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
            child: TextFormField(
              controller: myController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
          child: InkWell(
            child: Icon(
              Icons.send_rounded,
              size: 35,
            ),
            onTap: () async {
              final currUser = FirebaseAuth.instance.currentUser;
              final DateTime msgDateTime = DateTime.now();
              if (myController.text != "") {
                final Message msg = Message(
                    authorId: currUser!.uid,
                    msgDate: msgDateTime,
                    text: myController.text);
                final currAppUser = await UserDao().returnAppUser(currUser.uid);
                List<AppUser> users = [];
                if (currAppUser.uid.compareTo(otherUser.uid) == -1) {
                  users = [currAppUser, otherUser];
                } else {
                  users = [otherUser, currAppUser];
                }

//                final docId = "${users[0].uid}-${users[1].uid}";

                if (Provider.of<SingleUserAllConversations>(context, listen: false).chatRoomExistOrNot(users))
                {
                  await Provider.of<SingleUserAllConversations>(context,listen: false).
                  addMessageToChatRoom(
                          msg,
                          Provider.of<SingleUserAllConversations>(context,
                                  listen: false)
                              .returnChatRoom(users)!);
                } else {
                  await Provider.of<SingleUserAllConversations>(context,
                          listen: false)
                      .addChatRoom(ChatRoom(
                          users: users, messageList: [msg], lastMsg: msg));
                }
                //TODO : NULL CHECK
                // final chatRoom = Provider.of<SingleUserAllConversations>(context,listen : false).returnChatRoom(appUser.uid);
                // Provider.of<SingleUserAllConversations>(context,listen : false).addMessageToChatRoom(msg, chatRoom );

                myController.text = "";
              }
            },
          ),
        )
      ],
    );
  }
}
