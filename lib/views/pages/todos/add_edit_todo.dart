import 'package:flutter/material.dart';

import '../../../bloc/todos/todos_bloc.dart';
import '../../../data/db.dart';
import 'widgets/delete_todo_dialog.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo todo;

  AddEditTodoScreen({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title;
  String _note;

  bool get isEditing => widget.todo != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Todo' : 'Add Todo',
        ),
        actions: <Widget>[
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _handleDelete(context),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                initialValue: isEditing ? widget.todo.title : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(hintText: 'Title'),
                validator: (val) {
                  return val.trim().isEmpty ? 'The Todo title cannot be empty.' : null;
                },
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                initialValue: isEditing ? widget.todo.note : '',
                maxLines: 10,
                style: textTheme.subtitle1,
                decoration: InputDecoration(hintText: 'Note'),
                onSaved: (value) => _note = value,
              ),
              RaisedButton(
                child: Text(isEditing ? 'Save changes' : 'Add Todo'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    var todo;
                    if (isEditing) {
                      todo = widget.todo
                        ..title = _title
                        ..note = _note
                        ..isCompleted = false;
                    } else {
                      todo = Todo(title: _title, note: _note);
                    }

                    BlocProvider.of<TodosBloc>(context).add(SaveTodo(todo));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleDelete(BuildContext context) async {
    final hasConfirmedDeletion = await showDialog(
      context: context,
      builder: (context) => DeleteTodoDialog(
        todo: widget.todo,
      ),
    );

    if (hasConfirmedDeletion) {
      BlocProvider.of<TodosBloc>(context).add(DeleteTodo(widget.todo));
      Navigator.pop(context);
    }
  }
}
