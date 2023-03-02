import 'dart:io';
import 'dart:math';

abstract class ImageHelper {
  static int limitFileSize = 1000000;

  static Future<int> getFileSize(String filepath) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return 0;
    return bytes;
  }

  static Future<File> moveFile(File sourceFile, String newPath) async {
    deleteFile(newPath);

    File returnFile;

    try {
      // prefer using rename as it is probably faster
      returnFile = await sourceFile.rename(newPath);
    } on FileSystemException catch (_) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      returnFile = newFile;
    }

    return returnFile;
  }

  static void deleteFile(String path) async {
    if (File(path).existsSync()) {
      await File(path).delete();
    }
  }
}
