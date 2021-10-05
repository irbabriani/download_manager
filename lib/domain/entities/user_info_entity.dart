// To parse this JSON data, do
//
//     final userInfoEntity = userInfoEntityFromJson(jsonString);

import 'dart:convert';

UserInfoEntity userInfoEntityFromJson(String str) => UserInfoEntity.fromJson(json.decode(str));

String userInfoEntityToJson(UserInfoEntity data) => json.encode(data.toJson());

class UserInfoEntity {
  UserInfoEntity({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.selectedLanguage,
    required this.selectedTheme,
    required this.token,
  });

  final String firstName;
  final String lastName;
  final String role;
  final String selectedLanguage;
  final String selectedTheme;
  final String token;

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => UserInfoEntity(
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    role: json["role"] == null ? null : json["role"],
    selectedLanguage: json["selectedLanguage"] == null ? null : json["selectedLanguage"],
    selectedTheme: json["selectedTheme"] == null ? null : json["selectedTheme"],
    token: json["token"] == null ? null : json["token"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "role": role == null ? null : role,
    "selectedLanguage": selectedLanguage == null ? null : selectedLanguage,
    "selectedTheme": selectedTheme == null ? null : selectedTheme,
    "token": token == null ? null : token,
  };
}
