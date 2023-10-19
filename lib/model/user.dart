
class Users{
  String uid;
  String name;
  String imgUrl;
  String email;

  DateTime lastActive;


  Users({
    required this.name,
    required this.uid,
    required this.imgUrl,
    required this.email,
    required this.lastActive
  });

  Map<String,dynamic> toJson(){
    return {
      "name" : name,
      "email" : email,
      "imgUrl" : imgUrl,
      "uid" : uid,
      "lastActive" : DateTime.now()
    };
  }
  factory Users.fromJson(Map<String,dynamic> json) =>
      Users(
          name: json["name"],
          uid: json["uid"] ,
          imgUrl: json["imgUrl"],
          email: json["email"],
          lastActive: json["lastActive"].toDate());
}