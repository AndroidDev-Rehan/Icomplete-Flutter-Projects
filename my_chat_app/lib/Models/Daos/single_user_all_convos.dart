import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/chat_head.dart';
import 'package:my_chat_app/Models/message.dart';

import '../app_user.dart';
import 'chat_room.dart';

class SingleUserAllConversations extends ChangeNotifier{
  List<ChatRoom> allChatRooms = [];



  fillList() async{
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    //TODO : Order by last message
    final collection = await FirebaseFirestore.instance.collection('AllChatRooms').doc(currUserId).collection('ChatRooms').get();

    final appUser = await UserDao().returnAppUser(currUserId);

   // final collection = await FirebaseFirestore.instance.collection('AllChatRooms').where('users',arrayContains: appUser.toMap()).get();

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

    final tempChatR1 = ChatRoom(user2: chatRoom.user1, user1: chatRoom.user2, messageList: chatRoom.messageList, lastMsg: chatRoom.lastMsg );

    //TODO: add notifyListeners

    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    for (int i = 0; i < allChatRooms.length; i++) {
      if (allChatRooms[i].user2 == chatRoom.user2) {
        allChatRooms[i].messageList.add(msg);
        final ChatRoom tempChatRoom = allChatRooms[i];
        tempChatRoom.lastMsg = msg;
        await FirebaseFirestore.instance
            .collection('AllUsersConversations')
            .doc(currUserId)
            .collection('ChatRooms')
            .doc(chatRoom.user2.uid)
            .set(tempChatRoom.toMap());


        await FirebaseFirestore.instance
            .collection('AllUsersConversations')
            .doc(chatRoom.user2.uid)
            .collection('ChatRooms')
            .doc(currUserId)
            .set(tempChatR1.toMap());
      }
    }
  }

  // String docIdGenerator(){
  //   final currUserId = FirebaseAuth.instance.currentUser!.uid;
  //   return
  // }


  //if chatRoom Exists Than add Message to ChatRoom and return true else return false
  bool chatRoomExistOrNot (String chatRoomId){
    for (int i=0; i<allChatRooms.length;i++)
    {
      if(allChatRooms[i].user2.uid==chatRoomId)
      {
        return true;
      }
    }
    return false;
  }

  ChatRoom? returnChatRoom (String chatRoomId)
  {
    for (int i=0; i<allChatRooms.length;i++)
      {
        if(allChatRooms[i].user2.uid==chatRoomId)
          {
            return allChatRooms[i];
          }
      }
  }

  addChatRoom(ChatRoom chatRoom) async{
     final oppositeChatRoom = ChatRoom(lastMsg: chatRoom.lastMsg,messageList: chatRoom.messageList,user1: chatRoom.user1,user2: chatRoom.user2);
     final temp = oppositeChatRoom.user2; //rehan
     oppositeChatRoom.user2 = oppositeChatRoom.user1; //sibi
     oppositeChatRoom.user1 = temp;                   //rehan
     final currUserId = FirebaseAuth.instance.currentUser!.uid;
     // allChatRooms.insert(0, chatRoom);
    await FirebaseFirestore.instance.collection('AllUsersConversations').doc(currUserId).collection('ChatRooms').doc(chatRoom.user2.uid).set(chatRoom.toMap());
    await FirebaseFirestore.instance.collection('AllUsersConversations').doc(chatRoom.user2.uid).collection('ChatRooms').doc(currUserId).set(oppositeChatRoom.toMap());
     print("chatRoom.user2.uid is ${chatRoom.user2.uid}");
  }



}