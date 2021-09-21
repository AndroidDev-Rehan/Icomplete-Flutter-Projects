import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat_app/Models/message.dart';
import '../app_user.dart';
import 'chat_room.dart';

class SingleUserAllConversations  {

  addMessageToChatRoom(Message msg, String chatRoomId,List<AppUser> users) async {

    final DocumentSnapshot<Map<String,dynamic>> doc = await FirebaseFirestore.instance.collection('AllChatRooms').doc(chatRoomId).get();

    if(doc.exists)
      {
        final ChatRoom newDoc = ChatRoom.fromMap(doc.data()!);
        newDoc.messageList.add(msg);
        newDoc.lastMsg = msg;
        newDoc.lastMsgDateTimeMilis = msg.msgDateTimeInMilis;
        await FirebaseFirestore.instance.collection('AllChatRooms').doc(chatRoomId).set(newDoc.toMap());
      }
    else{
      final ChatRoom newChatRoom = ChatRoom(users: users, messageList: [msg], lastMsg: msg, lastMsgDateTimeMilis: msg.msgDateTimeInMilis);
      await FirebaseFirestore.instance.collection('AllChatRooms').doc(chatRoomId).set(newChatRoom.toMap());
    }
  }

}






