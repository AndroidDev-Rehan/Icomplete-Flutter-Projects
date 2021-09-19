//chat room is a conversation of 2 users
//chat room is a list of messages of 2 users that they sent to each other

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_user.dart';
import '../message.dart';

class ChatRoom{


  // List<AppUser> users;
  AppUser user1;
  AppUser user2;
  Message? lastMsg;
  List<Message> messageList;



  ChatRoom({required this.user1,required this.user2,required this.messageList,required this.lastMsg});

  List<Message> get getMessageList{
    return messageList;
  }

  factory ChatRoom.fromMap(Map<String,dynamic> map){
    return ChatRoom(

//        users: List<AppUser>.generate(map['users'.length], (index) => AppUser.fromMap(map[index])),
        user1: AppUser.fromMap(map['user1']),
        user2: AppUser.fromMap(map['user2']),
        messageList: List<Message>.generate(map['messageList'].length, (index) => Message.fromMap(map['messageList'][index]) ),
        lastMsg: Message.fromMap(map['lastMsg'])
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'user1' : user1.toMap(),
      'user2' : user2.toMap(),
      //TODO, NULL CHECK
      'lastMsg'     : (lastMsg==null)? lastMsg : lastMsg!.toMap(),
      'messageList' : messageList.map((msg) => msg.toMap()).toList()
    };
  }

}

