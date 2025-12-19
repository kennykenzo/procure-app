// ignore_for_file: constant_identifier_names

import 'package:procurement_scanner/config/amplifyconfiguration.dart';

enum Flavor { STAGING, PROD, DEV }

extension FlavorName on Flavor {
  String get name => toString().split('.').last;
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get appName => appFlavor == Flavor.DEV
      ? 'Procurement Scanner Dev'
      : 'Procurement Scanner';

  static String get title => appFlavor == Flavor.DEV
      ? 'Procurement Scanner Dev'
      : 'Procurement Scanner';

  static String get amplifyConfig {
    switch (appFlavor) {
      case Flavor.DEV:
        return amplifyconfig['dev']!;
      case Flavor.PROD:
        return amplifyconfig['prod']!;
      case Flavor.STAGING:
        return amplifyconfig['prod']!;
      default:
        return amplifyconfig['dev']!;
    }
  }

  static String get functionsBaseUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return "https://kfzsmf2du3.execute-api.us-east-2.amazonaws.com/dev";
      case Flavor.PROD:
        return "https://iq1cqxpuxi.execute-api.us-east-2.amazonaws.com/prod/";
      case Flavor.STAGING:
        return "https://iq1cqxpuxi.execute-api.us-east-2.amazonaws.com/prod/";
      default:
        return "https://kfzsmf2du3.execute-api.us-east-2.amazonaws.com/dev";
    }
  }

  static String get graphUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return "https://sourcentry.hasura.app/v1/graphql";
      case Flavor.PROD:
        return "https://sourcentry.hasura.app/v1/graphql";
      case Flavor.STAGING:
        return "https://sourcentry.hasura.app/v1/graphql";
      default:
        return "https://sourcentry.hasura.app/v1/graphql";
    }
  }

  static String get wsUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return "wss://resillio-dev.hasura.app/v1/graphql";
      case Flavor.PROD:
        return "ws://resillio-dev.hasura.app/v1/graphql";
      case Flavor.STAGING:
        return "ws://resillio-dev.hasura.app/v1/graphql";
      default:
        return "wss://resillio-dev.hasura.app/v1/graphql";
    }
  }

  static String get cloudFrontUrl {
    switch (appFlavor) {
      case Flavor.DEV:
        return '/public';
      case Flavor.PROD:
        return '.net';
      case Flavor.STAGING:
        return '.net';
      default:
        return '/public';
    }
  }
}
