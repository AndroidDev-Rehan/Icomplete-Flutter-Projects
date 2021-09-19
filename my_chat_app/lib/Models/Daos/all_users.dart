import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat_app/Models/app_user.dart';

class AllUsers{
  List<AppUser> allUsers = [];

  fillUsersList() async{
    final db = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String,dynamic>> collection = await db.collection('users').get();
    allUsers = collection.docs.map(
            (doc) => AppUser.fromMap(doc.data())
    ).toList();
  }

  AllUsers._create();

  static Future<AllUsers> create() async {
    var allUsers = AllUsers._create();
    await allUsers.fillUsersList();
    return allUsers;
  }

  getList(){
    return allUsers;
  }


}