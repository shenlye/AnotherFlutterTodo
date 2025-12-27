import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> items = [];

  late List<bool> isCheckedList;
  bool _showInput = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isCheckedList = List.generate(items.length, (index) => false);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // 让“输入条”这种宽组件居中悬浮更自然
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Todo List'),
              Text('这个地方打算用来显示每日一言', style: TextStyle(fontSize: 12)),
            ],
          ),
          backgroundColor: Colors.tealAccent,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, idx) {
              var item = items[idx];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: isCheckedList[idx],
                      onChanged: (v) {
                        setState(() {
                          isCheckedList[idx] = v!;
                        });
                      },
                    ),
                    Column(
                      children: [
                        if (!isCheckedList[idx])
                          Text(item)
                        else
                          Text(
                            item,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
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
              : Container(
                  key: const ValueKey('fab_open'),
                  width: MediaQuery.of(context).size.width - 32,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: 'Add a new item',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton(
                        heroTag: 'fab_open',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_textController.text.isNotEmpty) {
                              items.add(_textController.text);
                              isCheckedList.add(false);
                              _textController.clear();
                            }
                            _showInput = false;
                          });
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
