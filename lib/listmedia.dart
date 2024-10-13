import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'MediaPlayerPage.dart';
import 'package:go_router/go_router.dart';

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
    final result = await Amplify.Storage.getUrl(
      path: const StoragePath.fromString('public/example.txt'),
      options: const StorageGetUrlOptions(
        pluginOptions: S3GetUrlPluginOptions(
          validateObjectExistence: true,
          expiresIn: Duration(days: 1),
        ),
      ),
    ).result;
    safePrint('url: ${result.url}');
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
                  'Uploaded Media',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _mediaURLs.isEmpty
                    ? const Center(
                        child: Text(
                          'No media uploaded',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _mediaURLs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              'Media ${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              _mediaURLs[index],
                              style: const TextStyle(color: Colors.white70),
                            ),
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
          ),
        ],
      ),
    );
  }
}
