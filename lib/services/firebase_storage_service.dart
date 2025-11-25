// Firebase storage service
// FILE: lib/services/firebase_storage_service.dart
// PURPOSE: Firebase Storage for image uploads with compression

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import '../config/constants.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload product image
  Future<String> uploadProductImage(File imageFile, String productId) async {
    try {
      // Compress image before upload
      final compressedFile = await _compressImage(imageFile);

      // Create reference
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('products/$productId/$fileName');

      // Upload file
      final uploadTask = ref.putFile(compressedFile);

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() {});

      // Get download URL
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

  // Compress image
  Future<File> _compressImage(File file) async {
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
      return file; // Return original if compression fails
    }
  }

  // Get file size
  Future<int> getFileSize(File file) async {
    return await file.length();
  }

  // Validate image file
  bool isValidImage(File file) {
    final extension = path.extension(file.path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp'].contains(extension);
  }

  // Check file size
  Future<bool> isValidFileSize(File file) async {
    final size = await getFileSize(file);
    return size <= AppConstants.maxImageSize;
  }
}
