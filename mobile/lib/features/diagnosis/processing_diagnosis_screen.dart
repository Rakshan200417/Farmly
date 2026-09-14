import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'diagnosis_result_screen.dart';

class ProcessingDiagnosisScreen extends StatefulWidget {
  final String cropName;

  const ProcessingDiagnosisScreen({super.key, required this.cropName});

  @override
  State<ProcessingDiagnosisScreen> createState() => _ProcessingDiagnosisScreenState();
}

class _ProcessingDiagnosisScreenState extends State<ProcessingDiagnosisScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _animation;
  String _statusText = 'Running on-device TensorFlow Lite model...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _statusText = 'Evaluating symptoms & disease patterns...';
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DiagnosisResultScreen(cropName: widget.cropName),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmlyColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: FarmlyColors.lightGreenOverlay,
                    shape: BoxShape.circle,
                    border: Border.all(color: FarmlyColors.leafGreen, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: FarmlyColors.leafGreen.withValues(alpha: 0.2),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.biotech,
                      size: 56,
                      color: FarmlyColors.leafGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Analyzing ${widget.cropName}...',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: FarmlyColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: FarmlyColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 140,
                child: LinearProgressIndicator(
                  color: FarmlyColors.warmAmber,
                  backgroundColor: FarmlyColors.border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
