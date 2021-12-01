

import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploader extends StatefulWidget {
  const ImageUploader({Key? key}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  String? imageURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),),
      body: SingleChildScrollView(
        child: Column(
          children:[
            (imageURL!=null)
            ? Image.network(imageURL!)
                :
                Placeholder(fallbackHeight: 100.0,fallbackWidth: double.infinity,),
            const SizedBox(height:20),
            RaisedButton(
                onPressed: () => uploadImage(),
                child: const Text('Upload Button'),
                color: Colors.lightBlue,
            )


          ]
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker  = ImagePicker();
    PickedFile image;

    //Check permission
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if(permissionStatus.isGranted){
      //select image
      image = (await _picker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);
      if (image !=null){
        //upload to firebase
        var snapshot = await _storage.ref()
            .child('folderName/imageName')
            .putFile(file)
            .whenComplete(() => null);

            var downloadURL = await snapshot.ref.getDownloadURL();

            setState(() {
              imageURL = downloadURL;
            });

      }else{
        print('No Path Recieved');
      }

    }
    else{
      print('Grant permission and try again');
    }






  }
}
