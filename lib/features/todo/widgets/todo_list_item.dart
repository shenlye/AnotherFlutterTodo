import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoListItem extends StatelessWidget {
  final TodoItem item;
  final VoidCallback onToggle;

  const TodoListItem({super.key, required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Checkbox(value: item.isChecked, onChanged: (v) => onToggle()),
            Expanded(
              child: Text(
                item.content,
                style: item.isChecked
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
