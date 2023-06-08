import 'package:equatable/equatable.dart';
import 'dart:convert';

class FirebaseModel extends Equatable {
  FirebaseModel({required this.userData, required this.messages});

  late Map<String, dynamic> userData;
  late List<Map<String, dynamic>> messages;

  Map<String, dynamic> toJson() {
    return {
      'userData': userData,
      'messages': messages,
    };
  }

  factory FirebaseModel.fromJson(Map<String, dynamic> json) {
    return FirebaseModel(
      userData: json['userData'] as Map<String, dynamic>,
      messages: (json['messages'] as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  @override
  List<Object?> get props => [userData, messages];
}
