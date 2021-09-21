//chat room is a conversation of 2 users
//chat room is a list of messages of 2 users that they sent to each other

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../app_user.dart';
import '../message.dart';

class ChatRoom{


  List<AppUser> users;
  Message? lastMsg;
  List<Message> messageList;
  int lastMsgDateTimeMilis;



  ChatRoom({required this.users,required this.messageList,required this.lastMsg,required this.lastMsgDateTimeMilis});

  List<Message> get getMessageList{
    return messageList;
  }

  factory ChatRoom.fromMap(Map<String,dynamic> map){
    return ChatRoom(
        users:       List<AppUser>.generate(map['users'].length, (index) => AppUser.fromMap(map["users"][index])),
        messageList: List<Message>.generate(map['messageList'].length, (index) => Message.fromMap(map['messageList'][index]) ),
        lastMsg: Message.fromMap(map['lastMsg']),
      lastMsgDateTimeMilis: map['lastMsgDateTimeMilis'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'users' : List.generate(users.length, (index) => users[index].toMap()),
      //TODO, NULL CHECK
      'lastMsg'     : (lastMsg==null)? lastMsg : lastMsg!.toMap(),
      'messageList' : messageList.map((msg) => msg.toMap()).toList(),
      'lastMsgDateTimeMilis' : lastMsgDateTimeMilis
    };
  }

}

