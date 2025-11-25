// Firebase storage service
// FILE: lib/services/firebase_storage_service.dart
// PURPOSE: Firebase Storage for image uploads (Web + Mobile)

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../config/constants.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload from XFile (Web + Mobile compatible) - USE THIS
  Future<String> uploadProductImageFromXFile(XFile imageFile, String productId) async {
    try {
      // Get file extension from name
      String extension = path.extension(imageFile.name).toLowerCase();
      if (extension.isEmpty) {
        extension = '.jpg';
      }

      // Create reference
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
      final ref = _storage.ref().child('products/$productId/$fileName');

      // Read bytes from XFile
      final Uint8List bytes = await imageFile.readAsBytes();

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(extension),
      );

      // Upload bytes
      final uploadTask = ref.putData(bytes, metadata);
      final snapshot = await uploadTask.whenComplete(() {});
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get content type from extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  // Upload product image from File (Mobile only - legacy)
  Future<String> uploadProductImage(File imageFile, String productId) async {
    try {
      final compressedFile = await _compressImage(imageFile);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('products/$productId/$fileName');
      final uploadTask = ref.putFile(compressedFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Delete product image
  Future<void> deleteProductImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Silently fail if image doesn't exist
    }
  }

  // Compress image (Mobile only)
  Future<File> _compressImage(File file) async {
    if (kIsWeb) return file; // Skip compression on web
    
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final splitPath = filePath.substring(0, lastIndex);
      final outPath = '${splitPath}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: AppConstants.imageQuality,
        minWidth: 800,
        minHeight: 800,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      return file;
    }
  }

  // Validate image - Works for both Web and Mobile
  bool isValidImageXFile(XFile file) {
    final name = file.name.toLowerCase();
    final mimeType = file.mimeType?.toLowerCase() ?? '';

    // Check by file name
    if (name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png') ||
        name.endsWith('.webp')) {
      return true;
    }

    // Check by mime type (for web)
    if (mimeType.contains('image/jpeg') ||
        mimeType.contains('image/png') ||
        mimeType.contains('image/webp')) {
      return true;
    }

    // On web, trust the picker if mime type exists
    if (kIsWeb && mimeType.contains('image/')) {
      return true;
    }

    return false;
  }

  // Check file size from XFile
  Future<bool> isValidFileSizeXFile(XFile file) async {
    final size = await file.length();
    return size <= AppConstants.maxImageSize;
  }

  // Legacy methods for File (keep for backward compatibility)
  bool isValidImage(File file) {
    if (kIsWeb) return true;
    final filePath = file.path.toLowerCase();
    return filePath.endsWith('.jpg') ||
           filePath.endsWith('.jpeg') ||
           filePath.endsWith('.png') ||
           filePath.endsWith('.webp');
  }

  Future<bool> isValidFileSize(File file) async {
    final size = await file.length();
    return size <= AppConstants.maxImageSize;
  }

  Future<int> getFileSize(File file) async {
    return await file.length();
  }
}



// // Firebase storage service
// // FILE: lib/services/firebase_storage_service.dart
// // PURPOSE: Firebase Storage for image uploads with compression

// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path/path.dart' as path;
// import '../config/constants.dart';

// class FirebaseStorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // Upload product image
//   Future<String> uploadProductImage(File imageFile, String productId) async {
//     try {
//       // Compress image before upload
//       final compressedFile = await _compressImage(imageFile);

//       // Create reference
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
//       final ref = _storage.ref().child('products/$productId/$fileName');

//       // Upload file
//       final uploadTask = ref.putFile(compressedFile);

//       // Wait for upload to complete
//       final snapshot = await uploadTask.whenComplete(() {});

//       // Get download URL
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       return downloadUrl;
//     } catch (e) {
//       throw Exception('Failed to upload image: $e');
//     }
//   }

//   // Delete product image
//   Future<void> deleteProductImage(String imageUrl) async {
//     try {
//       final ref = _storage.refFromURL(imageUrl);
//       await ref.delete();
//     } catch (e) {
//       // Silently fail if image doesn't exist
//     }
//   }

//   // Compress image
//   Future<File> _compressImage(File file) async {
//     try {
//       final filePath = file.absolute.path;
//       final lastIndex = filePath.lastIndexOf('.');
//       final splitPath = filePath.substring(0, lastIndex);
//       final outPath = '${splitPath}_compressed.jpg';

//       final compressedFile = await FlutterImageCompress.compressAndGetFile(
//         filePath,
//         outPath,
//         quality: AppConstants.imageQuality,
//         minWidth: 800,
//         minHeight: 800,
//       );

//       return compressedFile != null ? File(compressedFile.path) : file;
//     } catch (e) {
//       return file; // Return original if compression fails
//     }
//   }

//   // Get file size
//   Future<int> getFileSize(File file) async {
//     return await file.length();
//   }

//   // Validate image file - FIXED VERSION
//   bool isValidImage(File file) {
//     final filePath = file.path.toLowerCase();
    
//     // Debug: Print the file path to see what we're getting
//     print('Validating image path: $filePath');
    
//     // Check if file path ends with valid extensions
//     if (filePath.endsWith('.jpg') ||
//         filePath.endsWith('.jpeg') ||
//         filePath.endsWith('.png') ||
//         filePath.endsWith('.webp')) {
//       return true;
//     }
    
//     // Also check using path.extension as backup
//     final ext = path.extension(filePath).toLowerCase();
//     print('Extension detected: $ext');
    
//     return ['.jpg', '.jpeg', '.png', '.webp'].contains(ext);
//   }

//   // Check file size
//   Future<bool> isValidFileSize(File file) async {
//     final size = await getFileSize(file);
//     return size <= AppConstants.maxImageSize;
//   }
// }

