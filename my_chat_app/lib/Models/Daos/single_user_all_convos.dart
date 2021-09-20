import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/chat_head.dart';
import 'package:my_chat_app/Models/message.dart';

import '../app_user.dart';
import 'chat_room.dart';
// import 'package:collection/collection.dart';

class SingleUserAllConversations extends ChangeNotifier{
  List<ChatRoom> allChatRooms = [];


  SingleUserAllConversations();


  fillList() async{
    final currUserId = FirebaseAuth.instance.currentUser!.uid;

    //TODO : Order by last message
    final appUser = await UserDao().returnAppUser(currUserId);
    final collection = await FirebaseFirestore.instance.collection('AllChatRooms').where('users',arrayContains: appUser.toMap()).get();

    allChatRooms = collection.docs.map(
            (document) => ChatRoom.fromMap(document.data())
    ).toList();
  }

  SingleUserAllConversations._create();

  static Future<SingleUserAllConversations> create () async {
    final singleUserAllConvos = SingleUserAllConversations._create();
    await singleUserAllConvos.fillList();
    return singleUserAllConvos;
  }

  addMessageToChatRoom(Message msg, ChatRoom chatRoom) async {

    // Function eq = const ListEquality().equals;

    //TODO: add notifyListeners

    for (int i = 0; i < allChatRooms.length; i++) {

      if (compareAppUsersList(allChatRooms[i].users,chatRoom.users))

      {
        print("Message List of allChatRoom[i]: ");
        for(int j = 0; j< allChatRooms[i].messageList.length; j++)
          {
            print(allChatRooms[i].messageList[j].text);
          }
        print("Adding message!");
        allChatRooms[i].messageList.add(msg);
        print("Added Message!");
        print("Message List :\n");
        for(int j = 0; j< allChatRooms[i].messageList.length; j++)
        {
          print(allChatRooms[i].messageList[j].text);
        }
        allChatRooms[i].lastMsg = msg;

        print("setting tempChatRoom equal to allChatRooms[i]");
        final ChatRoom tempChatRoom = ChatRoom(users: allChatRooms[i].users, messageList: allChatRooms[i].messageList, lastMsg: allChatRooms[i].lastMsg);
        print("Message List of tempChatROOM");
        for(int j = 0; j< tempChatRoom.messageList.length; j++)
        {
          print(allChatRooms[i].messageList[j].text);
        }
        final docId = "${tempChatRoom.users[0].uid}-${tempChatRoom.users[1].uid}";

        await FirebaseFirestore.instance
            .collection('AllChatRooms')
            .doc(docId)
            .set(tempChatRoom.toMap());
      }

    }
  }

  bool compareAppUsersList(List<AppUser> a, List<AppUser> b){
    if (a.length!=b.length){
      return false;
    }
    else{
      for(int i=0; i<a.length; i++){
        if((a[i].userName!=b[i].userName) || (a[i].uid!=b[i].uid) || (a[i].imgUrl!=b[i].imgUrl))
          {
            return false;
          }
      }
    }
    return true;
  }


//  if chatRoom Exists Than add Message to ChatRoom and return true else return false
  bool chatRoomExistOrNot (List<AppUser> users){

//    Function eq = const ListEquality().equals;

    print("List of Users Recieved are:");
    for (int i = 0;i < users.length; i++)
      print("$i : ${users[i].userName}");

    for (int i=0; i<allChatRooms.length;i++)
    {
      if(compareAppUsersList(allChatRooms[i].users,users))
      {
        return true;
      }
    }
    print("\n\nNo CHAT ROOM MATCHED!!");
    return false;
  }

  ChatRoom? returnChatRoom (List<AppUser> users)
  {
//    Function eq = const ListEquality().equals;
    for (int i=0; i<allChatRooms.length;i++)
      {
        if(compareAppUsersList(allChatRooms[i].users,users))
          {
            return allChatRooms[i];
          }
      }
  }

  addChatRoom(ChatRoom chatRoom) async{
    final docId = "${chatRoom.users[0].uid}-${chatRoom.users[1].uid}";
    allChatRooms.insert(0, chatRoom);
    print("Adding New Chat Room!!!");
    await FirebaseFirestore.instance.collection('AllChatRooms').doc(docId).set(chatRoom.toMap());
  }



}