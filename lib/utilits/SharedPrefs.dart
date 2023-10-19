
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  static SharedPreferences? _prefs;

  init() async {
    if(_prefs == null){
      _prefs = await SharedPreferences.getInstance();
    }
  }

  final String _user_name_key = "User_Name";
  final String _user_img_url_key = "User_Image_Url";

  String getUserName(){
    return _prefs?.getString(_user_name_key) ?? "Name";
  }

  String getImgUrl(){
    return _prefs?.getString(_user_img_url_key) ?? "https://firebasestorage.googleapis.com/v0/b/my-chat-fa34b.appspot.com/o/users_img%2FA3zdG848iydlZjZULkL6miaQAD03?alt=media&token=7cd722e7-3120-4aa8-aeb0-ff374273505e&_gl=1*1uc3uz2*_ga*MTgzMTcyMjU5Mi4xNjgwNTI2MzQ2*_ga_CW55HF8NVT*MTY5Njc1MjA3NC40MC4xLjE2OTY3NTIxMTAuMjQuMC4w";
  }

  Future<void> setUserName(String value) async{
    await _prefs?.setString(_user_name_key, value);
  }

  Future<void> setImgUrl(String value) async {
    await _prefs?.setString(_user_img_url_key, value);
  }
}