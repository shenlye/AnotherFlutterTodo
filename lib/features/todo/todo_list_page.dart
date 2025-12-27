import 'package:flutter/material.dart';
import 'models/todo_item.dart';
import 'widgets/todo_list_item.dart';
import 'widgets/add_todo_input.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todoItems = [];
  bool _showInput = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].toggle();
    });
  }

  void _addTodoItem() {
    setState(() {
      if (_textController.text.isNotEmpty) {
        _todoItems.add(
          TodoItem(
            id: DateTime.now().toString(),
            content: _textController.text,
          ),
        );
        _textController.clear();
      }
      _showInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todo List'),
            Text('这个地方打算用来显示每日一言', style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.tealAccent,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: _todoItems.length,
          itemBuilder: (context, index) {
            return TodoListItem(
              item: _todoItems[index],
              onToggle: () => _toggleTodoItem(index),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: !_showInput
            ? FloatingActionButton(
                key: const ValueKey('fab_closed'),
                heroTag: 'fab_closed',
                onPressed: () {
                  setState(() {
                    _showInput = true;
                  });
                },
                child: const Icon(Icons.add),
              )
            : AddTodoInput(
                key: const ValueKey('fab_open'),
                controller: _textController,
                onAdd: _addTodoItem,
                onClose: () {
                  setState(() {
                    _showInput = false;
                  });
                },
              ),
      ),
    );
  }
}
