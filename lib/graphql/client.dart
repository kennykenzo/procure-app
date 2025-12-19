import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:graphql/client.dart';
import 'package:procurement_scanner/flavors.dart';

class Graph {
  static GraphQLClient? _client;

  final HttpLink _httpLink = HttpLink(F.graphUrl);

  Graph._();
  static final Graph api = Graph._();

  GraphQLClient get client {
    _client ??= init();
    return _client!;
  }

  GraphQLClient init() {
    final AuthLink authLink = AuthLink(
      getToken: () async => await getToken(),
      headerKey: "Authorization",
    );

    final WebSocketLink wsLink = WebSocketLink(
      F.wsUrl,
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: () async {
          final token = await getToken();
          return {
            'headers': {'Authorization': token},
          };
        },
      ),
    );

    final Link link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      authLink.concat(_httpLink),
    );

    return GraphQLClient(link: link, cache: GraphQLCache());
  }

  Future<String> getToken() async {
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();

    final accessToken = session.userPoolTokensResult.value.idToken.raw;
    return "Bearer $accessToken";
  }
}

class UnAuthClient {
  static GraphQLClient? _client;

  // final HttpLink _httpLink = HttpLink(F.graphUrl);

  final HttpLink _httpLink = HttpLink(
    F.graphUrl,
    defaultHeaders: {
      "x-hasura-role": "unauth", // Ensure this role has permissions
    },
  );

  UnAuthClient._();
  static final UnAuthClient api = UnAuthClient._();

  GraphQLClient get client {
    _client ??= init();
    return _client!;
  }

  GraphQLClient init() {
    return GraphQLClient(link: _httpLink, cache: GraphQLCache());
  }
}
