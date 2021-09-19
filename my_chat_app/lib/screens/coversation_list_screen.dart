import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Widgets/single_chat_head.dart';
import 'package:my_chat_app/Widgets/single_message.dart';
import 'package:my_chat_app/screens/current_users_list_screen.dart';
import 'package:provider/provider.dart';

class ConversationsListScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: initSuac(),
    //   builder: (context, snapshot) {
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
                  itemBuilder: (context,index) => SingleChatHead(otherUser: singleUserAllConversations.allChatRooms[index].user2 , msg: singleUserAllConversations.allChatRooms[index].lastMsg!)
              );
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
