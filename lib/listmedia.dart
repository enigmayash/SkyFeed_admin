import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'MediaPlayerPage.dart';

class ListmediaUploadPage extends StatefulWidget {
  const ListmediaUploadPage({super.key});

  @override
  _ListmediaUploadPageState createState() => _ListmediaUploadPageState();
}

class _ListmediaUploadPageState extends State<ListmediaUploadPage> {
  List<String> _mediaURLs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUploadedMedia();
  }

  Future<void> _fetchUploadedMedia() async {
    try {
      ListResult result = await Amplify.Storage.list();
      List<String> mediaURLs = [];
      for (StorageItem item in result.items) {
        GetUrlResult urlResult = await Amplify.Storage.getUrl(
          key: item.key,
          options: S3GetUrlOptions(accessLevel: StorageAccessLevel.private),
        );
        mediaURLs.add(urlResult.url);
      }
      setState(() {
        _mediaURLs = mediaURLs;
        _isLoading = false;
      });
    } catch (e) {
      print("error fecthing media $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch media')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Media'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _mediaURLs.isEmpty
              ? const Center(child: Text('No media uploaded'))
              : ListView.builder(
                  itemCount: _mediaURLs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Media ${index + 1}'),
                      subtitle: Text(_mediaURLs[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mediaplayerpage(
                              videoUrl: _mediaURLs[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
