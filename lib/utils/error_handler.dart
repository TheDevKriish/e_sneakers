// Error handler utilities
// FILE: lib/utils/error_handler.dart
// PURPOSE: Centralized error handling and user-friendly messages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ErrorHandler {
  // Get user-friendly error message from exception
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return _getAuthErrorMessage(error.code);
    } else if (error is FirebaseException) {
      return _getFirebaseErrorMessage(error.code);
    } else if (error is FirebaseStorageException) {
      return _getStorageErrorMessage(error.code);
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  // Firebase Auth error messages
  static String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'requires-recent-login':
        return 'Please login again to perform this action.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // Firestore error messages
  static String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'deadline-exceeded':
        return 'Request timeout. Please try again.';
      case 'not-found':
        return 'The requested data was not found.';
      case 'already-exists':
        return 'This data already exists.';
      case 'resource-exhausted':
        return 'Quota exceeded. Please try again later.';
      case 'failed-precondition':
        return 'Operation cannot be completed at this time.';
      case 'aborted':
        return 'Operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Invalid data range.';
      case 'unimplemented':
        return 'This feature is not yet implemented.';
      case 'internal':
        return 'Internal server error. Please try again.';
      case 'data-loss':
        return 'Data corruption detected. Please contact support.';
      case 'unauthenticated':
        return 'Please login to continue.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Firebase Storage error messages
  static String _getStorageErrorMessage(String code) {
    switch (code) {
      case 'object-not-found':
        return 'File not found.';
      case 'bucket-not-found':
        return 'Storage bucket not found.';
      case 'project-not-found':
        return 'Project configuration error.';
      case 'quota-exceeded':
        return 'Storage quota exceeded.';
      case 'unauthenticated':
        return 'Please login to upload files.';
      case 'unauthorized':
        return 'You do not have permission to access this file.';
      case 'retry-limit-exceeded':
        return 'Upload failed after multiple retries.';
      case 'invalid-checksum':
        return 'File upload verification failed.';
      case 'canceled':
        return 'Upload was cancelled.';
      case 'invalid-event-name':
        return 'Invalid upload event.';
      case 'invalid-url':
        return 'Invalid file URL.';
      case 'invalid-argument':
        return 'Invalid file argument.';
      case 'no-default-bucket':
        return 'Storage not configured properly.';
      case 'cannot-slice-blob':
        return 'File cannot be processed.';
      case 'server-file-wrong-size':
        return 'File size mismatch.';
      default:
        return 'File upload failed. Please try again.';
    }
  }

  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Log error to console (can be extended to crash reporting services)
  static void logError(dynamic error, StackTrace? stackTrace) {
    debugPrint('❌ ERROR: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
    // TODO: Add Firebase Crashlytics or Sentry integration here
  }

  // Handle and display error
  static void handleError(BuildContext context, dynamic error, [StackTrace? stackTrace]) {
    logError(error, stackTrace);
    showErrorSnackBar(context, error);
  }
}
