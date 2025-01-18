import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan_alergi/screens/home_screen.dart';
import 'package:scan_alergi/utils/utils.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller; // Controller to manage the camera
  late Future<void>
      _initializeControllerFuture; // Future to manage camera initialization
  late CameraDescription _selectedCamera; // Stores the selected camera
  bool _permissionDenied = false; // Flag to indicate if permission is denied
  File? _capturedImage; // Stores the captured image

  // Initialize camera on widget creation
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final permissionStatus =
        await Permission.camera.request(); // Request camera permissions

    if (!permissionStatus.isGranted) {
      setState(() {
        _permissionDenied =
            true; // Set permissionDenied flag if permission is not granted
      });
      return;
    }

    try {
      final cameras =
          await availableCameras(); // Get the list of available cameras
      _selectedCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back, // Use back camera
        orElse: () => cameras
            .first, // Fallback to the first available camera if back camera is not found
      );

      _controller = CameraController(
        _selectedCamera,
        ResolutionPreset.max,
        enableAudio: false, // Disable audio to avoid mic permissions
      );

      await _controller!.initialize(); // Initialize the camera controller
    } catch (e) {
      LoggerUtil.logger.e(
          'Error initializing camera: $e'); // Handle and log any errors during initialization
    }
  }

  // Dispose of the camera controller when not in use
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Show dialog when camera permission is denied
  void _showCameraPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text('Camera Permission Denied')),
        content: const Text(
          'The camera permission is required to use this feature. Please enable it in your device settings.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
            },
            child: const Text(
                'Settings'), // Redirect user to app settings to enable permissions
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen()), // When user hits "OK", navigate back to HomeScreen
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Captures image using camera
  Future<void> _captureImage() async {
    if (_controller != null) {
      try {
        await _initializeControllerFuture; // Wait for camera initialization to complete
        final image = await _controller!.takePicture(); // Capture the image
        LoggerUtil.logger.d('Photo captured!');
        setState(() {
          _capturedImage = File(image.path); // Store the captured image
        });
      } catch (e) {
        LoggerUtil.logger.e(
            'Error capturing photo: $e'); // Handle and log any errors during image capture
        _resetCamera(); // Ensure the image file is deleted on error
      }
    }
  }

  // Clear the captured image to let user re-take image
  void _resetCamera() async {
    if (_capturedImage != null) {
      try {
        await _capturedImage!.delete(); // Delete the image file
        LoggerUtil.logger.d('Photo deleted.');
      } catch (e) {
        LoggerUtil.logger.e(
            'Error deleting photo: $e'); // Handle and log any errors during image deletion
      }
      setState(() {
        _capturedImage = null;
      });
    }
  }

  // Cancel the image capture
  void _cancelCameraCapture() {
    _resetCamera(); // Ensure the image file is deleted on cancel
    Navigator.of(context)
        .pop(null); // Return null to HomeScreen to indicate cancellation
  }

  @override
  Widget build(BuildContext context) {
    // Fetch screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define dynamic sizes based on screen dimensions
    final buttonSize = screenWidth * 0.15; // 15% of screen width
    final bottomPadding = screenHeight * 0.05; // 5% of screen height

    if (_permissionDenied) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCameraPermissionDeniedDialog();
      });
    }

    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            // Center title
            child: Text('Capture Photo'),
          ),
          automaticallyImplyLeading: false, // Remove the default back arrow
        ),
        body: Column(
          children: [
            // Camera Preview Section
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_controller != null &&
                            _controller!.value.isInitialized) {
                          return _capturedImage == null
                              ? CameraPreview(
                                  _controller!) // Show camera preview if no image is captured
                              : Image.file(
                                  _capturedImage!); // Show captured image
                        } else {
                          return const Center(
                              child: Text(
                                  'Camera not initialized')); // Show error if camera is not initialized
                        }
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Error: ${snapshot.error}')); // Show error if there is an issue with initialization
                      } else {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loading indicator while initializing
                      }
                    },
                  ),
                ],
              ),
            ),

            // Camera Buttons Section
            Padding(
              padding:
                  EdgeInsets.only(bottom: bottomPadding), // Padding from bottom
              child: Align(
                alignment: Alignment.center,
                child: _capturedImage == null
                    ? GestureDetector(
                        onTap: _captureImage, // Capture image on button tap
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(
                                width: buttonSize * 0.07,
                                color: const Color.fromARGB(255, 90, 6,
                                    100)), // Button border - 7% of button size
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // Distribute buttons evenly
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.red), // Cancel button
                            iconSize: buttonSize,
                            onPressed:
                                _cancelCameraCapture, // Return null to HomeScreen
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh,
                                color: Colors.blue), // Redo button
                            iconSize: buttonSize,
                            onPressed: _resetCamera,
                          ),
                          IconButton(
                            icon: const Icon(Icons.check,
                                color: Colors.green), // Confirm button
                            iconSize: buttonSize,
                            onPressed: () {
                              Navigator.of(context).pop(
                                  _capturedImage); // Return the captured image
                            },
                          ),
                        ],
                      ),
              ),
            ),

            // Camera Message Section
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight *
                      0.02), // Vertical Padding - 2% of screen height
              child: const Text(
                'Take a photo of an ingredients label. \n Up Next: Crop your photo!', // Message
                style: TextStyle(
                  color: Color.fromARGB(255, 90, 6, 100), // Text color
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center, // Center the text at the bottom
              ),
            ),
          ],
        ),
      ),
    );
  }
}
