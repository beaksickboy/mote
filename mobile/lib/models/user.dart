class User {
  String username;
  String email;
  String phone;
  String token;

  User(userInfo) {
    this.username = userInfo["name"];
    this.email = userInfo["email"];
    this.phone = userInfo["phone"];
    this.token = userInfo["token"];
  }

  User.fromJson(Map<String, dynamic> parsedJson) {
    this.username = parsedJson["name"];
    this.email = parsedJson["email"];
    this.phone = parsedJson["phone"];
    this.token = parsedJson["token"];
  }
}