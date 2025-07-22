import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:math' as math;

class ColorBlindnessSimulator extends StatefulWidget {
  @override
  _ColorBlindnessSimulatorState createState() => _ColorBlindnessSimulatorState();
}

class _ColorBlindnessSimulatorState extends State<ColorBlindnessSimulator> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  ColorFilter? _currentFilter;
  String _selectedMode = "Normal";

  final Map<String, ColorFilter> _filters = {
    "Normal": ColorFilter.mode(Colors.transparent, BlendMode.color),
    "Protanopia": ColorFilter.matrix([
      0.56667, 0.43333, 0, 0, 0,
      0.55833, 0.44167, 0, 0, 0,
      0, 0.24167, 0.75833, 0, 0,
      0, 0, 0, 1, 0
    ]),
    "Tritanopia": ColorFilter.matrix([
      0.95, 0.05, 0, 0, 0,
      0, 0.43333, 0.56667, 0, 0,
      0, 0.475, 0.525, 0, 0,
      0, 0, 0, 1, 0
    ]),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Camera Error: $e");
    }
  }

  void _changeFilter(String mode) {
    setState(() {
      _selectedMode = mode;
      _currentFilter = _filters[mode];
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  double _getRotationAngle() {
    if (!_isCameraInitialized || _cameraController == null) return 0;

    final previewSize = _cameraController!.value.previewSize;
    if (previewSize == null) return 0;

    bool isPortrait = previewSize.height > previewSize.width;
    return isPortrait ? math.pi / 2 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Blindness Simulator")),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: Transform.rotate(
                      angle: _getRotationAngle(),
                      child: ColorFiltered(
                        colorFilter: _currentFilter ?? ColorFilter.mode(Colors.transparent, BlendMode.color),
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Allows scrolling if needed
                    child: Wrap(
                      spacing: 8, // Adds spacing between buttons
                      runSpacing: 8, // Allows buttons to wrap if needed
                      alignment: WrapAlignment.center,
                      children: _filters.keys.map((mode) {
                        return ElevatedButton(
                          onPressed: () => _changeFilter(mode),
                          child: Text(mode),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedMode == mode ? Colors.blue : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
