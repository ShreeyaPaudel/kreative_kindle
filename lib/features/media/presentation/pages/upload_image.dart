import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../view_model/media_viewmodel.dart';

class UploadImagePage extends ConsumerStatefulWidget {
  const UploadImagePage({super.key});

  @override
  ConsumerState<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends ConsumerState<UploadImagePage> {
  File? file;

  Future<void> pickImage() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => file = File(x.path));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mediaViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 180,
              color: Colors.grey.shade200,
              child: file == null
                  ? const Center(child: Text("No image selected"))
                  : Image.file(file!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: file == null
                  ? null
                  : () =>
                        ref.read(mediaViewModelProvider.notifier).upload(file!),
              child: state.loading
                  ? const CircularProgressIndicator()
                  : const Text("Upload"),
            ),
            const SizedBox(height: 12),
            if (state.imageUrl != null)
              Image.network(state.imageUrl!, height: 200),
          ],
        ),
      ),
    );
  }
}
