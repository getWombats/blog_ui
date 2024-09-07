class BlogUser {
  String id;
  String email;
  String username;
  List<String> roles;

  BlogUser({
    this.id = '',
    this.email = '',
    this.username = '',
    this.roles = const [],
  });

  factory BlogUser.fromMap(Map<String, dynamic> map) {
    return BlogUser(
      id: map['sub'] ?? '',
      email: map['email'] ?? 'no mail',
      username: map['upn'] ?? '',
      roles: List<String>.from(map['groups'] ?? []),
    );
  }
}
