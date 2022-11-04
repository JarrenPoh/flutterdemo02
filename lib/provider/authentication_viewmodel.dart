import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppleSignInAvailable{
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check()async{
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }
}

final authappleService = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

class AuthService extends ChangeNotifier{
  final _firebaseAuth = FirebaseAuth.instance;

    Future<User> signInWithApple({List<Scope> scopes = const []}) async {
      // 1. perform the sign-in request
      final result = await TheAppleSignIn.performRequests(
        [
          AppleIdRequest(
            requestedScopes: [Scope.email, Scope.fullName],
          ),
        ],
      );
      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode!),
          );
          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;
          if (scopes.contains(Scope.fullName)) {
            final fullName = appleIdCredential.fullName;
            if (fullName != null &&
                fullName.givenName != null &&
                fullName.familyName != null) {
              final displayName =
                  '${fullName.givenName} ${fullName.familyName}';
              await firebaseUser.updateDisplayName(displayName);
            }
          }
          return firebaseUser;
        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        default:
          throw UnimplementedError();
      }
    }
}