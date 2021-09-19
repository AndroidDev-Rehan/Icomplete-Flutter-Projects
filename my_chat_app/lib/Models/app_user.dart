class AppUser{
  final String userName;
  final String imgUrl;
  final String uid;

  AppUser({required this.userName, required this.imgUrl, required this.uid});

  Map<String,String> toMap(){
    return {
      'userName' : userName,
      'imgUrl'   : imgUrl,
      'uid'      : uid,
    };
  }

  factory AppUser.fromMap(Map<String,dynamic> map){
    return AppUser(userName: map['userName'], imgUrl: map['imgUrl'], uid: map['uid']);
  }

}