import "package:equatable/equatable.dart";

class User extends Equatable {
  const User({this.id, this.username, this.email, this.photoUrl});

  final int? id;
  final String? username;
  final String? email;
  final String? photoUrl;

  //Простая конвертация в json

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'photoUrl': photoUrl
    };
  }

  //Простая конвертация из json в наш User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        photoUrl: json['photoUrl']);
  }

  @override
  List<Object?> get props => [id];
}
