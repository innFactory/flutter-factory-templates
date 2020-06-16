import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/db.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  @override
  TodosState get initialState => TodosInitial();

  TodosBloc() {
    add(LoadTodos());
  }

  @override
  Stream<TodosState> mapEventToState(
    TodosEvent event,
  ) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is SaveTodo) {
      yield* _mapSaveTodoToState(event.todo);
    } else if (event is ToggleTodo) {
      yield* _mapToggleTodoToState(event.todo);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event.todo);
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    yield* _yieldTodos();
  }

  Stream<TodosState> _mapSaveTodoToState(Todo todo) async* {
    await todo.save();
    yield* _yieldTodos();
  }

  Stream<TodosState> _mapToggleTodoToState(Todo todo) async* {
    todo.isCompleted = !todo.isCompleted;
    await todo.save();
    yield* _yieldTodos();
  }

  Stream<TodosState> _mapDeleteTodoToState(Todo todo) async* {
    await todo.delete();
    yield* _yieldTodos();
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    final completedTodos = await Todo().select().isCompleted.equals(true).toList();

    for (final todo in completedTodos) {
      await todo.delete();
    }

    yield* _yieldTodos();
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final todos = await Todo().select().toList();

    for (final todo in todos) {
      todo.isCompleted = !todo.isCompleted;
      await todo.save();
    }

    yield TodosLoaded(todos);
  }

  Stream<TodosState> _yieldTodos() async* {
    final todos = await Todo().select().toList();
    yield TodosLoaded(todos);
  }
}
