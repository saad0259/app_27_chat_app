import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickUserImage() async {
    print('hi');
    final ImagePicker _picker = ImagePicker();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Select an Image'),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      print('---------- before setState');
                      if (image == null) {
                        return;
                      }
                      setState(() {
                        print('---------- inside setState');
                        _pickedImage = File(image.path);
                      });
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
                    },
                    child: Text('Capture')),
              ],
            ));

    print('End of pick Image');
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
