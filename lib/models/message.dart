class Message {
  final String comment;
  final DateTime timestamp;
  final bool isProfessor;

  Message({
    required this.comment,
    required this.timestamp,
    this.isProfessor = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      comment: json['comment'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isProfessor: json['isProfessor'] ?? false,
    );
  }
}
