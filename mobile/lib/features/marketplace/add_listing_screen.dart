import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  String _selectedCrop = 'Paddy (Rice)';
  String _selectedUnit = '50kg Bags';
  String _selectedGrade = 'Grade A (Premium)';

  final TextEditingController _varietyController = TextEditingController(text: 'Samba Variety');
  final TextEditingController _qtyController = TextEditingController(text: '50');
  final TextEditingController _priceController = TextEditingController(text: '115');
  final TextEditingController _locationController = TextEditingController(text: 'Thirappane, Anuradhapura');

  final List<String> _crops = [
    'Paddy (Rice)',
    'Tomato',
    'Green Chili',
    'Big Onion',
    'Red Onion',
    'Carrot',
    'Long Beans',
  ];

  @override
  void dispose() {
    _varietyController.dispose();
    _qtyController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _publishListing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produce listing published successfully to Farmly Marketplace!'),
        backgroundColor: FarmlyColors.leafGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmlyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FarmlyColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Listing',
          style: TextStyle(fontWeight: FontWeight.bold, color: FarmlyColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Photos Box
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: FarmlyColors.border, style: BorderStyle.solid),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: FarmlyColors.lightGreenOverlay,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_a_photo_outlined, color: FarmlyColors.leafGreen, size: 28),
                    ),
                    const SizedBox(height: 8),
                    const Text('Upload Produce Photos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Up to 4 images (JPG, PNG)', style: TextStyle(fontSize: 11, color: FarmlyColors.textSecondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Crop Selector
            _buildLabel('Crop Type *'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCrop,
                  items: _crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCrop = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Variety
            _buildLabel('Variety / Cultivar'),
            TextField(
              controller: _varietyController,
              decoration: const InputDecoration(hintText: 'e.g. Samba, Keeri Samba, MI-2'),
            ),
            const SizedBox(height: 16),

            // Quantity and Unit Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Quantity *'),
                      TextField(
                        controller: _qtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '50'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Unit *'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: FarmlyColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedUnit,
                            items: ['kg', '50kg Bags', 'Tons'].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedUnit = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quality Grade
            _buildLabel('Quality Grade'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: FarmlyColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedGrade,
                  items: ['Grade A (Premium)', 'Standard Market Grade', 'Organic Certified'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGrade = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Asking Price
            _buildLabel('Expected Price (Rs. per unit) *'),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'Rs. ',
                hintText: '110',
              ),
            ),
            const SizedBox(height: 16),

            // Location
            _buildLabel('Pickup Location *'),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location, color: FarmlyColors.leafGreen),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Publish Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: FarmlyColors.warmAmber,
                  foregroundColor: FarmlyColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _publishListing,
                child: const Text(
                  'Publish Listing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: FarmlyColors.textPrimary),
      ),
    );
  }
}
