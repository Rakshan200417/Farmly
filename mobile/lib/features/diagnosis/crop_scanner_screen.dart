import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import 'processing_diagnosis_screen.dart';

class CropScannerScreen extends StatefulWidget {
  const CropScannerScreen({super.key});

  @override
  State<CropScannerScreen> createState() => _CropScannerScreenState();
}

class _CropScannerScreenState extends State<CropScannerScreen> {
  String _selectedCrop = 'Paddy (Rice)';
  final List<String> _crops = ['Paddy (Rice)', 'Tomato', 'Green Chili', 'Big Onion', 'Potato'];
  final ImagePicker _picker = ImagePicker();

  void _capturePhoto() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProcessingDiagnosisScreen(cropName: _selectedCrop),
      ),
    );
  }

  Future<void> _pickGalleryPhoto() async {
    try {
      final photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProcessingDiagnosisScreen(cropName: _selectedCrop),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _capturePhoto();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera Viewfinder Background Simulation
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?w=800',
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.45),
                colorBlendMode: BlendMode.darken,
              ),
            ),

            // Top Controls & Crop Selector
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Auto-Flash', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.help_outline, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Crop Selection Horizontal Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _crops.map((crop) {
                        final isSelected = _selectedCrop == crop;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(crop),
                            selected: isSelected,
                            selectedColor: FarmlyColors.warmAmber,
                            backgroundColor: Colors.black54,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? FarmlyColors.textPrimary : Colors.white,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCrop = crop;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Centered Scanner Reticle Target
            Center(
              child: Container(
                width: 270,
                height: 310,
                decoration: BoxDecoration(
                  border: Border.all(color: FarmlyColors.warmAmber, width: 2.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Corner accents
                    _buildCornerAccent(top: 0, left: 0),
                    _buildCornerAccent(top: 0, right: 0),
                    _buildCornerAccent(bottom: 0, left: 0),
                    _buildCornerAccent(bottom: 0, right: 0),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Align affected leaf here',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Shutter & Gallery Controls
            Positioned(
              bottom: 36,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Gallery Pick
                  IconButton(
                    icon: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 30),
                    onPressed: _pickGalleryPhoto,
                  ),

                  // Big Center Shutter Button
                  GestureDetector(
                    onTap: _capturePhoto,
                    child: Container(
                      width: 76,
                      height: 76,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.5),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: FarmlyColors.warmAmber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: FarmlyColors.textPrimary, size: 32),
                      ),
                    ),
                  ),

                  // Flip Camera
                  IconButton(
                    icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerAccent({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: FarmlyColors.leafGreen,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
