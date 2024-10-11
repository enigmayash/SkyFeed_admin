import 'dart:io';

import 'package:flutter/material.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class MediaUploadPage extends StatefulWidget{
  const MediaUploadPage({super.key});

  @override 
  _MediaUploadPageState createState() => _MediaUploadPageState();
}
class _MediaUploadPageState extends State<MediaUploadPage>{
  File? _mediaFile;
  Future<void> _pickmedia() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.media,);
    if(result != null && result.files.single.path != null){
      setState(() {
        _mediaFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadMedia() async{
    if(_mediaFile == null) return;
    try{
      String mediaName = _mediaFile!.path.split('/').last;
      S3UploadFileOptions options = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.private,
      );
      await Amplify.Storage.uploadFile(
        local: _mediaFile!,
        key: mediaName,
        options: options,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Media Uploaded succesfully")),);
    }
    catch (e){
      print('upload falied: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Media Uploaded Failed")),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Media'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_mediaFile != null)
              Text('Media Selected: ${_mediaFile?.path.split('/').last}'),
            ElevatedButton(
              onPressed: _pickmedia,
              child: const Text('Pick Media'),
            ),
            if (_mediaFile != null)
              ElevatedButton(
                onPressed: _uploadMedia,
                child: const Text('Upload Media'),
              ),
          ],
        ),
      ),
    );
  }
}
 