class UserProfile {
  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profilePictureUrl;
  final List<String> favoriteTours;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.profilePictureUrl,
    this.favoriteTours = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'favoriteTours': favoriteTours,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      bio: map['bio'],
      profilePictureUrl: map['profilePictureUrl'],
      favoriteTours: List<String>.from(map['favoriteTours'] ?? []),
      createdAt: map['createdAt'] != null
          ? _timestampToDateTime(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? _timestampToDateTime(map['updatedAt'])
          : DateTime.now(),
    );
  }

  static DateTime _timestampToDateTime(dynamic timestamp) {
    // Handle Firestore Timestamp objects
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    // Handle Timestamp objects from cloud_firestore
    if (timestamp.runtimeType.toString() == '_DateTimeValue' ||
        timestamp.runtimeType.toString() == 'Timestamp') {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profilePictureUrl,
    List<String>? favoriteTours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      favoriteTours: favoriteTours ?? this.favoriteTours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
