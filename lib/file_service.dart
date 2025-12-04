import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<File> _getFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/sign_file.txt');
  }

  // Check if username and password exist in the file
  static Future<bool> checkValue(String username, String password) async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        print('📄 [DEV] File does not exist yet: ${file.path}');
        return false;
      }

      final content = await file.readAsString();
      print('📄 [DEV] File content (checkValue):\n$content');
      final lines = content.split('\n');

      for (var line in lines) {
        if (line.trim().isEmpty) continue;

        // Parse the line: username_الاسم, password_الكلمة, department_التخصص
        final parts = line.split(', ');
        String? fileUsername;
        String? filePassword;

        for (var part in parts) {
          if (part.startsWith('username_')) {
            fileUsername = part.substring('username_'.length);
          } else if (part.startsWith('password_')) {
            filePassword = part.substring('password_'.length);
          }
        }

        if (fileUsername == username && filePassword == password) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Save user data to the file
  static Future<bool> save(String username, String password, String department) async {
    try {
      final file = await _getFile();
      
      // Check if user already exists
      String content = '';
      if (await file.exists()) {
        content = await file.readAsString();
        final lines = content.split('\n');
        
        // Remove existing entry for this username if it exists
        final updatedLines = <String>[];
        for (var line in lines) {
          if (line.trim().isEmpty) continue;
          
          final parts = line.split(', ');
          String? fileUsername;
          
          for (var part in parts) {
            if (part.startsWith('username_')) {
              fileUsername = part.substring('username_'.length);
              break;
            }
          }
          
          if (fileUsername != username) {
            updatedLines.add(line);
          }
        }
        
        content = updatedLines.join('\n');
        if (content.isNotEmpty && !content.endsWith('\n')) {
          content += '\n';
        }
      }

      // Add new entry
      final newEntry = 'username_$username, password_$password, department_$department';
      content += newEntry;

      await file.writeAsString(content);
      print('📝 [DEV] File content after save:\n$content');
      print('📁 [DEV] File path: ${file.path}');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user department by username
  static Future<String?> getUserDepartment(String username) async {
    try {
      final file = await _getFile();
      if (!await file.exists()) {
        print('📄 [DEV] File does not exist yet: ${file.path}');
        return null;
      }

      final content = await file.readAsString();
      print('📄 [DEV] File content (getUserDepartment):\n$content');
      final lines = content.split('\n');

      for (var line in lines) {
        if (line.trim().isEmpty) continue;

        final parts = line.split(', ');
        String? fileUsername;
        String? fileDepartment;

        for (var part in parts) {
          if (part.startsWith('username_')) {
            fileUsername = part.substring('username_'.length);
          } else if (part.startsWith('department_')) {
            fileDepartment = part.substring('department_'.length);
          }
        }

        if (fileUsername == username) {
          return fileDepartment;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

