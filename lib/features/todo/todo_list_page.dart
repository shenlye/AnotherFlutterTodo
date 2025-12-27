import 'package:flutter/material.dart';
import 'models/todo_item.dart';
import 'widgets/todo_list_item.dart';
import 'widgets/add_todo_input.dart';
import 'services/daily_quote_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<TodoItem> _todoItems = [];
  bool _showInput = false;
  final TextEditingController _textController = TextEditingController();
  final DailyQuoteService _dailyQuoteService = DailyQuoteService();
  late Future<String> _quoteFuture;

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = _todoItems.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('todo_items', jsonList);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('todo_items');
    if (jsonList != null) {
      setState(() {
        _todoItems.clear();
        _todoItems.addAll(jsonList.map((jsonString) {
          final Map<String, dynamic> json = Map<String, dynamic>.from(jsonDecode(jsonString));
          return TodoItem.fromJson(json);
        }));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _quoteFuture = _dailyQuoteService.fetchDailyQuote();
    _loadData();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleTodoItem(int index) {
    setState(() {
      _todoItems[index].toggle();
      _saveData();
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
        _saveData();
      }
      _showInput = false;
    });
  }

  void _deleteTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Todo List'),
            FutureBuilder<String>(
              future: _quoteFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    '加载中...',
                    style: TextStyle(fontSize: 12),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    '加载失败，但是问题不大',
                    style: TextStyle(fontSize: 12),
                  );
                } else {
                  return Text(
                    snapshot.data ?? '今日无言',
                    style: TextStyle(fontSize: 12),
                  );
                }
              },
            )
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
              onDelete: () => _deleteTodoItem(index),
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
