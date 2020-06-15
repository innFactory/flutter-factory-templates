import 'package:flutter/material.dart';

import '../../../../bloc/todos/todos_bloc.dart';
import '../../../../data/db.dart';
import '../../../../routes.dart';
import 'delete_todo_dialog.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;
  final Function(bool) onChanged;

  const TodoListTile({
    Key key,
    @required this.todo,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) => BlocProvider.of<TodosBloc>(context).add(DeleteTodo(todo)),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => DeleteTodoDialog(
          todo: todo,
        ),
      ),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: onChanged,
        ),
        title: Text(todo.title),
        subtitle: todo.note != null && todo.note != '' ? Text(todo.note) : null,
        onTap: () => Navigator.pushNamed(context, Routes.addEditTodo, arguments: todo),
      ),
    );
  }
}
