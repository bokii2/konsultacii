class ProfessorResponse {
  final String username;
  final String name;

  ProfessorResponse({
    required this.username,
    required this.name,
  });

  factory ProfessorResponse.fromJson(Map<String, dynamic> json) {
    return ProfessorResponse(
      username: json['username'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'name': name,
  };
}
