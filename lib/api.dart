import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: HttpLink(uri: 'http://10.0.2.2:3000'),
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
mutation CreateTodo(\$id: ID!, \$title: String!) {
  createTodo(id: \$id, title: \$title, completed: false) {
    id
  }
}
""";

final String updateTaskMutation = """
mutation UpdateTodo(\$id: ID!, \$completed: Boolean!) {
  updateTodo(id: \$id, completed: \$completed) {
    id
  }
}
""";