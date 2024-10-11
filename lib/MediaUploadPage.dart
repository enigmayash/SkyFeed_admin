import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
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

  Future<void> uploadFile() async {
  // Select a file from the device
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    withData: false,
    // Ensure to get file stream for better performance
    withReadStream: true,
    allowedExtensions: ['jpg', 'png', 'gif', 'mp4'],
  );

  if (result == null) {
    safePrint('No file selected');
    return;
  }

  // Upload file using the filename
  final platformFile = result.files.single;
  try {
    final result = await Amplify.Storage.uploadFile(
      localFile: AWSFile.fromStream(
        platformFile.readStream!,
        size: platformFile.size,
      ),
      path: StoragePath.fromString('public/${platformFile.name}'),
      onProgress: (progress) {
        safePrint('Fraction completed: ${progress.fractionCompleted}');
      },
    ).result;
    safePrint('Successfully uploaded file: ${result.uploadedItem.path}');
  } on StorageException catch (e) {
    safePrint(e.message);
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
                onPressed: uploadFile,
                child: const Text('Upload Media'),
              ),
          ],
        ),
      ),
    );
  }
}
 
