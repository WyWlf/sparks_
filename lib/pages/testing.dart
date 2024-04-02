import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sparks/models/post.dart';
import 'package:sparks/services/remote_services.dart';
import 'package:image/image.dart' as imglib;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  List<Welcome>? posts;

  var isLoaded = false;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    posts = await RemoteService().getPosts();
    setState(() {
      isLoaded = true;
    });
  }

  Widget _buildImageFromBase64(String base64ImageString) {
    if (base64ImageString.isEmpty) return Container();

    try {
      final imageBytes = base64Decode(base64ImageString);
      final image = imglib.decodeImage(imageBytes);
      if (image == null) {
        return const Text('Error: Invalid image data.');
      }

      return Image.memory(
        base64Decode(base64ImageString),
        width: 100, // Adjust width as needed
        fit: BoxFit.cover,
      );
      // Adjust fit as needed
    } catch (error) {
      print('Error decoding image: $error');
      // Handle error gracefully, e.g., display a placeholder image
      return const Text('Error: Could not load image.'); // Placeholder text
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
          itemCount: posts?.length ?? 0, // Use null-check operator (??)
          itemBuilder: (context, index) {
            final post = posts?[index]; // Use null-safe access
            if (post != null) {
              // Access post properties here
              return Column(children: [
                Text(post.row[0].sectionName),
                Text(post.row[1].sectionName),
                if (post.row[0].sectionImg != null)
                  Image.memory(
                    base64Decode('post.row[0].sectionImg!'),
                    height: 100,
                  ),
              ]

                  // Assuming Welcome has a property
                  );
            } else {
              return const Text(
                  'Error: No data found'); // Handle empty list case
            }
          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
