import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ColorScanner extends StatefulWidget {
  @override
  _ColorScannerState createState() => _ColorScannerState();
}

class _ColorScannerState extends State<ColorScanner> {
  File? _image;
  ui.Image? _uiImage;
  Color? tappedColor;
  String? colorName;
  String detectedObject = "";

  static const String flaskServerUrl = "http://192.168.1.134:5000/detect"; // Replace with your Flask server IP

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _loadImage();
      _detectObject();
    }
  }

  Future<void> _loadImage() async {
    final imageBytes = await _image!.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    setState(() {
      _uiImage = frame.image;
    });
  }

  void _detectTappedColor(Offset localPosition, BuildContext context) async {
    if (_uiImage == null || context.size == null) return;

    double scaleX = _uiImage!.width / context.size!.width;
    double scaleY = _uiImage!.height / context.size!.height;

    int x = (localPosition.dx * scaleX).toInt();
    int y = (localPosition.dy * scaleY).toInt();

    final ByteData? byteData = await _uiImage!.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData != null) {
      Uint8List pixels = byteData.buffer.asUint8List();
      int index = ((y * _uiImage!.width + x) * 4);

      if (index >= 0 && index + 3 < pixels.length) {
        int r = pixels[index];
        int g = pixels[index + 1];
        int b = pixels[index + 2];

        setState(() {
          tappedColor = Color.fromRGBO(r, g, b, 1);
          colorName = getNearestColorName(tappedColor!);
        });
      }
    }
  }

  Future<void> _detectObject() async {
    if (_image == null) return;
    var request = http.MultipartRequest("POST", Uri.parse(flaskServerUrl));
    request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);
      List<dynamic> objects = jsonData["detections"] ?? [];

      setState(() {
        detectedObject = objects.isNotEmpty ? objects[0]["class"] : "No objects detected";
      });
    }
  }

  String getNearestColorName(Color color) {
    HSVColor hsvColor = HSVColor.fromColor(color);
    double hue = hsvColor.hue;
    double saturation = hsvColor.saturation;
    double brightness = hsvColor.value;

    if (brightness < 0.2) return "Black";
    if (saturation < 0.2 && brightness > 0.8) return "White";
    if (saturation < 0.2) return "Gray";
    if (hue >= 0 && hue < 15 || hue >= 345) return brightness > 0.5 ? "Light Red" : "Red";
    if (hue >= 15 && hue < 45) return brightness > 0.5 ? "Light Orange" : "Orange";
    if (hue >= 45 && hue < 75) return brightness > 0.5 ? "Light Yellow" : "Yellow";
    if (hue >= 75 && hue < 150) return brightness > 0.5 ? "Light Green" : "Green";
    if (hue >= 150 && hue < 210) return brightness > 0.5 ? "Light Cyan" : "Cyan";
    if (hue >= 210 && hue < 270) return brightness > 0.5 ? "Light Blue" : "Blue";
    if (hue >= 270 && hue < 330) return brightness > 0.5 ? "Light Purple" : "Purple";
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color & Object Scanner")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image != null
                  ? GestureDetector(
                      onTapDown: (details) => _detectTappedColor(details.localPosition, context),
                      child: Image.file(_image!, height: 300),
                    )
                  : Container(height: 300, color: Colors.grey[300]),
              SizedBox(height: 20),
              if (tappedColor != null)
                Column(
                  children: [
                    Text("Tapped Color: ${colorName ?? 'Unknown'}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(width: 50, height: 50, decoration: BoxDecoration(color: tappedColor, shape: BoxShape.circle)),
                    SizedBox(height: 30),
                  ],
                ),
              
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => _pickImage(ImageSource.camera), child: Text("Capture Image")),
                  ElevatedButton(onPressed: () => _pickImage(ImageSource.gallery), child: Text("Pick from Gallery")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

