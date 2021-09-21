import 'package:flutter/material.dart';

//msgDate is actually date + time of message

class Message{
  final String text;
  final int msgDateTimeInMilis;
  final String authorId;

  Message({required this.text, required this.msgDateTimeInMilis,required this.authorId});

  Map<String,dynamic> toMap(){
    return {
      'text' : text,
      //TODO msgDate.toString
      'msgDateTimeInMilis' : msgDateTimeInMilis,
      'authorId' : authorId
    };
  }

  factory Message.fromMap(Map<String,dynamic> map){
    return Message(
        text: map['text'],
        msgDateTimeInMilis: map['msgDateTimeInMilis'],
        authorId: map['authorId']
    );
  }

}