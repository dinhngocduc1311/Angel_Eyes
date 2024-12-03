import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class DepthEstimator {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('your_model.tflite');
  }

  Future<Uint8List> predictDepth(Uint8List inputImageBytes) async {
    // Preprocess input image
    final input = _preprocessImage(inputImageBytes);

    // Allocate output buffer
    final output = List.filled(input.length, 0.0).reshape([1, 256, 256]); // Change dimensions based on model

    // Run inference
    _interpreter.run(input, output);

    // Postprocess output
    return _postprocessOutput(output);
  }

  List<List<List<double>>> _preprocessImage(Uint8List inputImageBytes) {
    // Convert image bytes to a usable format
    final image = img.decodeImage(inputImageBytes);
    if (image == null) {
      throw Exception("Invalid input image");
    }

    // Resize image to model's input size (e.g., 256x256)
    final resizedImage = img.copyResize(image, width: 256, height: 256);

    // Normalize pixel values to [0, 1]
    return List.generate(resizedImage.height, (y) {
      return List.generate(resizedImage.width, (x) {
        final pixel = resizedImage.getPixel(x, y);
        final r = img.getRed(pixel) / 255.0;
        final g = img.getGreen(pixel) / 255.0;
        final b = img.getBlue(pixel) / 255.0;
        return [r, g, b];
      });
    });
  }

  Uint8List _postprocessOutput(List<List<List<double>>> output) {
    // Convert normalized depth values back to an image format (grayscale)
    final depthImage = img.Image(output[0][0].length, output[0].length);
    for (int y = 0; y < depthImage.height; y++) {
      for (int x = 0; x < depthImage.width; x++) {
        final depthValue = (output[0][y][x] * 255).toInt();
        depthImage.setPixel(x, y, img.getColor(depthValue, depthValue, depthValue));
      }
    }
    return Uint8List.fromList(img.encodePng(depthImage));
  }
}

class DepthMapView extends StatelessWidget {
  final Uint8List depthMap;

  const DepthMapView({required this.depthMap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Depth Map View'),
      ),
      body: Center(
        child: Image.memory(depthMap, fit: BoxFit.cover),
      ),
    );
  }
}

//testing
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final depthEstimator = DepthEstimator();
  await depthEstimator.loadModel();

  // simulated image input
  final inputImageBytes = Uint8List(0); // can be replace
  final depthMap = await depthEstimator.predictDepth(inputImageBytes);

  runApp(MaterialApp(
    home: DepthMapView(depthMap: depthMap),
  ));
}
