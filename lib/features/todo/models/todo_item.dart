class TodoItem {
  final String id;
  final String content;
  bool isChecked;

  TodoItem({required this.id, required this.content, this.isChecked = false});

  void toggle() {
    isChecked = !isChecked;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isChecked': isChecked,
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      content: json['content'],
      isChecked: json['isChecked'] ?? false,
    );
  }
}
