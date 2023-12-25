import 'company.dart';

/**
 * This is the User class for temporary
 */
class User {
  int userId = 0;
  String username = "";
  String password = "";
  String userEmail = "";
  String userPosition = "";
  String userType = "";
  String userStatus = "Active";
  String adminId = "";
  Company? company;

  /**
   * constructor
   */
  User(this.userId, this.username, this.password, this.userEmail,
      this.userPosition, this.userType, this.userStatus, 
      this.company, this.adminId);

  /**
   * mapping to JSON body
   * for getting responses from JSON
   */
  User.fromJson(Map<String, dynamic> json):
    userId = json["userId"],
    username = json["username"],
    userEmail = json["userEmail"],
    password = json["userpassword"],
    userPosition = json["userPosition"],
    userStatus = json["userStatus"],
    userType = json["userType"],
    company = json["company"] != null && json["company"] is Map<String, dynamic>
            ? Company.fromJson(json["company"])
            : null;


  /**
   * getters and setters
   */
  int get _userId => userId;
  set _userId(int value) => userId = value;

  String get name => username;
  set name(String value) => username = value;

  String get _userEmail => userEmail;
  set _userEmail(String value) => userEmail = value;

  String get _password => password;
  set _password(String value) => password = value;

  String get _userPosition => userPosition;
  set _userPosition(String value) => userPosition = value;

  String get _userStatus => userStatus;
  set _userStatus(String value) => userStatus = value;

  Company? get _company => company;
  set _company(Company? value) => company = value;

}