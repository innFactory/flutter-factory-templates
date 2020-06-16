import 'package:flutter/material.dart';

import '../../../bloc/todos/todos_bloc.dart';
import '../../../routes.dart';
import 'widgets/todo_list_tile.dart';

class TodosPage extends StatefulWidget {
  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Text('No Todos found'),
              );
            }

            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];

                return TodoListTile(
                  todo: todo,
                  onChanged: (val) => BlocProvider.of<TodosBloc>(context).add(SaveTodo(todo..isCompleted = val)),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.addEditTodo),
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
      ),
    );
  }
}
