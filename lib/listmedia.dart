import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'MediaPlayerPage.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';


class ListmediaUploadPage extends StatefulWidget {
  const ListmediaUploadPage({super.key});

  @override
  ListmediaUploadPageState createState() => ListmediaUploadPageState();
}

class ListmediaUploadPageState extends State<ListmediaUploadPage> {
  List<String> _mediaURLs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUploadedMedia();
  }

  Future<void> _fetchUploadedMedia() async {
    try {
      List<String> fetchedUrls = [];
      String? nextToken;
      bool hasNextPage;
      do {
        final result = await Amplify.Storage.list(
          path: const StoragePath.fromString('public/'),
          options: StorageListOptions(
            pageSize: 50,
            nextToken: nextToken,
            pluginOptions: const S3ListPluginOptions(
              excludeSubPaths: true,
              delimiter: '/',
            ),
          ),
        ).result;
        
        // Process the items and add them to fetchedUrls
        for (var item in result.items) {
          final key = item.path;
           
            // Generate a pre-signed URL for each item
            final urlResult = await Amplify.Storage.getUrl(
              path: StoragePath.fromString(key),
              options: const StorageGetUrlOptions(
                pluginOptions: S3GetUrlPluginOptions(
                  expiresIn: Duration(hours: 1),
                ),
              ),
            ).result;

            fetchedUrls.add(urlResult.url.toString()); // Store the video URL directly
          }
        
        
        nextToken = result.nextToken;
        hasNextPage = result.hasNextPage;
      } while (hasNextPage);

      setState(() {
        _mediaURLs = fetchedUrls;
        _isLoading = false;
      });
    } on StorageException catch (e) {
      print('Error fetching media: ${e.message}');
      setState(() {
        _isLoading = false;
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
              context.go('/'); // Navigate to home if can't pop
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
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector( // Make the app name clickable
                  onTap: () {
                    context.go('/'); // Navigate to home page
                  },
                  child: const Text(
                    'SkyFeed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Text(
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
                            leading: SizedBox( // Use SizedBox to define a fixed size
                              width: 50, // Set a fixed width
                              height: 50, // Set a fixed height
                              child: Image.file(File(_mediaURLs[index]), fit: BoxFit.cover), // Display video thumbnail
                            ),
                            title: Text(
                              'Media ${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MediaPlayerPage(
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
