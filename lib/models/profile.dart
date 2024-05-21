import 'dart:convert';
  
class Profile {
  final String childId;
  final String email;
  final String name;
  final int age;
  final double weight;
  final String imageUrl;

  Profile({
    required this.childId,
    required this.email,
    required this.name,
    required this.age,
    required this.weight,
    required this.imageUrl,
  }); // Add this closing parenthesis

  Profile copyWith({
    String? childId,
    String? email,
    String? name,
    int? age,
    double? weight,
    String? imageUrl,
  }) {
    return Profile(
      childId: childId ?? this.childId,
      email: email?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'email': email,
      'name': name,
      'age': age,
      'weight': weight,
      'imageUrl': imageUrl,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      childId: map['_id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      age: map['age'] as int,
      weight: (map['weight'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}