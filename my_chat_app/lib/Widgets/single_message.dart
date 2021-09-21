import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Models/message.dart';
import 'package:intl/intl.dart';

class SingleMessage extends StatelessWidget {

  final Message msg;
  SingleMessage({required this.msg});

  bool ownMsg(){
    if (msg.authorId==FirebaseAuth.instance.currentUser!.uid)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ownMessage = ownMsg();
    return Align(
      alignment: ownMessage? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: (ownMessage)?
        const EdgeInsets.fromLTRB(40, 0, 0, 0):
        const EdgeInsets.fromLTRB(0, 0, 40, 0),
        child: Card(
          color: ownMessage?
          Colors.red :
          Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: !ownMessage? Colors.black : Colors.white,
                      fontSize: 15
                    ),
//              textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(msg.msgDateTimeInMilis)),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),

                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black,
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
