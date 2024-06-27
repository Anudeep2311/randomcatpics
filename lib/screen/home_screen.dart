import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catdemo/models/random_image_model.dart';
import 'package:catdemo/provider/random_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Consumer<RandomCatImageProvider>(
          builder: (context, provider, _) {
            if (provider.randomModel == null) {
              provider.fetchRandomImage();
              return const CircularProgressIndicator();
            } else {
              RandomModel randomModel = provider.randomModel!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: randomModel.url!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => _saveImage(context, randomModel.url!),
                    child: const Text("Download"),
                  )
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<RandomCatImageProvider>(context, listen: false)
              .fetchRandomImage();
        },
        tooltip: 'Fetch Random Image',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/image.png';
        final file = File(imagePath);
        await file.writeAsBytes(bytes);

        final result = await ImageGallerySaver.saveFile(imagePath);
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image Saved To Gallery')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download image')),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error saving image")));
    }
  }
}
