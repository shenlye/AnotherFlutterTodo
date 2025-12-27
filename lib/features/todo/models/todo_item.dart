class TodoItem {
  final String id;
  final String content;
  bool isChecked;

  TodoItem({required this.id, required this.content, this.isChecked = false});

  void toggle() {
    isChecked = !isChecked;
  }
}
