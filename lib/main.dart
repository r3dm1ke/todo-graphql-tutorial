import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_graphql_tutorial/task.dart';
import 'package:todo_graphql_tutorial/api.dart';

void main() => runApp(TodoApp());

var tempTasks = [
  new Task(id: 1, title: 'Do this'),
  new Task(id: 2, title: 'Do that')
];

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      child: MaterialApp(
        title: 'TODO App With GraphQL',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListPage(),
      ),
      client: client
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future<String> onCreate(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a new task'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Task description', hintText: 'Do stuff'),
                onChanged: (value) {},
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  void onToggle(index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO App With GraphQL"),
      ),
      body: Center(
        child: TaskList(
            list: tempTasks, onToggleItem: (index) => this.onToggle(index)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => this.onCreate(context),
        tooltip: 'New Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({@required this.list, @required this.onToggleItem});

  final List<Task> list;
  final onToggleItem;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemBuilder: (context, index) {
          final task = this.list[index];
          return CheckboxListTile(
              title: Text(task.title),
              value: task.completed,
              onChanged: (_) => this.onToggleItem(index));
        },
        itemCount: this.list.length);
  }
}
