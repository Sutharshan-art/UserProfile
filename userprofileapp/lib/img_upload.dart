import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile;
  File _imageGalleryFile;

  final picker = ImagePicker();

  //uploading image from the camera

  Future pickImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  //iploading image from the gallery

  Future pickImageGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _imageGalleryFile = File(pickedFile.path);
    });
  }

  //uploading image from the camera

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  //uploading image from the gallery

  Future uploadGalleryImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageGalleryFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask =
        firebaseStorageRef.putFile(_imageGalleryFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Uploading Image to Firebase Storage",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
// uploading image from the camera UI design
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 100.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: _imageFile != null
                                ? Image.file(_imageFile)
                                : FlatButton(
                                    color: Colors.blue[100],
                                    child: Text('Pick from Camera'),
                                    onPressed: pickImage,
                                  ),
                          ),
                        ),
                      ),
//uploading image from the gallery UI design
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 350.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: _imageGalleryFile != null
                                ? Image.file(_imageGalleryFile)
                                : FlatButton(
                                    color: Colors.blue[100],
                                    child: Text('Pick from Gallery'),
                                    onPressed: pickImageGallery,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () => uploadImageToFirebase(context),
              child: Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
