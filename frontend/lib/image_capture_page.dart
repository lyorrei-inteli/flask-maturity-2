import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_application/services/tasks_api_service.dart';  // Adjust the import path based on your project structure

class ImageCapturePage extends StatefulWidget {
  const ImageCapturePage({super.key});

  @override
  _ImageCapturePageState createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  File? _image;
  final TasksApiService _apiService = TasksApiService();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _removeBackground(context) async {
    try {
      final File processedImage = await _apiService.removeBackground(_image!);
      setState(() {
        _image = processedImage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fundo removido com sucesso'))
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('Nenhuma imagem selecionada.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Capturar Imagem'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Selecionar da Galeria'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _removeBackground(context),
              child: const Text('Remover Fundo'),
            ),
          ],
        ),
      ),
    );
  }
}
