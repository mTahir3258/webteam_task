import 'package:coding_test/task/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskTile extends StatelessWidget {
  final Map<String, dynamic> task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task['isCompleted'] ?? false,
          onChanged: (value) {
            cubit.toggleTask(task['id'], value ?? false);
          },
        ),
        title: Text(
          task['title'] ?? '',
          style: TextStyle(
            decoration: (task['isCompleted'] ?? false)
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => cubit.deleteTask(task['id']),
        ),
      ),
    );
  }
}
