import 'package:flutter/material.dart';

//msgDate is actually date + time of message

class Message{
  final String text;
  final DateTime msgDate;
  final String authorId;

  Message({required this.text, required this.msgDate,required this.authorId});

  Map<String,dynamic> toMap(){
    return {
      'text' : text,
      //TODO msgDate.toString
      'msgDate' : msgDate.toString(),
      'authorId' : authorId
    };
  }

  factory Message.fromMap(Map<String,dynamic> map){
    return Message(
        text: map['text'],
        msgDate: DateTime.parse(map['msgDate']),
        authorId: map['authorId']
    );
  }

}