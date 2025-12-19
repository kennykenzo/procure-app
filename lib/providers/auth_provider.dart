import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart';
import 'package:procurement_scanner/flavors.dart';
import 'package:procurement_scanner/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final storage = Provider((ref) => const FlutterSecureStorage());

enum AuthStateEnum { loggedIn, loggedOut, waiting, registering }

/// Auth state class
class AuthState {
  final AuthStateEnum status;
  final String? email;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStateEnum.waiting,
    this.email,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStateEnum? status,
    String? email,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage,
    );
  }
}

final authStateProvider = StateProvider<AuthState>((ref) {
  return const AuthState();
});

final authStateNotifierProvider = Provider<AuthStateNotifier>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier {
  final Ref ref;
  AuthState _state = const AuthState();
  static Future<void>? _configurationFuture;

  AuthStateNotifier(this.ref) {
    // Initialize and check session on startup
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Don't await in constructor, but store the future
    _configurationFuture = configureAmplify();
    // Ensure we wait for configuration and session check
    try {
      await _configurationFuture;
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    }
  }

  AuthState get state => _state;

  void _updateState(AuthState newState) {
    _state = newState;
    // Notify listeners by updating the provider
    ref.read(authStateProvider.notifier).state = newState;
  }

  Future<void> signIn(String email, String password) async {
    try {
      ref.read(loadingProvider.notifier).state = true;

      // Ensure Amplify is configured before using it
      // Wait for any ongoing configuration or configure if needed
      if (_configurationFuture != null) {
        await _configurationFuture;
      } else if (!Amplify.isConfigured) {
        _configurationFuture = configureAmplify();
        await _configurationFuture;
      }

      // Only sign out if there's an active session
      // Skip this check to avoid credential loading issues - just proceed with sign in
      // The sign in will handle any existing session automatically
      await ref.read(authServiceProvider).signOut();
      final stopwatch = Stopwatch();
      stopwatch.start();
      SignInResult res = await ref
          .read(authServiceProvider)
          .signIn(email.trim(), password.trim());

      // TODO: Uncomment when userProvider is available
      // final userId = await ref.read(authServiceProvider).getAmplifyUserId();
      // final user = await ref.read(userProvider).getUser(userId!);
      // ref.read(currentUserProvider.notifier).state = user;

      stopwatch.stop();
      debugPrint('AUTH TIME ${stopwatch.elapsedMilliseconds}');

      if (res.isSignedIn) {
        _updateState(
          _state.copyWith(
            status: AuthStateEnum.loggedIn,
            email: email.trim(),
            errorMessage: null,
          ),
        );
      } else {
        _updateState(
          _state.copyWith(status: AuthStateEnum.loggedOut, errorMessage: null),
        );
      }
      ref.read(loadingProvider.notifier).state = false;
    } catch (e, st) {
      debugPrint(st.toString());
      debugPrint('Sign in error: $e');
      _updateState(
        _state.copyWith(
          status: AuthStateEnum.loggedOut,
          errorMessage: e.toString(),
        ),
      );
      ref.read(loadingProvider.notifier).state = false;
      rethrow;
    }
  }

  Future<bool> isAccountDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('accountDetails') ?? false;
  }

  // TODO: Uncomment when RegisterModel is available
  // Future<void> signUp(RegisterModel user) async {
  //   try {
  //     ref.read(loadingProvider.notifier).state = true;
  //     await signOut();
  //     await ref.read(authServiceProvider).registerUser(user);
  //     await signIn(user.email, user.password);
  //     ref.read(storage).write(key: 'email', value: user.email);
  //     ref.read(storage).write(key: 'name', value: user.name);
  //     ref.read(loadingProvider.notifier).state = false;
  //   } catch (error, st) {
  //     debugPrintStack(stackTrace: st);
  //     debugPrint('ERROR: $error');
  //     ref.read(loadingProvider.notifier).state = false;
  //     rethrow;
  //   }
  // }

  Future<SignOutResult> signOut() async {
    // Ensure Amplify is configured before signing out
    if (_configurationFuture != null) {
      await _configurationFuture;
    } else if (!Amplify.isConfigured) {
      _configurationFuture = configureAmplify();
      await _configurationFuture;
    }
    return await _safeSignOut();
  }

  Future<SignOutResult> _safeSignOut() async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      SignOutResult response = await ref.read(authServiceProvider).signOut();
      // TODO: Uncomment when userStateProvider is available
      // ref.invalidate(userStateProvider);
      ref.read(storage).delete(key: 'email');
      ref.read(storage).delete(key: 'name');
      ref.read(loadingProvider.notifier).state = false;
      _updateState(
        _state.copyWith(
          status: AuthStateEnum.loggedOut,
          email: null,
          errorMessage: null,
        ),
      );
      return response;
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Response> sendOTP(String number) async {
    return ref.read(authServiceProvider).sendOTP(number);
  }

  Future<void> forgotPassword(String email) async {
    try {
      ref.read(storage).write(key: 'email', value: email);
      return await ref.read(authServiceProvider).forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmResetPassword(String password, String code) async {
    try {
      final email = await ref.read(storage).read(key: 'email');
      return ref
          .read(authServiceProvider)
          .confirmPassword(email ?? '', code, password);
    } catch (e) {
      rethrow;
    }
  }

  initAuthListener() {
    if (Amplify.isConfigured) {
      print("CONFIGURED");
      Amplify.Hub.listen(HubChannel.Auth, (hubEvent) {
        print(hubEvent.eventName);
        switch (hubEvent.eventName) {
          case "SIGNED_IN":
            _updateState(_state.copyWith(status: AuthStateEnum.loggedIn));
            break;
          case "SIGNED_OUT":
            _updateState(_state.copyWith(status: AuthStateEnum.loggedOut));
            break;
          case "SESSION_EXPIRED":
            _updateState(_state.copyWith(status: AuthStateEnum.loggedIn));
            break;
        }
      });
    }
  }

  clearUser() async {
    // await ref.read(storage).delete(key: 'email');
    // await ref.read(storage).delete(key: 'name');
  }

  fetchSession() async {
    try {
      final res = await Amplify.Auth.fetchAuthSession();
      debugPrint('Session check - isSignedIn: ${res.isSignedIn}');

      if (res.isSignedIn) {
        // Try to get user email if available
        String? email;
        try {
          final attributes = await Amplify.Auth.fetchUserAttributes();
          for (final attr in attributes) {
            final key = attr.userAttributeKey.key;
            if (key == 'email' ||
                key == AuthUserAttributeKey.email.toString()) {
              email = attr.value;
              break;
            }
          }
        } catch (e) {
          debugPrint('Could not fetch user email: $e');
        }

        _updateState(
          _state.copyWith(
            status: AuthStateEnum.loggedIn,
            email: email,
            errorMessage: null,
          ),
        );
        debugPrint('Session restored - user is logged in');
      } else {
        _updateState(_state.copyWith(status: AuthStateEnum.loggedOut));
        debugPrint('No active session found');
      }
    } on AuthException catch (e, st) {
      debugPrint('AuthException fetching session: ${e.message}');
      debugPrint(st.toString());
      _updateState(_state.copyWith(status: AuthStateEnum.loggedOut));
    } catch (e, st) {
      // Handle credential loading errors
      debugPrint('Error fetching session: $e');
      debugPrint(st.toString());
      _updateState(_state.copyWith(status: AuthStateEnum.loggedOut));
    }
  }

  Future<void> configureAmplify() async {
    // If configuration is already in progress, wait for it
    if (_configurationFuture != null) {
      try {
        await _configurationFuture;
        // Even if already configured, check session on refresh
        if (Amplify.isConfigured) {
          await fetchSession();
        }
        return;
      } catch (e) {
        // If previous configuration failed, try again
        _configurationFuture = null;
      }
    }

    // If already configured, just fetch session
    if (Amplify.isConfigured) {
      debugPrint("Amplify already configured, fetching session...");
      await fetchSession();
      return;
    }

    // Start new configuration
    _configurationFuture = _doConfigureAmplify();
    await _configurationFuture;
  }

  Future<void> _doConfigureAmplify() async {
    try {
      AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
      Amplify.addPlugins([authPlugin]);

      await Amplify.configure(F.amplifyConfig);
      await fetchSession();
      initAuthListener();
      debugPrint("CONFIGURED AWS");
    } on AmplifyAlreadyConfiguredException {
      debugPrint(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android.",
      );
    } catch (e) {
      debugPrint("Error configuring Amplify: $e");
      // Clear the future on error so it can be retried
      _configurationFuture = null;
      rethrow;
    }
  }
}
