import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_chat_app/Widgets/user_info.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _otp = TextEditingController();

//  User? currUser = FirebaseAuth.instance.currentUser;
  bool isLoggedIn = false;
  bool otpSent = false;
  late String uid;
  late String _verificationId;

  signOut()async{
    await FirebaseAuth.instance.signOut();
  }

  void _verifyOTP() async {
    // we know that _verificationId is not empty
    final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otp.text);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        setState(() {
          isLoggedIn = true;
          uid = FirebaseAuth.instance.currentUser!.uid;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: validatePhoneNumber(_phoneNumber.text),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    setState(() {
      otpSent = true;
    });
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    // setState(() {
    //   _verificationId = verificationId;
    //   otpSent = true;
    // });
  }

  void codeSent(String verificationId, [int? a]) {
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });
  }

  void verificationFailed(FirebaseAuthException exception) {
    Fluttertoast.showToast(msg: "There is some error.Please Try again Later");
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedIn = true;
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    } else {
      print("Failed to Sign In");
    }
  }

  String validatePhoneNumber(String phoneNo){
    String correctPhNo = phoneNo;
    if (phoneNo.startsWith("+92"))
      return phoneNo;
    else if(phoneNo.startsWith("92")){
      return "+$correctPhNo";
    }
    else if (phoneNo.startsWith('0')){
     return correctPhNo.replaceFirst('0', '+92');
    }
    return phoneNo;
  }

  // String provideUid()async{
  //   return "js";
  // }

  @override
  void initState(){
    super.initState();
    if (FirebaseAuth.instance.currentUser == null){
      isLoggedIn = false;
    }
    else{
      isLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: isLoggedIn ? [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            setState(() {
              isLoggedIn = false;
              otpSent = false;
            });
          },
              icon: Icon(Icons.logout)
          )
        ]: [],
      ),
      body: new Center(
        child: isLoggedIn
            ? UserInfoDetails()
            : otpSent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _otp,
                        decoration: InputDecoration(
                          hintText: "Enter your OTP",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _verifyOTP,
                        child: Text("Sign In"),
                      ),
                    ],
                  )
                : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color : Colors.green,
                      child: Text(
                          "MyChat App needs to be registered on a mobile number. Please enter a valid one :)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextField(
                              controller: _phoneNumber,
                              decoration: InputDecoration(
                                hintText: "Enter your phone number",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _sendOTP,
                              child: Text("Send OTP"),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
      ),
    );
  }
}
