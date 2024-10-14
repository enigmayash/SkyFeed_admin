import 'package:flutter/material.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:aws_common/aws_common.dart';
import 'package:file_picker/file_picker.dart';


class MediaUploadPage extends StatefulWidget{
  const MediaUploadPage({super.key});

  @override 
  _MediaUploadPageState createState() => _MediaUploadPageState();
}
class _MediaUploadPageState extends State<MediaUploadPage>{
  bool _isUploading = false;
  String _uploadStatus = '';
  String? _uploadedFileKey;

  Future<void> _uploadMedia() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.single.path == null) {
        setState(() {
          _uploadStatus = 'No file selected';
        });
        return;
      }

      setState(() {
        _isUploading = true;
        _uploadStatus = 'Uploading...';
      });

      // Use Amplify's uploadFile functionality
      final uploadResult = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(result.files.single.path!),
        path:  StoragePath.fromString('public/${result.files.single.name}'),
        options: const StorageUploadFileOptions(
          metadata: {'key': 'value'},
          pluginOptions: S3UploadFilePluginOptions(
            getProperties: true,
          ),
        ),
      ).result;

      setState(() {
        _isUploading = false;
        _uploadStatus = 'Upload successful!';
        _uploadedFileKey = uploadResult.uploadedItem.path;
      });

      safePrint('Uploaded file: ${uploadResult.uploadedItem.path}');
    } on StorageException catch (e) {
      safePrint('Error uploading file: ${e.message}');
      setState(() {
        _isUploading = false;
        _uploadStatus = 'Upload failed: ${e.message}';
      });
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
                if (_uploadedFileKey != null)
                  Text(
                    'Uploaded file key: $_uploadedFileKey',
                    style: const TextStyle(color: Colors.white),
                  ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadMedia,
                  child: const Text('Upload Media'),
                ),
                Text(
                  _uploadStatus,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
