import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:send/controller/image_picker_controller.dart';

class ImagePickerWidget extends StatefulWidget {
  final TextEditingController imagePath;
  final Image? image;
  const ImagePickerWidget({Key? key, required this.imagePath, this.image})
      : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? imagePicker;
  FileImage? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 100,
      backgroundImage:
          (widget.image == null) ? image : (image ?? widget.image!.image),
      child: IconButton(
          onPressed: () async {
            imagePicker = await getImage();

            if (imagePicker != null) {
              widget.imagePath.text = imagePicker!.path;
              setState(() {
                image = FileImage(File(imagePicker!.path));
              });
            }
          },
          icon: Icon(Icons.camera_alt,
              size: 50, color: Theme.of(context).primaryColor.withAlpha(90))),
    );
  }
}
