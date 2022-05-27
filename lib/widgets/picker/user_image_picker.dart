import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _storedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    PickedFile imageFile = await picker.getImage(
      imageQuality: 50,
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 150,
    );

    setState(() {
      _storedImage = File(imageFile.path);
    });
    widget.imagePickFn(_storedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[800],
          backgroundImage:
              _storedImage != null ? FileImage(_storedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.photo_camera),
          label: Text(
            'Add image',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          textColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
