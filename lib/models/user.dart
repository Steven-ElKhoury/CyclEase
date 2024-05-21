// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String password;
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    required this.password,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? token,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, token: $token, password: $password)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.username == username &&
      other.email == email &&
      other.token == token &&
      other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      token.hashCode ^
      password.hashCode;
  }
}
