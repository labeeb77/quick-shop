import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart' as domain;
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<domain.User> signIn(String email, String password);
  Future<domain.User> signUp(String email, String password);
  Future<void> signOut();
  Future<domain.User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<domain.User> signIn(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException('Sign in failed: User not found');
      }

      String userId;
      try {
        userId = firebaseUser.uid;
      } catch (e) {
        throw AuthException(
          'Sign in failed: Unable to get user ID - ${e.toString()}',
        );
      }

      if (userId.isEmpty) {
        throw AuthException('Sign in failed: Invalid user ID');
      }

      String userEmail = email;
      try {
        final emailFromFirebase = firebaseUser.email;
        if (emailFromFirebase != null && emailFromFirebase.isNotEmpty) {
          userEmail = emailFromFirebase;
        }
      } catch (e) {
        // Handles PigeonUserDetails casting error
      }

      String? displayName;
      try {
        displayName = firebaseUser.displayName;
      } catch (e) {
        displayName = null;
      }

      return UserModel(id: userId, email: userEmail, displayName: displayName);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        try {
          return UserModel(
            id: currentUser.uid,
            email: email,
            displayName: null,
          );
        } catch (fallbackError) {
          throw AuthException('Sign in failed: ${e.toString()}');
        }
      }
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<domain.User> signUp(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException('Sign up failed: User not found');
      }

      String userId;
      try {
        userId = firebaseUser.uid;
      } catch (e) {
        throw AuthException(
          'Sign up failed: Unable to get user ID - ${e.toString()}',
        );
      }

      if (userId.isEmpty) {
        throw AuthException('Sign up failed: Invalid user ID');
      }

      String userEmail = email;
      try {
        final emailFromFirebase = firebaseUser.email;
        if (emailFromFirebase != null && emailFromFirebase.isNotEmpty) {
          userEmail = emailFromFirebase;
        }
      } catch (e) {
        // Handles PigeonUserDetails casting error
      }

      String? displayName;
      try {
        displayName = firebaseUser.displayName;
      } catch (e) {
        displayName = null;
      }

      return UserModel(id: userId, email: userEmail, displayName: displayName);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        try {
          return UserModel(
            id: currentUser.uid,
            email: email,
            displayName: null,
          );
        } catch (fallbackError) {
          throw AuthException('Sign up failed: ${e.toString()}');
        }
      }
      throw AuthException('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      String userId;
      try {
        userId = firebaseUser.uid;
      } catch (e) {
        throw AuthException(
          'Failed to get current user: Unable to get user ID - ${e.toString()}',
        );
      }

      if (userId.isEmpty) {
        throw AuthException('Failed to get current user: Invalid user ID');
      }

      String userEmail = '';
      try {
        final emailFromFirebase = firebaseUser.email;
        if (emailFromFirebase != null && emailFromFirebase.isNotEmpty) {
          userEmail = emailFromFirebase;
        }
      } catch (e) {
        // Handles PigeonUserDetails casting error
      }

      String? displayName;
      try {
        displayName = firebaseUser.displayName;
      } catch (e) {
        displayName = null;
      }

      return UserModel(id: userId, email: userEmail, displayName: displayName);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Invalid Credential';
      case 'invalid-credential':
        return 'Invalid Credential';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        final message = e.message ?? 'Authentication failed';
        if (message.contains('supplied auth credential is incorrect') ||
            message.contains('supplied auth credential is incorrect, malformed or has expired')) {
          return 'Invalid Credential';
        }
        return message;
    }
  }
}
