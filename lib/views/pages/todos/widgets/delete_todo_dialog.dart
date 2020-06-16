import 'package:flutter/material.dart';

import '../../../../data/db.dart';

class DeleteTodoDialog extends StatelessWidget {
  final Todo todo;

  const DeleteTodoDialog({
    Key key,
    @required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm deletion'),
      content: Text('Are you sure you want to delete "${todo.title}"?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
        RaisedButton(
          child: Text('Confirm'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
