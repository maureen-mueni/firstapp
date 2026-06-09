class RemoteUser {
  final int id;
  final String name;
  final String email;

  RemoteUser({
    required this.id,
    required this.name,
    required this.email,
  });

  // Maps JSON from the API to our Dart model variables
  factory RemoteUser.fromJson(Map<String, dynamic> json) {
    return RemoteUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}