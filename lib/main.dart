import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todo_graphql_tutorial/api.dart';

void main() => runApp(TodoApp());

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
        client: client);
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final newTaskController = TextEditingController();

  Future<String> onCreate(BuildContext context, id) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Mutation(
            options: MutationOptions(
              documentNode: gql(createTaskMutation),
            ),
            builder: (RunMutation runMutation, QueryResult result) {
              return AlertDialog(
                title: Text('Enter a new task'),
                content: new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextField(
                            autofocus: true,
                            decoration: new InputDecoration(
                                labelText: 'Task description',
                                hintText: 'Do stuff',
                                errorText: result.hasException
                                    ? result.exception.toString()
                                    : null),
                            controller: newTaskController))
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      runMutation({'title': newTaskController.text, 'id': id});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options:
            QueryOptions(documentNode: gql(getTasksQuery), pollInterval: 1),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          return Scaffold(
              appBar: AppBar(
                title: Text("TODO App With GraphQL"),
              ),
              body: Center(
                  child: result.hasException
                      ? Text(result.exception.toString())
                      : result.loading
                          ? CircularProgressIndicator()
                          : TaskList(list: result.data['allTodos'], onRefresh: refetch)),
              floatingActionButton: FloatingActionButton(
                onPressed: () => !result.hasException && !result.loading
                    ? this.onCreate(context, result.data['allTodos'].length)
                    : () {},
                tooltip: 'New Task',
                child: Icon(Icons.add),
              ));
        });
  }
}

class TaskList extends StatelessWidget {
  TaskList({@required this.list, @required this.onRefresh});

  final list;
  final onRefresh;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(documentNode: gql(updateTaskMutation)),
      builder: (RunMutation runMutation, QueryResult result) {
        return ListView.builder(
          itemCount: this.list.length,
          itemBuilder: (context, index) {
            final task = this.list[index];
            return CheckboxListTile(
                title: Text(task['title']),
                value: task['completed'],
                onChanged: (_) {
                  runMutation({'id': index + 1, 'completed': !task['completed']});
                  onRefresh();
                });
          },
        );
      },
    );
  }
}
