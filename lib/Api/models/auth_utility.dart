import 'dart:convert';

import 'package:module_11_live_class/Api/models/LoginResponseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authutility{
Authutility._();
static LoginResponseModel userInfo = LoginResponseModel();

 static Future<void> saveUserInfo(LoginResponseModel model)async{
    SharedPreferences _sharedPrefs =await SharedPreferences.getInstance();
   await _sharedPrefs.setString('user-data', jsonEncode (model.toJson()));
       userInfo = model;
  }

static Future<LoginResponseModel> getUserInfo()async{
    SharedPreferences _sharedPrefs =await SharedPreferences.getInstance();
  String value = _sharedPrefs.getString('user-data', )!;
  return LoginResponseModel.fromJson(jsonDecode(value));

  }

static Future<void>clearUserInfo()async{
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
   await _sharedPrefs.clear();
  }
static Future<bool>checkIfLoggedIn() async {
    SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
  bool isLogin = _sharedPrefs.containsKey('user-data');
  if (isLogin) {
   userInfo = await getUserInfo();
  }
  return isLogin;
  }
static Future<void> updateUserInfo(Data userData) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  userInfo.data = userData;
  await sharedPrefs.setString('user-data', jsonEncode(userInfo.toJson()));
}
}
