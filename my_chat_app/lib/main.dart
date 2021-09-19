
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat_app/ListBuilders/list_builder_chat_heads.dart';
import 'package:my_chat_app/ListBuilders/list_builder_messages.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Widgets/single_message.dart';
import 'package:my_chat_app/screens/coversation_list_screen.dart';
import 'package:my_chat_app/screens/home_screen.dart';
import 'package:my_chat_app/utils/routes.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async{

  // remove these 2 lines afterwards and make main method non async too
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final suac = await SingleUserAllConversations.create();

  runApp(
    ChangeNotifierProvider<SingleUserAllConversations>.value(
      value: suac,
      child: MyApp(),
    )
  );


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<bool> checkLoggedInStatus() async{
    final db = FirebaseFirestore.instance;
    final User? currUser = FirebaseAuth.instance.currentUser;
    if(currUser==null) {
      return false;
    }
    else if(!(await checkIfDocExists(currUser.uid))){
      return false;
    }
    return true;
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: Icons.chat,
        screenFunction: ()async{
          await Future.delayed(Duration(seconds: 3));
          return SafeArea(
              child: (
                  await checkLoggedInStatus())? ConversationsListScreen()
              : MyHomePage(title: 'Registration Screen')
          );
        },
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      ),

      //Comment the routes afterwords
      // initialRoute: MyRoutes.chatHeadsList,
      // routes: {
      //   MyRoutes.msgDemo : (context) => MessagesList(),
      //   MyRoutes.chatHeadsList : (context) => ChatHeadsList()
      // },

    );
  }
}

// class EnterPhoneNumberScreen extends StatefulWidget {
//   const EnterPhoneNumberScreen({Key? key}) : super(key: key);
//
//   @override
//   _EnterPhoneNumberScreenState createState() => _EnterPhoneNumberScreenState();
// }
//
// class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Enter Phone Number"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextFormField(
//             decoration: InputDecoration(
//               hintText: "Enter Your Mobile Number",
//               labelText: "Mobile Number"
//             ),
//           ),
//           ElevatedButton(
//               onPressed: (){},
//               child: Text("Submit")
//           )
//         ],
//       ),
//     );
//   }
// }



