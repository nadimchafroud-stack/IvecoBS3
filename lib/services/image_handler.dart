import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageHandler {
  static final ImagePicker picker = ImagePicker();

  /// PICK IMAGE
  static Future<String?> pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return null;

    final File img = File(file.path);
    return await saveImage(img);
  }

  /// SAVE IMAGE INTO APP DIRECTORY
  static Future<String> saveImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final String newPath =
        "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.png";

    final File newImage = await image.copy(newPath);
    return newImage.path;
  }
}
