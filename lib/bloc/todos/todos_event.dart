part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodosEvent {}

class SaveTodo extends TodosEvent {
  final Todo todo;

  const SaveTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'SaveTodo { todo: $todo }';
}

class ToggleTodo extends TodosEvent {
  final Todo todo;

  const ToggleTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'ToggleTodo { todo: $todo }';
}

class DeleteTodo extends TodosEvent {
  final Todo todo;

  const DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteTodo { todo: $todo }';
}

class ClearCompleted extends TodosEvent {}

class ToggleAll extends TodosEvent {}
