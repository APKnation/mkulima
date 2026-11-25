class UserProfile {
  const UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.region,
    required this.ward,
    required this.role,
    required this.joined,
    this.verified = true,
    this.interests = const [],
  });

  final String name;
  final String phone;
  final String email;
  final String region;
  final String ward;
  final String role;
  final String joined;
  final bool verified;
  final List<String> interests;

  String get firstName => name.split(' ').first;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    String? region,
    String? ward,
    String? role,
    List<String>? interests,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      region: region ?? this.region,
      ward: ward ?? this.ward,
      role: role ?? this.role,
      joined: joined,
      verified: verified,
      interests: interests ?? this.interests,
    );
  }
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final String timeAgo;

  /// `bei`, `ombi`, `hali_ya_hewa`, `jamii` or `mfumo`.
  final String type;
  final bool read;

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        timeAgo: timeAgo,
        type: type,
        read: read ?? this.read,
      );
}
