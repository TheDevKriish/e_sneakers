// Image helper utilities
// FILE: lib/utils/image_helper.dart
// PURPOSE: Image processing utilities (resize, compress, validate)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
// import '../config/constants.dart';

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  // Show image source selection bottom sheet
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    File? selectedImage;

    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                selectedImage = await pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                selectedImage = await pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );

    return selectedImage;
  }

  // Compress image
  static Future<File> compressImage(File file, {int quality = 80}) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf('.');
      final splitPath = filePath.substring(0, lastIndex);
      final outPath = '${splitPath}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: quality,
        minWidth: 800,
        minHeight: 800,
      );

      if (compressedFile != null) {
        return File(compressedFile.path);
      }
      return file;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return file;
    }
  }

  // Validate image file
  static bool isValidImage(File file) {
    final extension = path.extension(file.path).toLowerCase();
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    return validExtensions.contains(extension);
  }

  // Check file size
  static Future<bool> isValidFileSize(File file, {double maxSizeMB = 5.0}) async {
    try {
      final bytes = await file.length();
      final sizeMB = bytes / (1024 * 1024);
      return sizeMB <= maxSizeMB;
    } catch (e) {
      debugPrint('Error checking file size: $e');
      return false;
    }
  }

  // Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    try {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      debugPrint('Error getting file size: $e');
      return 0.0;
    }
  }

  // Validate and compress image
  // Around line 165-175 - Add mounted check
static Future<File?> validateAndCompressImage(
  File file, {
  BuildContext? context,
}) async {
  // Check if valid image
  if (!isValidImage(file)) {
    if (context != null && context.mounted) {  // ADD context.mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid image file (jpg, png, webp)'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  // Check file size
  final isValidSize = await isValidFileSize(file);
  if (!isValidSize) {
    if (context != null && context.mounted) {  // ADD context.mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image size must be less than 5MB'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }

  // Compress image
  final compressedFile = await compressImage(file, quality: 80);
  return compressedFile;
}


  // Get image file info
  static Future<Map<String, dynamic>> getImageInfo(File file) async {
    final size = await getFileSizeInMB(file);
    final extension = path.extension(file.path);
    final name = path.basename(file.path);

    return {
      'name': name,
      'extension': extension,
      'sizeMB': size,
      'path': file.path,
    };
  }

  // Delete image file
  static Future<bool> deleteImageFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }
}
