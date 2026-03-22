class GuideProfile {
  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? profilePictureUrl;
  final int yearsOfExperience;
  final List<String> languages;
  final List<String> specializations;
  final String? certification;
  final double rating;
  final int totalTours;
  final DateTime createdAt;
  final DateTime updatedAt;

  GuideProfile({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.location,
    this.bio,
    this.profilePictureUrl,
    this.yearsOfExperience = 0,
    this.languages = const [],
    this.specializations = const [],
    this.certification,
    this.rating = 0.0,
    this.totalTours = 0,
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
      'yearsOfExperience': yearsOfExperience,
      'languages': languages,
      'specializations': specializations,
      'certification': certification,
      'rating': rating,
      'totalTours': totalTours,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory GuideProfile.fromMap(Map<String, dynamic> map) {
    return GuideProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      bio: map['bio'],
      profilePictureUrl: map['profilePictureUrl'],
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      specializations: List<String>.from(map['specializations'] ?? []),
      certification: map['certification'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalTours: map['totalTours'] ?? 0,
      createdAt: map['createdAt'] != null
          ? _timestampToDateTime(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? _timestampToDateTime(map['updatedAt'])
          : DateTime.now(),
    );
  }

  static DateTime _timestampToDateTime(dynamic timestamp) {
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    if (timestamp.runtimeType.toString() == '_DateTimeValue' ||
        timestamp.runtimeType.toString() == 'Timestamp') {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  GuideProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profilePictureUrl,
    int? yearsOfExperience,
    List<String>? languages,
    List<String>? specializations,
    String? certification,
    double? rating,
    int? totalTours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GuideProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      languages: languages ?? this.languages,
      specializations: specializations ?? this.specializations,
      certification: certification ?? this.certification,
      rating: rating ?? this.rating,
      totalTours: totalTours ?? this.totalTours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
