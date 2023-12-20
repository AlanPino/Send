import 'package:image_picker/image_picker.dart';

Future<XFile?> getImage() async{
  XFile? image;

  image = (await ImagePicker().pickImage(source: ImageSource.gallery));
  return image;
}