import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');  // Navigate to home if can't pop
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // App Name (top left) and Page Name (top right)
          const Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  'SkyFeed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'Upload Media',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_mediaFile != null)
                  Text(
                    'Media Selected: ${_mediaFile?.path.split('/').last}',
                    style: const TextStyle(color: Colors.white),
                  ),
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
        ],
      ),
    );
  }
}
