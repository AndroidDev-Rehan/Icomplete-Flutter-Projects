import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Widgets/single_chat_head.dart';
import 'package:my_chat_app/Widgets/single_message.dart';
import 'package:my_chat_app/screens/current_users_list_screen.dart';
import 'package:provider/provider.dart';

class ConversationsListScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("My Chat App"),
          ),

          body: Consumer<SingleUserAllConversations>(
            builder: (context,singleUserAllConversations,child) {
              return ListView.builder(
                  itemCount: singleUserAllConversations.allChatRooms.length,
                  //TODO: Null check on last message
                  itemBuilder: (context,index) {
                    AppUser? otherAppUser;
                    if(singleUserAllConversations
                        .allChatRooms[index].users[0].uid==FirebaseAuth.instance.currentUser!.uid)
                      {
                        otherAppUser = singleUserAllConversations
                            .allChatRooms[index].users[1];
                      }
                    else{
                      otherAppUser = singleUserAllConversations
                          .allChatRooms[index].users[0];
                    }

                    return SingleChatHead(
                      otherUser: otherAppUser,
                      msg: singleUserAllConversations
                          .allChatRooms[index].lastMsg!);
                });
            }
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.message),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CurrentUsersList(),
                ),
              );
            },
          ),
        );
    //   }
    // );
  }
}
