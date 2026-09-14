import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/farmly_providers.dart';
import '../shops/nearby_shops_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';

class DiagnosisResultScreen extends StatefulWidget {
  final String cropName;

  const DiagnosisResultScreen({super.key, required this.cropName});

  @override
  State<DiagnosisResultScreen> createState() => _DiagnosisResultScreenState();
}

class _DiagnosisResultScreenState extends State<DiagnosisResultScreen> {
  final TextEditingController _landController = TextEditingController(text: '1.0');
  bool _isAcres = true;
  Map<String, String>? _dosageCalculation;

  @override
  void initState() {
    super.initState();
    _calculateDosage();
  }

  @override
  void dispose() {
    _landController.dispose();
    super.dispose();
  }

  void _calculateDosage() {
    final amount = double.tryParse(_landController.text) ?? 1.0;
    final result = context.read<FarmlyDataProvider>().calculateDosage(
      landAmount: amount,
      isAcres: _isAcres,
      perchGrams: 15.0, // standard rate
    );
    setState(() {
      _dosageCalculation = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final diagnosis = context.watch<FarmlyDataProvider>().sampleDiagnosis;

    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Diagnosis Result',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: FarmlyColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Warning Banner (Terracotta Red)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: FarmlyColors.alertRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      diagnosis.warningBanner,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Primary Diagnosis Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leaf Photo
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?w=800',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges: SEVERE & 87% Confidence
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: FarmlyColors.alertRed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                diagnosis.severity,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: FarmlyColors.leafGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_outline, color: Colors.white, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${diagnosis.confidencePercent.toInt()}% Confidence',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Disease Name
                        Text(
                          diagnosis.diseaseName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: FarmlyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          diagnosis.scientificName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: FarmlyColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          diagnosis.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: FarmlyColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section: Recommended Treatments
            const Text(
              'Recommended Treatments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: FarmlyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Organic Treatment Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.eco, color: FarmlyColors.deepTeal, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Organic',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FarmlyColors.deepTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTreatmentDetail(diagnosis.organicTreatments[0].name, diagnosis.organicTreatments[0].instruction),
                  const Divider(height: 20),
                  _buildTreatmentDetail(diagnosis.organicTreatments[1].name, diagnosis.organicTreatments[1].instruction),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Chemical Treatment Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.science_outlined, color: FarmlyColors.warmAmber, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Chemical',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FarmlyColors.warmAmber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTreatmentDetail(diagnosis.chemicalTreatments[0].name, diagnosis.chemicalTreatments[0].instruction),
                  const Divider(height: 20),
                  _buildTreatmentDetail(diagnosis.chemicalTreatments[1].name, diagnosis.chemicalTreatments[1].instruction),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sri Lankan Land & Dosage Calculator Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: FarmlyColors.leafGreen.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: FarmlyColors.lightGreenOverlay,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.calculate, color: FarmlyColors.leafGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sri Lankan Dosage Calculator',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: FarmlyColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _landController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Land Area',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          onChanged: (_) => _calculateDosage(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: FarmlyColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: FarmlyColors.border),
                        ),
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('Acres'),
                              selected: _isAcres,
                              selectedColor: FarmlyColors.leafGreen,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _isAcres ? Colors.white : FarmlyColors.textPrimary,
                              ),
                              onSelected: (val) {
                                setState(() {
                                  _isAcres = true;
                                });
                                _calculateDosage();
                              },
                            ),
                            ChoiceChip(
                              label: const Text('Perches'),
                              selected: !_isAcres,
                              selectedColor: FarmlyColors.leafGreen,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: !_isAcres ? Colors.white : FarmlyColors.textPrimary,
                              ),
                              onSelected: (val) {
                                setState(() {
                                  _isAcres = false;
                                });
                                _calculateDosage();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_dosageCalculation != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: FarmlyColors.lightGreenOverlay,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Quantity: ${_dosageCalculation!['totalProduct']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: FarmlyColors.leafGreen),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Water Required: ${_dosageCalculation!['waterVolume']} (${_dosageCalculation!['sprayTanks']})',
                            style: const TextStyle(fontSize: 12, color: FarmlyColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Button 1: Find Nearby Shops (Warm Amber)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FarmlyColors.warmAmber,
                  foregroundColor: FarmlyColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.storefront, size: 20),
                label: const Text(
                  'Find nearby shops with this treatment',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NearbyShopsScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Action Button 2: Ask Farmly AI about this diagnosis (Deep Teal)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: FarmlyColors.deepTeal,
                  side: const BorderSide(color: FarmlyColors.deepTeal, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: const Text(
                  '💬 Ask Farmly AI about this diagnosis',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AiAssistantScreen(
                        initialPrompt: 'I scanned my ${widget.cropName} and got diagnosed with ${diagnosis.diseaseName}. What precautions should I take before spraying?',
                        diseaseContext: diagnosis.diseaseName,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Link: Report inaccurate diagnosis
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Diagnosis feedback submitted for expert review.')),
                  );
                },
                child: const Text(
                  'Not accurate? Report this diagnosis',
                  style: TextStyle(color: FarmlyColors.deepTeal, fontSize: 13, decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentDetail(String name, String instruction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: FarmlyColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          instruction,
          style: const TextStyle(
            fontSize: 13,
            color: FarmlyColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
