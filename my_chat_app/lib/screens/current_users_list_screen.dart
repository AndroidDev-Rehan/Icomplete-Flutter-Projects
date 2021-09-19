import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/Daos/all_users.dart';
import 'package:my_chat_app/Models/app_user.dart';

import 'chat_room_screen.dart';

class CurrentUsersList extends StatelessWidget {

  final List<AppUser> appUserList = [];

  Future<void> fillList()async{
    final allUsers = await AllUsers.create();
    final usersList = allUsers.getList();
    appUserList.addAll(usersList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current MyChat App Users"),
      ),
      body: FutureBuilder(
        future: fillList(),
        builder: (context,snapshot) {
          return ListView.builder(
            itemCount: appUserList.length,
            itemBuilder: (BuildContext context, int index) {
              return UserTile(appUser: appUserList[index]);
            },
          );
        }
      ),
    );
  }
}

class UserTile extends StatelessWidget {

  final AppUser appUser;
  UserTile({required this.appUser});

  @override
  Widget build(BuildContext context) {
    return ((appUser.uid==FirebaseAuth.instance.currentUser!.uid))?
        SizedBox(height: 0,) :
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
            appUser.userName,
          style: TextStyle(
            fontSize: 18
          ),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(appUser.imgUrl),
                fit: BoxFit.cover
            ),
            color: Colors.deepPurple,
          ),
        ),
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(user2: appUser,),
            ),
          );
          print("So when clicked on user in users list, ${appUser.userName} is passed as user2 to chat screen.");
        },
      ),
    );
  }
}
