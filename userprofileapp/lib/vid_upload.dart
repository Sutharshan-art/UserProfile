import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Storage Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadingVideoToFirebaseStorage(),
    );
  }
}

class UploadingVideoToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingVideoToFirebaseStorageState createState() =>
      _UploadingVideoToFirebaseStorageState();
}

class _UploadingVideoToFirebaseStorageState
    extends State<UploadingVideoToFirebaseStorage> {
  File _videoFile;
  File _videoFileGal;

  final picker = ImagePicker();
  VideoPlayerController _videoPlayerController;
  VideoPlayerController _videoPlayerControllerGallery;

//upload video from camera

  Future pickVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    _videoFile = File(pickedFile.path);

    _videoPlayerController = VideoPlayerController.file(_videoFile)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  //Upload viseo from gallery

  Future pickVideoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    _videoFileGal = File(pickedFile.path);

    _videoPlayerControllerGallery = VideoPlayerController.file(_videoFileGal)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerControllerGallery.play();
      });
  }

  //upload video from camera

  Future uploadVideoToFirebase(BuildContext context) async {
    String fileName = basename(_videoFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('videos/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_videoFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  //Upload video from gallery

  Future uploadGalleryVideoToFirebase(BuildContext context) async {
    String fileName = basename(_videoFileGal.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('videos/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_videoFileGal);
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
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _videoFile != null
                              ? Image.file(_videoFile)
                              : FlatButton(
                                  child: Icon(
                                    Icons.videocam_rounded,
                                    size: 50,
                                  ),
                                  onPressed: pickVideo,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                uploadVideoButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadVideoButton(BuildContext context) {
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
              onPressed: () => uploadVideoToFirebase(context),
              child: Text(
                "Upload Video",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
