import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import '../widgets/common_buttons.dart';
// import '../constants.dart';
import 'select_photo_options_screen.dart';

// ignore: must_be_immutable
class UserPhoto extends StatefulWidget {
  var user;
  Function(File) onUpdate;

  UserPhoto({super.key, required this.user, required this.onUpdate});

  static const id = 'set_photo_screen';

  @override
  State<UserPhoto> createState() => _UserPhotoState();
}

class _UserPhotoState extends State<UserPhoto> {
  File? _image;
  // final user = FirebaseAuth.instance.currentUser!;
  late File _imageFile;

  updateImage(File imagefile) {
    // print(imagefile);
    setState(() {
      _imageFile = imagefile;
    });
  }

  Future uploadImageToFirebase() async {
    final _firebaseStorage = FirebaseStorage.instance;
    if (_imageFile == null) return;
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        uiSettings: [
          AndroidUiSettings(
              backgroundColor: Colors.black,
              // toolbarTitle: 'Cropper',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              statusBarColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    if (croppedImage == null) return null;
    widget.onUpdate(File(croppedImage.path));
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSelectPhotoOptions(context),
      child: Stack(children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: widget.user.photoURL != null
              ? Colors.transparent
              : Colors.grey[600],
          child: widget.user.photoURL != null
              ? ClipOval(
                  // borderRadius: BorderRadius.circular(25),
                  // child: Icon(Icons.person)
                  child: _image != null
                      ? Image.file(_image!)
                      : Image.network("${widget.user.photoURL}"))
              // child: Image.file(_image!))
              : _image != null
                  ? ClipOval(
                      // borderRadius: BorderRadius.circular(25),
                      // child: Icon(Icons.person)
                      // child: Image.network("${widget.user.photoURL}"))
                      child: Image.file(_image!))
                  : Icon(
                      CupertinoIcons.person,
                      color: Colors.white,
                      size: 45,
                    ),
        ),
        Positioned(
            bottom: 1,
            right: 7,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white70,
            ))
      ]),
    );
  }
}
