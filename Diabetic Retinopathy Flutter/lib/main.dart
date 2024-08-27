import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DR Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String _result = '';
  bool _isLoading = false;

  Interpreter? _interpreter;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/dr_model.tflite');
    } catch (e) {
      print("Failed to load model: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _runModelOnImage(_image!);
      });
    }
  }

  Future<void> _runModelOnImage(File image) async {
    setState(() => _isLoading = true);
    try {
      // 1. Image Preprocessing
      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      final resizedImage = img.copyResize(
          decodedImage!, width: 224, height: 224);

      final input = List.generate(1, (i) =>
          List.generate(224, (j) =>
              List.generate(224, (k) =>
                  List.generate(3, (l) {
                    final pixel = resizedImage.getPixel(j, k);
                    return [
                      pixel.r / 255.0, // Red
                      pixel.g / 255.0, // Green
                      pixel.b / 255.0, // Blue
                    ][l];
                  }))));

      // 2. Output Tensor
      var output = List.filled(1 * 5, 0.0).reshape(
          [1, 5]); // Output shape [1, 5]

      // 3. Run Inference
      _interpreter?.run(input, output);

      setState(() {
        // Convert probabilities to percentages and format the output
        final percentages = output[0].map((value) =>
        (value * 100).toStringAsFixed(2) + '%').toList();
        final classLabels = [
          'No DR',
          'Mild DR',
          'Moderate DR',
          'Severe DR',
          'Proliferative DR'
        ]; // Replace with your actual class labels
        _result = percentages
            .asMap()
            .entries
            .map((entry) => '${classLabels[entry.key]}: ${entry.value}')
            .join('\n');

        // Determine the situation based on the highest probability
        final highestProbabilityIndex = output[0].indexOf(
            output[0].reduce((a, b) =>
                max<double>(a, b))); // Use the imported max function
        final situation = _getSituation(highestProbabilityIndex);
        _result += '\n\nSituation: $situation';
      });
    } catch (e) {
      print('Error during image processing or inference: $e');
      setState(() {
        _result = 'Error: Could not process image.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getSituation(int classIndex) {
    switch (classIndex) {
      case 0:
        return 'No diabetic retinopathy detected.';
      case 1:
        return 'Mild diabetic retinopathy detected. Regular eye exams are recommended.';
      case 2:
        return 'Moderate diabetic retinopathy detected. Consult an ophthalmologist for further evaluation and treatment.';
      case 3:
        return 'Severe diabetic retinopathy detected. Urgent medical attention is required.';
      case 4:
        return 'Proliferative diabetic retinopathy detected. This is a serious condition requiring immediate treatment.';
      default:
        return 'Unable to determine situation.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DR Detection"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              // TODO: Show help dialog or navigate to help screen
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_image != null) ...[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 12, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement full-screen image view
                      },
                      child: SizedBox(
                        height: 300, // Increased image size
                        child: Hero(
                          tag: 'imageHero',
                          child: Image.file(_image!),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ] else
                ...[
                  const Icon(Icons.image, size: 150, color: Colors.grey),
                  // Larger icon
                  const SizedBox(height: 24),
                  const Text(
                    "No image selected",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              if (_isLoading) ...[
                const CircularProgressIndicator(),
              ] else
                if (_result.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: _result.split('\n').map((line) {
                        final parts = line.split(':');
                        if (parts.length >= 2) {
                          final label = parts[0].trim();
                          final value = parts[1].trim();

                          // Color coding for DR levels
                          Color color = Colors.black;
                          if (label.startsWith('No DR'))
                            color = Colors.green;
                          else if (label.startsWith('Mild DR'))
                            color = Colors.yellow;
                          else if (label.startsWith('Moderate DR'))
                            color = Colors.orange;
                          else if (label.startsWith('Severe DR'))
                            color = Colors.red;
                          else if (label.startsWith('Proliferative DR'))
                            color = Colors.red.shade900;

                          if (label.startsWith('Situation')) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                line,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(color: color),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: double.tryParse(
                                          value.replaceAll('%', ''))! / 100,
                                      color: color,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(value),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Text(line);
                        }
                      }).toList(),
                    ),
                  ),
                ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                icon: const Icon(Icons.photo_library),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}