import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ColorBlindnessSimulation extends StatefulWidget {
  final CameraController cameraController;

  ColorBlindnessSimulation(this.cameraController);

  @override
  _ColorBlindnessSimulationState createState() => _ColorBlindnessSimulationState();
}

class _ColorBlindnessSimulationState extends State<ColorBlindnessSimulation> {
  CameraImage? _cameraImage;
  String selectedMode = "Protanopia"; // Default mode

  @override
  void initState() {
    super.initState();
    widget.cameraController.startImageStream((CameraImage image) {
      if (mounted) {
        setState(() {
          _cameraImage = image;
        });
      }
    });
  }

  @override
  void dispose() {
    widget.cameraController.stopImageStream();
    super.dispose();
  }

  /// Convert CameraImage (YUV420) to RGB Uint8List
  Uint8List convertCameraImageToRGB(CameraImage cameraImage) {
    int width = cameraImage.width;
    int height = cameraImage.height;
    Uint8List bytes = cameraImage.planes[0].bytes;

    img.Image image = img.Image(width, height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int pixelIndex = y * width + x;
        int r = bytes[pixelIndex];
        int g = bytes[pixelIndex];
        int b = bytes[pixelIndex];
        image.setPixel(x, y, img.getColor(r, g, b));
      }
    }
    return Uint8List.fromList(img.encodeJpg(image));
  }

  /// Apply color blindness filter
  Uint8List applyColorBlindnessFilter(Uint8List imageBytes, String mode) {
    img.Image image = img.decodeImage(imageBytes)!;

    List<List<double>> matrix = [];
    switch (mode) {
      case "Protanopia":
        matrix = [
          [0.567, 0.433, 0.0],
          [0.558, 0.442, 0.0],
          [0.0, 0.242, 0.758]
        ];
        break;
      case "Deuteranopia":
        matrix = [
          [0.625, 0.375, 0.0],
          [0.7, 0.3, 0.0],
          [0.0, 0.3, 0.7]
        ];
        break;
      case "Tritanopia":
        matrix = [
          [0.95, 0.05, 0.0],
          [0.0, 0.433, 0.567],
          [0.0, 0.475, 0.525]
        ];
        break;
      default:
        return imageBytes;
    }

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);

        int newR = (r * matrix[0][0] + g * matrix[0][1] + b * matrix[0][2]).toInt();
        int newG = (r * matrix[1][0] + g * matrix[1][1] + b * matrix[1][2]).toInt();
        int newB = (r * matrix[2][0] + g * matrix[2][1] + b * matrix[2][2]).toInt();

        image.setPixelRgba(x, y, newR, newG, newB);
      }
    }

    return Uint8List.fromList(img.encodeJpg(image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Blindness Simulation")),
      body: Column(
        children: [
          if (_cameraImage != null)
            Expanded(
              child: FutureBuilder<Uint8List>(
                future: Future.value(
                    applyColorBlindnessFilter(convertCameraImageToRGB(_cameraImage!), selectedMode)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!);
                  }
                  return Center(child: Text("No Image Available"));
                },
              ),
            ),
          DropdownButton<String>(
            value: selectedMode,
            items: ["Protanopia", "Deuteranopia", "Tritanopia"]
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (newMode) {
              setState(() {
                selectedMode = newMode!;
              });
            },
          ),
        ],
      ),
    );
  }
}
