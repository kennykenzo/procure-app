import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<SignInResult> signIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<SignOutResult> signOut() async {
    try {
      return await Amplify.Auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> sendOTP(String number) async {
    // Implement your OTP sending logic here
    throw UnimplementedError('Implement your OTP sending logic');
  }

  Future<void> forgotPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getAmplifyUserId() async {
    final session = await Amplify.Auth.getPlugin(
      AmplifyAuthCognito.pluginKey,
    ).fetchAuthSession();
    if (session.isSignedIn) {
      List<AuthUserAttribute> authUserAttributes =
          await Amplify.Auth.fetchUserAttributes();
      int oldSubIndex = authUserAttributes.indexWhere(
        (element) => element.userAttributeKey.key == 'custom:old_sub',
      );
      if (oldSubIndex > -1) {
        AuthUserAttribute oldSubAttribute = authUserAttributes.firstWhere((
          AuthUserAttribute element,
        ) {
          return element.userAttributeKey.key == 'custom:old_sub';
        });
        return oldSubAttribute.value;
      }

      // Check if userSubResult is a success before accessing value
      final userSubResult = session.userSubResult;
      // Check if result is not a loading state before accessing value
      if (userSubResult.runtimeType.toString().contains('Loading')) {
        return null;
      }
      try {
        return userSubResult.value;
      } catch (e) {
        debugPrint('Error accessing userSub: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> confirmPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      await Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
    } catch (e) {
      rethrow;
    }
  }

  // TODO: Implement registerUser when RegisterModel and REGISTER_USER mutation are available
  // Future<void> registerUser(RegisterModel user) async {
  //   try {
  //     final MutationOptions options = MutationOptions(
  //       document: gql(REGISTER_USER),
  //       fetchPolicy: FetchPolicy.networkOnly,
  //       variables: {
  //         "user": user,
  //       },
  //     );

  //     final result = await UnAuthClient.api.client.mutate(options);

  //     if (result.hasException) {
  //       debugPrint(result.exception.toString());
  //       throw result.exception!;
  //     }
  //   } catch (e, st) {
  //     debugPrintStack(stackTrace: st);
  //     debugPrint(e.toString());
  //     rethrow;
  //   }
  // }
}
