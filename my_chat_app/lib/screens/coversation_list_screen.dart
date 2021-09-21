import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/chat_room.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:my_chat_app/Widgets/single_chat_head.dart';
import 'package:my_chat_app/Widgets/single_message.dart';
import 'package:my_chat_app/screens/current_users_list_screen.dart';
import 'package:provider/provider.dart';

class ConversationsListScreen extends StatelessWidget {

  late final AppUser appUser;

  Future<void> setAppUser()async{
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    appUser = await UserDao().returnAppUser(currUserId);
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("My Chat App"),
          ),

          body: FutureBuilder(
            future: setAppUser(),
            builder: (context,snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('AllChatRooms').where('users',arrayContains: appUser.toMap()).orderBy('lastMsgDateTimeMilis',descending: true).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
                  if(snapshot.connectionState==ConnectionState.active  || snapshot.connectionState==ConnectionState.done)
                  {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {

                          // final DocumentSnapshot<Map<String,dynamic>> documentSS = snapshot.data!.docs[index];
                          // final Map<String,dynamic> map = documentSS.data()!;
                          final ChatRoom tempChatRoom = ChatRoom.fromMap(snapshot.data!.docs[index].data());
                          List<AppUser> tempUsers = tempChatRoom.users;

                          // List<AppUser>.generate(2, (ind) => snapshot.data!.docs[index].get('users'))

                          AppUser? otherAppUser;

                          if(tempUsers[0].uid == FirebaseAuth.instance.currentUser!.uid)
                            {
                              otherAppUser = tempUsers[1];
                            }
                          else{
                            otherAppUser = tempUsers[0];
                          }


                          return SingleChatHead(
                              otherUser: otherAppUser,
                              msg: tempChatRoom.lastMsg!,
                              // msg: Message.fromMap(snapshot.data!.docs[index].get('lastMsg')),
                          );
                        });
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
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
