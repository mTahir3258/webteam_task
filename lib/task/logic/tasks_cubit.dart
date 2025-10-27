import 'package:coding_test/task/data/tasks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository _repository;

  TasksCubit(this._repository) : super(const TasksState());

  void loadTasks() {
    emit(state.copyWith(status: TasksStatus.loading));
    _repository.getTasks().listen(
      (tasks) {
        emit(state.copyWith(status: TasksStatus.success, tasks: tasks));
      },
      onError: (e) {
        emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
      },
    );
  }

  Future<void> addTask(String title) async {
    await _repository.addTask(title);
  }

  Future<void> toggleTask(String id, bool isCompleted) async {
    await _repository.toggleTask(id, isCompleted);
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }
}
