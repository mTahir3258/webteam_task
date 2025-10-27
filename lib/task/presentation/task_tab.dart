import 'package:coding_test/task/data/tasks_repository.dart';
import 'package:coding_test/task/logic/tasks_cubit.dart';
import 'package:coding_test/task/logic/tasks_state.dart';
import 'package:coding_test/task/presentation/widget/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_task_page.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(TasksRepository())..loadTasks(),
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.status == TasksStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == TasksStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'Failed to load tasks'));
          }

          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Tap + to add one.'));
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskPage()),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(task: task);
              },
            ),
          );
        },
      ),
    );
  }
}
