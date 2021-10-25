import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickUserImage() async {
    final ImagePicker _picker = ImagePicker();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Select an Image'),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          maxWidth: 150);
                      if (image == null) {
                        return;
                      }
                      setState(() {
                        _pickedImage = File(image.path);
                      });
                      widget.imagePickFn(_pickedImage!);
                    },
                    child: Text('Open Gallery')),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (photo == null) {
                        return;
                      }
                      setState(() {
                        _pickedImage = File(photo.path);
                      });
                      widget.imagePickFn(_pickedImage!);
                    },
                    child: Text('Capture')),
              ],
            ));

    // Capture a photo
    //
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          child: _pickedImage == null
              ? Icon(
                  Icons.image,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : null,
        ),
        TextButton(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          child: Text('Add Image'),
          onPressed: _pickUserImage,
        )
      ],
    );
  }
}
