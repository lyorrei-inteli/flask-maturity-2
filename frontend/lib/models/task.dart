class Task {
  int id;
  String text;
  bool status;

  Task({required this.id, required this.text, required this.status});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      text: json['text'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'status': status,
    };
  }
}
