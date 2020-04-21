import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: HttpLink(uri: 'http://localhost:3000'),
  ),
);

final String getTasksQuery = """
query {
  allTodos {
    id,
    title,
    completed
  }
}
""";

final String createTaskMutation = """
mutation {
  createTodo(id: \$id, title: \$title, completed: false) {
    id
  }
}
""";

final String updateTaskMutation = """
mutation {
  updateTodo(id: \$id, completed: \$completed) {
    id
}
""";