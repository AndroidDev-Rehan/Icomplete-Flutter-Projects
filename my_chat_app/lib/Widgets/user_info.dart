import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_chat_app/Models/Daos/single_user_all_convos.dart';
import 'package:my_chat_app/Models/Daos/user_dao.dart';
import 'package:my_chat_app/Models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_chat_app/screens/coversation_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserInfoDetails extends StatefulWidget {

  @override
  State<UserInfoDetails> createState() => _UserInfoDetailsState();
}

class _UserInfoDetailsState extends State<UserInfoDetails> {

  XFile? _xFileImage;
  final _formKey = GlobalKey<FormState>();
  String uName = '';
  bool signingIn = false;

  moveAhead(BuildContext context) async{

    print("We are inside move ahead!!");

    if(_formKey.currentState!.validate()){
      if(checkImgHolder(context)) {
        final imgUrl = await uploadImageToFirebaseAndReturnUrl(context);
        AppUser appUser = AppUser(userName: uName, uid: FirebaseAuth.instance.currentUser!.uid, imgUrl: imgUrl);
        await UserDao().insertUser(appUser);
//        await Provider.of<SingleUserAllConversations>(context,listen: false).fillList();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ConversationsListScreen(
            ),
          ),
        );
        print("function move ahead ended!");

      }
    }
  }

  Future<String> uploadImageToFirebaseAndReturnUrl(BuildContext context) async {

    File imgFile = File(_xFileImage!.path);

    FirebaseStorage storage = FirebaseStorage.instance;

    final ref = storage.ref(Uuid().v4().toString());

//    await storage.ref(_xFileImage!.path).putFile(imgFile);
//    return await storage.ref(_xFileImage!.path).getDownloadURL();

    await ref.putFile(imgFile);
    return await ref.getDownloadURL();

  }

  bool checkImgHolder(BuildContext context){
    if(_xFileImage!=null) {
      return true;
    }
    else {
      showPlatformDialog(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: Text("No profile picture found"),
          content:
          Text(
            "You need to set your display picture. You cant leave it empty!\n\nTap on the picture to change it.",
            style: TextStyle(
              color: Colors.red
            ),
          ),
          actions: <Widget>[
            BasicDialogAction(
              title: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );

      return false;
    }
  }

  ImagePicker picker = ImagePicker();

  _imgFromCamera() async{
    XFile? image = await  picker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    if(image!=null)
    {
      setState(() {
        _xFileImage = image;
      });
    }

  }

  _imgFromGallery() async {
    XFile? image = await  picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if(image!=null)
    {
      setState(() {
        _xFileImage = image;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery '),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return (signingIn)?
        Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ):
      ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Set your name and profile picture which will be visible to others. Click on picture avatar to change it.",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 15
                  ),
                ),
              ),
              SizedBox(height: 10,),

              InkWell(

                  child: (_xFileImage==null)?
                  Image.asset(
                'assets/images/img.png',height: 200,width: 200,fit: BoxFit.cover,
                  ) :
                  Container(
                    height: 200,width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(File(_xFileImage!.path),),
                        fit: BoxFit.cover
                    ),
                      color: Colors.deepPurple,

                    ),
                  ),
                onTap: (){
                    _showPicker(context);
                },

              )
              ,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter Your name here",
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (value){
                      uName = value;
                    },
                  ),

                ),
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: ()async{
                    print("setting state of signingIn to true");
                    setState(() {
                      signingIn = true;
                    });
                    print("calling move ahead function");
                    await moveAhead(context);
                    print("setting state of signingIn to false");
                    setState(() {
                      signingIn = false;
                    });
                    print("on click function ended");
                    },
                  child: Text("Lets Go",
//                  textScaleFactor: 1.5,
                  style: TextStyle(
                  ),
                  ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


//NULL CHECK ON LINE 25