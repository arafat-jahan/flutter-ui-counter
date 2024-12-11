import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Task Model
class Task {
  String name;
  bool isCompleted;
  String priority;
  DateTime? dueDate;

  Task({
    required this.name,
    this.isCompleted = false,
    this.priority = 'Medium',
    this.dueDate,
  });

  // Convert Task to Map (for saving to SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  // Convert Map to Task object (for loading from SharedPreferences)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      isCompleted: map['isCompleted'],
      priority: map['priority'],
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'])
          : null,
    );
  }

  // Convert Task to JSON (for saving to SharedPreferences)
  String toJson() => json.encode(toMap());

  // Convert JSON to Task (for loading from SharedPreferences)
  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source));
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task Manager with Priorities & Due Dates'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences
  _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskData = prefs.getStringList('tasks') ?? [];

    setState(() {
      _tasks.clear();
      for (var taskString in taskData) {
        _tasks.add(Task.fromJson(taskString));
      }
    });
  }

  // Save tasks to SharedPreferences
  _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskData = _tasks.map((task) => task.toJson()).toList();
    prefs.setStringList('tasks', taskData);
  }

  // Add Task
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          name: _taskController.text,
          priority: _selectedPriority,
          dueDate: _dueDate,
        ));
      });
      _taskController.clear();
      _dueDate = null;
      _selectedPriority = 'Medium';
      _saveTasks();
    }
  }

  // Mark Task as Completed
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks();
  }

  // Delete Task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Show Date Picker for Due Date
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? DateTime.now();

    setState(() {
      _dueDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            // Add Task Input
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Enter a task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedPriority,
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriority = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDueDate(context),
                  child: Text(_dueDate == null
                      ? 'Pick Due Date'
                      : DateFormat.yMd().format(_dueDate!)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Add Task'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        _tasks[index].name,
                        style: TextStyle(
                          decoration: _tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: _tasks[index].isCompleted
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Priority: ${_tasks[index].priority}\nDue: ${_tasks[index].dueDate != null ? DateFormat.yMd().format(_tasks[index].dueDate!) : 'No Due Date'}',
                      ),
                      trailing: Wrap(
                        spacing: 10,
                        children: [
                          IconButton(
                            icon: Icon(
                              _tasks[index].isCompleted
                                  ? Icons.undo
                                  : Icons.check,
                              color: Colors.green,
                            ),
                            onPressed: () => _toggleTaskCompletion(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
