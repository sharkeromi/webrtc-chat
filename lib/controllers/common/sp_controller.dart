import 'package:shared_preferences/shared_preferences.dart';

const kBearerToken = 'kBearerToken';
const kRememberMe = "kRememberMe";
const kUserId = "kUserId";
const kUserName = "kUserName";
const kUserImage = "kUserImage";

class SpController {
  //* save Bearer Token
  Future<void> saveBearerToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kBearerToken, token.toString());
  }

  Future<String?> getBearerToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(kBearerToken);
  }

   //* on logout
  Future<void> onLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(kBearerToken);
  }

  //* Remember me status
  Future<void> saveRememberMe(value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(kRememberMe, value);
  }

  Future<bool?> getRememberMe() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(kRememberMe);
  }

  Future<void> saveUserId(id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(kUserId, id);
  }

  Future<int?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(kUserId);
  }

   //* save user name
  Future<void> saveUserName(name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kUserName, name.toString());
  }

  Future<String?> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(kUserName);
  }

   //* save user Image
  Future<void> saveUserImage(imageUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(kUserImage, imageUrl.toString());
  }

  Future<String?> getUserImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(kUserImage);
  }
  
}