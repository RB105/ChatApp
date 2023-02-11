import 'dart:io';

import 'package:chatapp/core/widgets/show_message.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static ImageSource camera = ImageSource.camera;
  static ImageSource gallery = ImageSource.gallery;

  static File? selectedImage;
  static XFile? image;

  static Future<void> selectImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(source: source);
      File? img = File(image!.path);
      selectedImage = img;
    } catch (e) {
      showMessageHelper(e.toString());
    }
  }
}
