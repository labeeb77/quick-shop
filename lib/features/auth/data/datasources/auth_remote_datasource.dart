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
      
      // Wait a moment for Firebase to fully initialize
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Get user from currentUser to avoid type casting issues
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException('Sign in failed: User not found');
      }
      
      // Try to get user ID - this should always work
      String userId;
      try {
        userId = firebaseUser.uid;
      } catch (e) {
        // If even UID fails, this is a critical error
        throw AuthException('Sign in failed: Unable to get user ID - ${e.toString()}');
      }
      
      if (userId.isEmpty) {
        throw AuthException('Sign in failed: Invalid user ID');
      }
      
      // For email, use the provided email as fallback to avoid property access issues
      String userEmail = email;
      try {
        final emailFromFirebase = firebaseUser.email;
        if (emailFromFirebase != null && emailFromFirebase.isNotEmpty) {
          userEmail = emailFromFirebase;
        }
      } catch (e) {
        // If accessing email fails, use the provided email (this is safe)
        // This handles the PigeonUserDetails casting error
      }
      
      // Display name is optional, try to get it but don't fail if it errors
      String? displayName;
      try {
        displayName = firebaseUser.displayName;
      } catch (e) {
        // Ignore errors for optional field
        displayName = null;
      }
      
      return UserModel(
        id: userId,
        email: userEmail,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } on AuthException {
      rethrow;
    } catch (e) {
      // Final fallback: if everything fails, try to get at least the UID
      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        try {
          return UserModel(
            id: currentUser.uid,
            email: email, // Use the email provided during sign in
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
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException('Sign up failed: User not created');
      }
      
      // Access user properties safely
      final userId = firebaseUser.uid;
      final userEmail = firebaseUser.email ?? email;
      final displayName = firebaseUser.displayName;
      
      return UserModel(
        id: userId,
        email: userEmail,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      if (e is AuthException) {
        rethrow;
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
      
      // Access user properties safely
      final userId = firebaseUser.uid;
      final userEmail = firebaseUser.email ?? '';
      final displayName = firebaseUser.displayName;
      
      return UserModel(
        id: userId,
        email: userEmail,
        displayName: displayName,
      );
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}

