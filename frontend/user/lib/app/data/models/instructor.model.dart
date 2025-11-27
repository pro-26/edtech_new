class Instructor {
  final String id;
  final String name;
  final String? bio;
  final String? profilePicture;
  final String? email;
  final String? phoneNumber;

  Instructor({
    required this.id,
    required this.name,
    this.bio,
    this.profilePicture,
    this.email,
    this.phoneNumber,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'],
      profilePicture: json['profilePicture'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (bio != null) 'bio': bio,
    if (profilePicture != null) 'profilePicture': profilePicture,
    if (email != null) 'email': email,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
  };
}
