import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/add.dart';
import 'package:todo_app/pages/completed.dart';
import 'package:todo_app/providers/todo_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todoProvider);
    List<Todo> activeTodos = todos
        .where(
          (todo) => todo.completed == false,
        )
        .toList();
    List<Todo> completedTodos = todos
        .where(
          (todo) => todo.completed == true,
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Todo App"),
      ),
      body: ListView.builder(
        itemCount: activeTodos.length + 1,
        itemBuilder: (context, index) {
          if (activeTodos.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 300),
              child: const Center(
                child: Text("Add a todo using the button below"),
              ),
            );
          } else if (index == activeTodos.length) {
            if (completedTodos.isEmpty)
              return Container();
            else {
              return Center(
                child: TextButton(
                  child: Text("Completed Todos"),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CompletedTodo())),
                ),
              );
            }
          } else {
            return Slidable(
                startActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => ref
                          .watch(todoProvider.notifier)
                          .deleTodo(activeTodos[index].todoId),
                      backgroundColor: Colors.red,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      icon: Icons.delete,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => ref
                          .watch(todoProvider.notifier)
                          .completeTodo(activeTodos[index].todoId),
                      backgroundColor: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      icon: Icons.check,
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                      title: Text(
                    activeTodos[index].content,
                  )),
                ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Addtodo()));
        },
        tooltip: 'Increment',
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
